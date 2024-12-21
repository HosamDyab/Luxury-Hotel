import 'package:flutter/material.dart';
import 'package:luxury_hotel/screens/booking/booking_confirmation_screen.dart';
import '../../models/room.dart';
import '../../theme/app_theme.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Room room;

  const BookingScreen({super.key, required this.room});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;
  Room? selectedRoom;
  List<Room> roomList = []; // Assuming you will populate this list elsewhere

  @override
  void initState() {
    super.initState();
    roomList = [widget.room]; // Populate with available rooms
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Room'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Info Card
              Card(
                color: AppTheme.softBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppTheme.primaryGold),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.room.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.room.name,
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${widget.room.price}/night',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Room selection
              const Text('Select Room:', style: TextStyle(fontSize: 18)),
              DropdownButton<Room>(
                value: selectedRoom,
                hint: const Text('Choose a room'),
                items: roomList.map((Room room) {
                  return DropdownMenuItem<Room>(
                    value: room,
                    child: Text(room.name),
                  );
                }).toList(),
                onChanged: (Room? newValue) {
                  setState(() {
                    selectedRoom = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Check-in Date
              const Text('Check-in Date:', style: TextStyle(fontSize: 18)),
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _checkIn ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null && picked != _checkIn) {
                    setState(() {
                      _checkIn = picked;
                    });
                  }
                },
                child: Text(
                    _checkIn == null
                        ? 'Select date'
                        : DateFormat.yMd().format(_checkIn!),
                    style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),

              // Check-out Date
              const Text('Check-out Date:', style: TextStyle(fontSize: 18)),
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _checkOut ?? DateTime.now(),
                    firstDate: _checkIn != null
                        ? _checkIn!.add(const Duration(days: 1))
                        : DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null && picked != _checkOut) {
                    setState(() {
                      _checkOut = picked;
                    });
                  }
                },
                child: Text(
                    _checkOut == null
                        ? 'Select date'
                        : DateFormat.yMd().format(_checkOut!),
                    style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),

              // Number of Guests
              const Text('Number of Guests', style: TextStyle(fontSize: 18)),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_guests > 1) {
                        setState(() {
                          _guests--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove_circle,
                        color: AppTheme.primaryGold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryGold),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _guests.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_guests < widget.room.capacity) {
                        setState(() {
                          _guests++;
                        });
                      }
                    },
                    icon: const Icon(Icons.add_circle,
                        color: AppTheme.primaryGold),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Total Price
              if (_checkIn != null && _checkOut != null)
                Card(
                  color: AppTheme.softBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppTheme.primaryGold),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price Details',
                          style: TextStyle(
                            color: AppTheme.primaryGold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Number of nights:',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${_checkOut!.difference(_checkIn!).inDays}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Price per night:',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '\$${widget.room.price}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const Divider(color: AppTheme.primaryGold),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${widget.room.price * _checkOut!.difference(_checkIn!).inDays}',
                              style: const TextStyle(
                                color: AppTheme.primaryGold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Book Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedRoom == null) {
                        // Handle case where no room is selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select a room to book.')),
                        );
                        // return;
                      }

                      final bookingDetails = {
                        'roomId': selectedRoom,
                        'checkIn': _checkIn,
                        'checkOut': _checkOut,
                        'guests': _guests,
                        'totalPrice': selectedRoom!.price *
                            _checkOut!.difference(_checkIn!).inDays,
                      };
                      // Save booking logic here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmationScreen(
                            bookings: bookingDetails,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Book Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

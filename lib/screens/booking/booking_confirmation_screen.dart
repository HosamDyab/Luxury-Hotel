import 'package:flutter/material.dart';
import 'package:luxury_hotel/models/booking.dart';
import 'package:luxury_hotel/providers/booking_provider.dart';
import 'package:luxury_hotel/screens/booking/booking_history_screen.dart';
import '../../models/room.dart';
import '../../theme/app_theme.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> bookings;

  const BookingConfirmationScreen({super.key, required this.bookings});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final room = widget.bookings['roomId'];
    final checkIn = widget.bookings['checkIn'];
    final checkOut = widget.bookings['checkOut'];
    final guests = widget.bookings['guests'];
    final totalPrice = widget.bookings['totalPrice'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.primaryGold,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Booking Confirmed!',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppTheme.primaryGold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your reservation has been successfully confirmed.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            _buildDetailsCard(
              context,
              title: 'Booking Details',
              children: [
                _buildDetailRow('Room Type', room.name),
                _buildDetailRow('Check-in',
                    '${checkIn.day}/${checkIn.month}/${checkIn.year}'),
                _buildDetailRow('Check-out',
                    '${checkOut.day}/${checkOut.month}/${checkOut.year}'),
                _buildDetailRow('Guests', guests.toString()),
                _buildDetailRow(
                    'Total Price', '\$${totalPrice.toStringAsFixed(2)}'),
                _buildInfoRow('Room Description', room.description),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Booking newBooking = Booking(
                  id: '1',
                  roomId: room.id,
                  userId: '1',
                  checkIn: checkIn,
                  checkOut: checkOut,
                  guests: guests,
                  totalPrice: totalPrice,
                  roomName: room.name,
                );

                BookingProvider.addBooking(newBooking);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BookingHistoryScreen();
                }));
              },
              child: const Text('View Booking History'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
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
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryGold,
                  ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

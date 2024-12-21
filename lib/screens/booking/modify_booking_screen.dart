import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../theme/app_theme.dart';

class ModifyBookingScreen extends StatefulWidget {
  final Booking booking;

  const ModifyBookingScreen({super.key, required this.booking});

  @override
  State<ModifyBookingScreen> createState() => _ModifyBookingScreenState();
}

class _ModifyBookingScreenState extends State<ModifyBookingScreen> {
  late DateTime _checkIn;
  late DateTime _checkOut;
  late int _guests;
  bool _isLoading = false;
  int _maxGuests = 2; // Default max guests
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _checkIn = widget.booking.checkIn;
    _checkOut = widget.booking.checkOut;
    _guests = widget.booking.guests;
    _maxGuests = widget.booking.room?.capacity ?? 2;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : _checkOut,
      firstDate: isCheckIn ? DateTime.now() : _checkIn,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryGold,
              onPrimary: Colors.white,
              surface: AppTheme.darkBlack,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut.isBefore(_checkIn)) {
            _checkOut = _checkIn.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  Future<void> _handleModifyBooking() async {
    if (_checkIn.isAfter(_checkOut)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-out date must be after check-in date'),
          backgroundColor: AppTheme.darkBlack,
        ),
      );
      return;
    }

    if (_guests > _maxGuests) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Number of guests exceeds room capacity'),
          backgroundColor: AppTheme.darkBlack,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Modification'),
        content: const Text('Are you sure you want to modify this booking?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _bookingService.updateBooking(
        Booking(
          id: widget.booking.id,
          userId: widget.booking.userId,
          roomId: widget.booking.roomId,
          checkIn: _checkIn,
          checkOut: _checkOut,
          guests: _guests,
          status: widget.booking.status,
          totalPrice: widget.booking.totalPrice,
          roomName: widget.booking.roomName,
          rating: widget.booking.rating,
          review: widget.booking.review,
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking modified successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error modifying booking: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to modify booking: ${e.toString()}'),
            backgroundColor: AppTheme.darkBlack,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room: ${widget.booking.roomName}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryGold,
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Check-in Date'),
              subtitle: Text(
                '${_checkIn.day}/${_checkIn.month}/${_checkIn.year}',
                style: const TextStyle(color: AppTheme.primaryGold),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            const Divider(),
            ListTile(
              title: const Text('Check-out Date'),
              subtitle: Text(
                '${_checkOut.day}/${_checkOut.month}/${_checkOut.year}',
                style: const TextStyle(color: AppTheme.primaryGold),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const Divider(),
            ListTile(
              title: const Text('Number of Guests'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _guests > 1
                        ? () {
                            setState(() {
                              _guests--;
                            });
                          }
                        : null,
                  ),
                  Text(
                    _guests.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _guests < _maxGuests
                        ? () {
                            setState(() {
                              _guests++;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleModifyBooking,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  static List<Booking> _bookings = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;

  Future<void> fetchBookings(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate fetching bookings from a database or API
      // _bookings = [
      //   Booking(
      //     id: '1',
      //     userId: userId,
      //     roomId: '101', // Placeholder value
      //     roomName: 'Deluxe Room', // Placeholder value
      //     totalPrice: 200.0, // Placeholder value
      //     checkIn: DateTime.now(),
      //     checkOut: DateTime.now().add(const Duration(days: 10)),
      //     guests: 2,
      //   ),
      //   Booking(
      //     id: '2',
      //     userId: userId,
      //     roomId: '102', // Placeholder value
      //     roomName: 'Standard Room', // Placeholder value
      //     totalPrice: 150.0, // Placeholder value
      //     checkIn: DateTime.now().add(const Duration(days: 7)),
      //     checkOut: DateTime.now().add(const Duration(days: 10)),
      //     guests: 3,
      //   ),
      // ];
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static Future<void> addBooking(Booking newBooking) async {
    _bookings.add(newBooking);
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      _bookings.removeWhere((booking) => booking.id == bookingId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }

  Future<bool> modifyBooking(
    String bookingId,
    DateTime checkIn,
    DateTime checkOut,
    int guests,
  ) async {
    try {
      if (checkIn.isAfter(checkOut)) {
        debugPrint(
            'Check-in date must be before check-out date for booking $bookingId.');
        return false;
      }
      if (guests <= 0) {
        debugPrint('Number of guests must be positive for booking $bookingId.');
        return false;
      }
      final bookingIndex =
          _bookings.indexWhere((booking) => booking.id == bookingId);
      if (bookingIndex != -1) {
        _bookings[bookingIndex] = Booking(
          id: bookingId,
          userId: _bookings[bookingIndex].userId,
          roomId: _bookings[bookingIndex].roomId,
          roomName: _bookings[bookingIndex].roomName,
          totalPrice: _bookings[bookingIndex].totalPrice,
          checkIn: checkIn,
          checkOut: checkOut,
          guests: guests,
        );
        notifyListeners();
        return true;
      }
      debugPrint('Booking not found for $bookingId');
      return false;
    } catch (e) {
      debugPrint('Error modifying booking for $bookingId: $e');
      return false;
    }
  }
}

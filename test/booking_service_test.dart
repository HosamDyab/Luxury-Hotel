import 'package:flutter_test/flutter_test.dart';
import 'package:luxury_hotel/models/booking.dart';
import 'package:luxury_hotel/services/booking_service.dart';

void main() {
  group('BookingService', () {
    final bookingService = BookingService();

    test('updateBooking should complete without errors', () async {
      final booking = Booking(
        id: '1',
        userId: 'user1',
        roomId: 'room1',
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 1)),
        guests: 1,
        status: 'confirmed',
        totalPrice: 100.0,
        roomName: 'Deluxe Room',
        rating: 5,
        review: 'Great stay!',
      );

      expect(() async => await bookingService.updateBooking(booking),
          returnsNormally);
    });
  });
}

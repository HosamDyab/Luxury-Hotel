import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dialogs/review_dialog.dart';
import 'modify_booking_screen.dart';
import '../../providers/booking_provider.dart';
import 'package:provider/provider.dart';
import '../../services/review_service.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  Future<void> _showReviewDialog(
      BuildContext context, String bookingId, String roomName) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => ReviewDialog(
        bookingId: bookingId,
        roomName: roomName,
        onSubmit: (rating, comment) async {
          try {
            final reviewService = ReviewService();
            await reviewService.submitReview(bookingId, comment); 
            if (!mounted) return;
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Review submitted successfully'),
                backgroundColor: AppTheme.darkBlack,
              ),
            );
          } catch (e) {
            if (!mounted) return;
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Failed to submit review: ${e.toString()}'),
                backgroundColor: AppTheme.darkBlack,
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _handleCancelBooking(BuildContext context, String bookingId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await bookingProvider.cancelBooking(bookingId);
        if (!mounted) return;

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled successfully'),
            backgroundColor: AppTheme.darkBlack,
          ),
        );

        // Refresh bookings
        await bookingProvider.fetchBookings(bookingProvider.bookings.firstWhere((b) => b.id == bookingId).userId);
      } catch (e) {
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Failed to cancel booking: ${e.toString()}'),
            backgroundColor: AppTheme.darkBlack,
          ),
        );
      }
    }
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.roomName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryGold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today,
                'Check-in: ${booking.checkIn.toString().split(' ')[0]}'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.calendar_today,
                'Check-out: ${booking.checkOut.toString().split(' ')[0]}'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.person, '${booking.guests} Guests'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.attach_money, '\$${booking.totalPrice}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleCancelBooking(context, booking.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final provider =
                          Provider.of<BookingProvider>(context, listen: false);

                      final modified = await navigator.push<bool>(
                        MaterialPageRoute(
                          builder: (context) => ModifyBookingScreen(
                            booking: booking,
                          ),
                        ),
                      );

                      if (modified == true && mounted) {
                        await provider.fetchBookings(provider.bookings.firstWhere((b) => b.id == booking.id).userId);
                      }
                    },
                    child: const Text('Modify'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    _showReviewDialog(context, booking.id, booking.roomName),
                child: const Text('Write a Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryGold),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookingProvider.bookings.isEmpty) {
            return const Center(
              child: Text('No bookings found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookingProvider.bookings.length,
            itemBuilder: (context, index) => _buildBookingCard(
              context,
              bookingProvider.bookings[index],
            ),
          );
        },
      ),
    );
  }
}

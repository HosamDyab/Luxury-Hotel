import 'package:logger/logger.dart';

final logger = Logger();

class ReviewService {
  // Method to submit a review
  Future<void> submitReview(String bookingId, String reviewText) async {
    // Logic to submit the review
    logger.e('Review submitted for booking $bookingId: $reviewText');
  }

  // Method to fetch reviews for a booking
  Future<List<String>> fetchReviews(String bookingId) async {
    // Logic to fetch reviews
    return ['Great stay!', 'Would recommend!'];
  }
}

import 'room.dart';

class Booking {
  final String id;
  final String roomId;
  final String userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String status;
  final Room? room;
  final String roomName;
  final int? rating;
  final String? review;

  Booking({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.roomName,
    this.status = 'pending',
    this.room,
    this.rating,
    this.review,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      userId: json['userId'] as String,
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      guests: json['guests'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      roomName: json['roomName'] as String? ?? 'Room',
      room: json['room'] != null ? Room.fromJson(json['room'] as Map<String, dynamic>) : null,
      rating: json['rating'] as int?,
      review: json['review'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status,
      'roomName': roomName,
      'room': room?.toJson(),
      'rating': rating,
      'review': review,
    };
  }
}

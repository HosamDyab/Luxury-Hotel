class Room {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> amenities;
  final int capacity;
  final String type;
  final bool isAvailable;
  final double rating;
  final int reviews;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.amenities,
    required this.capacity,
    required this.type,
    this.isAvailable = true,
    required this.rating,
    required this.reviews,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'amenities': amenities,
      'capacity': capacity,
      'type': type,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviews': reviews,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      amenities: List<String>.from(json['amenities'] as List),
      capacity: json['capacity'] as int,
      type: json['type'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Room && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

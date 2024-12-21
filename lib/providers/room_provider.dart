import 'package:flutter/foundation.dart';
import '../models/room.dart';

class RoomProvider extends ChangeNotifier {
  final Map<String, Room> _rooms = {};
  final List<Room> _featuredRooms = [];
  final List<Room> _popularRooms = [];
  final List<Room> _favoriteRooms = [];

  List<Room> get rooms => _rooms.values.toList();
  List<Room> get featuredRooms => _featuredRooms;
  List<Room> get popularRooms => _popularRooms;
  List<Room> get favoriteRooms => _favoriteRooms;

  Room? getRoomById(String id) {
    return _rooms[id]; // Ensure this returns a Room object or null
  }

  void addRoom(Room room) {
    _rooms[room.id] = room;
    notifyListeners();
  }

  void addFeaturedRoom(Room room) {
    if (!_featuredRooms.contains(room)) {
      _featuredRooms.add(room);
      notifyListeners();
    }
  }

  void addPopularRoom(Room room) {
    if (!_popularRooms.contains(room)) {
      _popularRooms.add(room);
      notifyListeners();
    }
  }

  void addToFavorites(Room room) {
    if (!_favoriteRooms.contains(room)) {
      _favoriteRooms.add(room);
      notifyListeners();
    }
  }

  void removeFromFavorites(String roomId) {
    _favoriteRooms.removeWhere((room) => room.id == roomId);
    notifyListeners();
  }

  bool isFavorite(String roomId) {
    return _favoriteRooms.any((room) => room.id == roomId);
  }

  void generateSampleRooms() {
    final sampleRooms = [
      Room(
        id: '1',
        name: 'Deluxe Ocean View Suite',
        description: 'Luxurious suite with stunning ocean views',
        price: 599.99,
        imageUrl:
            'https://cf.bstatic.com/static/img/theme-index/bg_luxury/869918c9da63b2c5685fce05965700da5b0e6617.jpg',
        amenities: ['Ocean View', 'King Bed', 'Mini Bar', 'WiFi'],
        capacity: 2,
        type: 'suite',
        rating: 4.8,
        reviews: 245,
      ),
      Room(
        id: '2',
        name: 'Presidential Suite',
        description: 'Ultimate luxury experience with panoramic views',
        price: 1299.99,
        imageUrl:
            'https://media.cnn.com/api/v1/images/stellar/prod/140127103345-peninsula-shanghai-deluxe-mock-up.jpg?q=w_2226,h_1449,x_0,y_0,c_fill',
        amenities: ['Panoramic View', 'Private Pool', 'Butler Service', 'WiFi'],
        capacity: 4,
        type: 'presidential',
        rating: 4.9,
        reviews: 189,
      ),
      Room(
        id: '3',
        name: 'Garden View Room',
        description: 'Peaceful room overlooking our tropical gardens',
        price: 299.99,
        imageUrl:
            'https://image-tc.galaxy.tf/wijpeg-3arzvxuixgofd4ma93416vur2/superior-garden-2_standard.jpg?crop=116%2C0%2C1769%2C1327',
        amenities: ['Garden View', 'Queen Bed', 'Mini Bar', 'WiFi'],
        capacity: 2,
        type: 'standard',
        rating: 4.5,
        reviews: 320,
      ),
      Room(
        id: '4',
        name: 'Luxury Suite',
        description: 'Spacious suite with modern amenities and city views',
        price: 799.99,
        imageUrl:
            'https://i0.wp.com/elegance-suisse.ch/wp-content/uploads/Luxury-hotels-the-art-of-hospitality-superior-comfort-and-service-royal-suite.jpg?resize=1000%2C667&ssl=1',
        amenities: ['City View', 'King Bed', 'Hot Tub', 'WiFi'],
        capacity: 3,
        type: 'suite',
        rating: 4.7,
        reviews: 150,
      ),
      Room(
        id: '5',
        name: 'Family Room',
        description: 'Comfortable room ideal for families with children',
        price: 399.99,
        imageUrl:
            'https://mylomehotels.com/wp-content/uploads/2023/04/aile-oda-3-1024px.webp',
        amenities: ['Family Friendly', 'Two Queen Beds', 'Mini Bar', 'WiFi'],
        capacity: 4,
        type: 'standard',
        rating: 4.6,
        reviews: 200,
      ),
    ];

    for (final room in sampleRooms) {
      addRoom(room);
      if (room.rating >= 4.7) {
        addFeaturedRoom(room);
      }
      if (room.reviews >= 200) {
        addPopularRoom(room);
      }
    }
  }
}

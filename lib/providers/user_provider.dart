import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/room.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<Room> _favoriteRooms = [];
  final bool _isLoading = false;

  User? get user => _user;
  List<Room> get favoriteRooms => _favoriteRooms;
  bool get isLoading => _isLoading;

  void setUser(User user) {
    _user = user;
    loadFavoriteRooms();
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _favoriteRooms = [];
    notifyListeners();
  }

  Future<void> toggleFavorite(Room room) async {
    if (_user == null) return;

    if (_favoriteRooms.any((r) => r.id == room.id)) {
      _favoriteRooms.removeWhere((r) => r.id == room.id);
    } else {
      _favoriteRooms.add(room);
    }
    notifyListeners();
  }

  Future<void> loadFavoriteRooms() async {
    if (_user != null) {
      try {
        // Initialize _favoriteRooms with an empty list for now
        _favoriteRooms = [];
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading favorite rooms: $e');
      }
    }
  }

  bool isFavorite(String roomId) {
    return _favoriteRooms.any((room) => room.id == roomId);
  }

  // Initialize user from storage (no-op for now)
  Future<void> initializeFromStorage() async {
    try {
      // No-op for now
    } catch (e) {
      debugPrint('Error initializing from storage: $e');
    }
  }
}

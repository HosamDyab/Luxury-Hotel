import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/room.dart';
import '../../providers/room_provider.dart';
import '../../theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteRooms = Provider.of<RoomProvider>(context).favoriteRooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteRooms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: AppTheme.primaryGold,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Favorite Rooms Yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryGold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding rooms to your favorites',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: const Text('Explore Rooms'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteRooms.length,
              itemBuilder: (context, index) {
                final room = favoriteRooms[index];
                return _buildFavoriteRoomCard(context, room);
              },
            ),
    );
  }

  Widget _buildFavoriteRoomCard(BuildContext context, Room room) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppTheme.softBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppTheme.primaryGold),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/room-details',
            arguments: {'room': room},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.network(
                    room.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Removal'),
                          content: const Text(
                              'Are you sure you want to remove this room from favorites?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<RoomProvider>(context,
                                        listen: false)
                                    .removeFromFavorites(room.id);
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        // Show success message
                      }
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: AppTheme.primaryGold,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.description,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${room.price}/night',
                        style: const TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/booking',
                            arguments: {'room': room},
                          );
                        },
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

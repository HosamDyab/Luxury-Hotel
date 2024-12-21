import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/room_provider.dart';
import '../../models/room.dart';
import '../../widgets/shimmer_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../theme/app_theme.dart';

class FeaturedRoomsScreen extends StatelessWidget {
  const FeaturedRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Rooms'),
      ),
      body: Consumer<RoomProvider>(
        builder: (context, roomProvider, child) {
          if (roomProvider.featuredRooms.isEmpty) {
            return const Center(child: ShimmerLoading());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: roomProvider.featuredRooms.length,
            itemBuilder: (context, index) {
              final room = roomProvider.featuredRooms[index];
              return _buildRoomCard(context, room);
            },
          );
        },
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/room-details',
            arguments: room.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: room.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerLoading(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${room.price}/night',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: room.rating,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: AppTheme.primaryGold,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${room.reviews} reviews)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

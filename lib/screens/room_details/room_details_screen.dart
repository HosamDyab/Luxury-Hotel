import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../models/room.dart';
import '../../providers/room_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_loading.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Room room;

  const RoomDetailsScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRoomInfo(context),
                _buildAmenities(context),
                _buildDescription(context),
                _buildPriceAndBooking(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: room.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerLoading(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Consumer<RoomProvider>(
          builder: (context, provider, child) {
            final isFavorite = provider.isFavorite(room.id);
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () {
                if (isFavorite) {
                  provider.removeFromFavorites(room.id);
                } else {
                  provider.addToFavorites(room);
                }
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Implement share functionality
          },
        ),
      ],
    );
  }

  Widget _buildRoomInfo(BuildContext context) {
    return Padding(
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  room.type.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primaryGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingBar.builder(
                initialRating: 4.5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                ignoreGestures: true,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppTheme.primaryGold,
                ),
                onRatingUpdate: (rating) {},
              ),
              const SizedBox(width: 8),
              Text(
                '4.5 (128 reviews)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.people_outline, '${room.capacity} Guests'),
              const SizedBox(width: 16),
              _buildInfoChip(Icons.king_bed_outlined, 'King Bed'),
              const SizedBox(width: 16),
              _buildInfoChip(Icons.square_foot_outlined, '45 m²'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAmenities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Amenities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: room.amenities.length,
            itemBuilder: (context, index) {
              return _buildAmenityCard(
                context,
                room.amenities[index],
                _getAmenityIcon(room.amenities[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAmenityCard(
      BuildContext context, String amenity, IconData icon) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.primaryGold),
          const SizedBox(height: 8),
          Text(
            amenity,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'tv':
        return Icons.tv;
      case 'mini bar':
        return Icons.local_bar;
      case 'room service':
        return Icons.room_service;
      case 'kitchen':
        return Icons.kitchen;
      case 'pool':
        return Icons.pool;
      case 'spa':
        return Icons.spa;
      case 'gym':
        return Icons.fitness_center;
      default:
        return Icons.star;
    }
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            room.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndBooking(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Price',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                Text(
                  '\$${room.price}/night',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryGold,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/booking', arguments: room);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

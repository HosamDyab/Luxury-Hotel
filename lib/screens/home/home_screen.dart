import 'package:flutter/material.dart';
import 'package:luxury_hotel/models/room.dart';
import 'package:luxury_hotel/widgets/shimmer_loading.dart';
import 'package:luxury_hotel/providers/room_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                _buildSearchBar(context),
                _buildWelcomeSection(context),
                _buildFeaturedRoomsSection(context),
                _buildPopularRoomsSection(context),
                _buildSpecialOffersSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('Luxury Hotel'),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1566073771259-6a8506099945',
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
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
        ),
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/search'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Search for rooms...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find your perfect stay',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedRoomsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Rooms',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/featured-rooms'),
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: Consumer<RoomProvider>(
            builder: (context, roomProvider, child) {
              if (roomProvider.featuredRooms.isEmpty) {
                return const ShimmerLoading();
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: roomProvider.featuredRooms.length,
                itemBuilder: (context, index) {
                  return _buildFeaturedRoomCard(
                    context,
                    roomProvider.featuredRooms[index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedRoomCard(BuildContext context, Room room) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: room.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerLoading(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: 4.5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: AppTheme.primaryGold,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.5',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${room.price}/night',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.primaryGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            room.type,
                            style: const TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularRoomsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Rooms',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/popular-rooms'),
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        Consumer<RoomProvider>(
          builder: (context, roomProvider, child) {
            if (roomProvider.popularRooms.isEmpty) {
              return const ShimmerLoading();
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: roomProvider.popularRooms.length,
              itemBuilder: (context, index) {
                return _buildPopularRoomCard(
                  context,
                  roomProvider.popularRooms[index],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPopularRoomCard(BuildContext context, Room room) {
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: room.imageUrl,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => const ShimmerLoading(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      room.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${room.price}/night',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.primaryGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppTheme.primaryGold,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOffersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Special Offers',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildSpecialOfferCard(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOfferCard(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        color: AppTheme.primaryGold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1566073771259-6a8506099945',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Special Weekend Offer',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get 20% off on weekend stays',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
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

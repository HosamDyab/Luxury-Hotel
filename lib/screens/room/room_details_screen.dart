import 'package:flutter/material.dart';
import 'package:luxury_hotel/screens/booking/booking_screen.dart';
import 'package:provider/provider.dart';
import '../../models/room.dart';
import '../../theme/app_theme.dart';
import '../../providers/user_provider.dart';

class RoomDetailsScreen extends StatelessWidget {
  final Room room;

  const RoomDetailsScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isFavorite = userProvider.isFavorite(room.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    room.imageUrl,
                    fit: BoxFit.cover,
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
              title: Text(
                room.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: AppTheme.primaryGold,
                ),
                onPressed: () {
                  userProvider.toggleFavorite(room);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${room.price}/night',
                        style: const TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        room.type.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.amenities
                        .map((amenity) => Chip(
                              backgroundColor: AppTheme.darkBlack,
                              side:
                                  const BorderSide(color: AppTheme.primaryGold),
                              label: Text(
                                amenity,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.pushNamed(
                        //context,
                        //'/booking',
                        //arguments: {'room': room},
                        //);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BookingScreen(room: room)));
                      },
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

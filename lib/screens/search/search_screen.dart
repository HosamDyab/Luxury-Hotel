import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/room.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 1000);
  List<String> _selectedAmenities = [];
  int _selectedCapacity = 1;
  String? _selectedType;
  List<Room> _allRooms = [];
  List<Room> _filteredRooms = [];

  final List<String> _amenities = [
    'WiFi',
    'Mini Bar',
    'TV',
    'Air Conditioning',
    'Balcony',
    'City View',
    'Room Service',
    'Spa Bath',
    'Work Desk',
  ];

  final List<String> _roomTypes = [
    'Standard',
    'Deluxe',
    'Suite',
    'Executive',
    'Presidential',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with some sample rooms
    _allRooms = [
      Room(
        id: '1',
        name: 'Luxury City View Room',
        description: 'Experience luxury with stunning city views',
        price: 299.99,
        imageUrl: 'https://example.com/city-room.jpg',
        amenities: ['WiFi', 'Mini Bar', 'City View'],
        capacity: 2,
        type: 'standard',
        rating: 4.5,
        reviews: 150,
      ),
      Room(
        id: '2',
        name: 'Deluxe Garden Room',
        description: 'Peaceful room with garden views',
        price: 199.99,
        imageUrl: 'https://example.com/garden-room.jpg',
        amenities: ['WiFi', 'TV', 'Air Conditioning'],
        capacity: 2,
        type: 'standard',
        rating: 4.3,
        reviews: 120,
      ),
      Room(
        id: '3',
        name: 'Executive Suite',
        description: 'Spacious suite with premium amenities',
        price: 499.99,
        imageUrl: 'https://example.com/exec-suite.jpg',
        amenities: ['WiFi', 'Mini Bar', 'City View', 'Spa Bath', 'Room Service'],
        capacity: 4,
        type: 'suite',
        rating: 4.7,
        reviews: 200,
      ),
    ];
    _filteredRooms = List.from(_allRooms);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Rooms'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search rooms...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGold),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list, color: AppTheme.primaryGold),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredRooms = _allRooms.where((room) {
                    final searchLower = value.toLowerCase();
                    final matchesSearch = room.name.toLowerCase().contains(searchLower) ||
                        room.description.toLowerCase().contains(searchLower) ||
                        room.type.toLowerCase().contains(searchLower);
                    
                    final matchesPrice = room.price >= _priceRange.start && 
                        room.price <= _priceRange.end;
                    
                    final matchesAmenities = _selectedAmenities.isEmpty ||
                        _selectedAmenities.every((amenity) => 
                            room.amenities.contains(amenity));
                    
                    final matchesCapacity = room.capacity >= _selectedCapacity;
                    
                    final matchesType = _selectedType == null || 
                        room.type.toLowerCase() == _selectedType!.toLowerCase();
                    
                    return matchesSearch && matchesPrice && matchesAmenities && 
                        matchesCapacity && matchesType;
                  }).toList();
                });
              },
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredRooms.isEmpty) {
      return const Center(
        child: Text(
          'No rooms found matching your criteria',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredRooms.length,
      itemBuilder: (context, index) {
        final room = _filteredRooms[index];
        return _buildRoomCard(room);
      },
    );
  }

  Widget _buildRoomCard(Room room) {
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                room.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
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
                      Text(
                        room.name,
                        style: const TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Consumer<UserProvider>(
                          builder: (context, userProvider, _) => Icon(
                            userProvider.isFavorite(room.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        onPressed: () {
                          final userProvider = Provider.of<UserProvider>(
                            context,
                            listen: false,
                          );
                          userProvider.toggleFavorite(room);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.description,
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.amenities.map((amenity) => Chip(
                      backgroundColor: AppTheme.darkBlack,
                      side: const BorderSide(color: AppTheme.primaryGold),
                      label: Text(
                        amenity,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )).toList(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${room.rating}/5',
                        style: const TextStyle(
                          color: AppTheme.primaryGold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${room.reviews} reviews',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
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
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filters',
                            style: TextStyle(
                              color: AppTheme.primaryGold,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _priceRange = const RangeValues(0, 1000);
                                _selectedAmenities = [];
                                _selectedCapacity = 1;
                                _selectedType = null;
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        activeColor: AppTheme.primaryGold,
                        inactiveColor: Colors.grey,
                        labels: RangeLabels(
                          '\$${_priceRange.start.round()}',
                          '\$${_priceRange.end.round()}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Room Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _roomTypes.map((type) {
                          final isSelected = _selectedType == type;
                          return ChoiceChip(
                            label: Text(type),
                            selected: isSelected,
                            selectedColor: AppTheme.primaryGold,
                            backgroundColor: AppTheme.softBlack,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _selectedType = selected ? type : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Capacity',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_selectedCapacity > 1) {
                                setState(() {
                                  _selectedCapacity--;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: AppTheme.primaryGold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.primaryGold),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _selectedCapacity.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedCapacity++;
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: AppTheme.primaryGold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Amenities',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _amenities.map((amenity) {
                          final isSelected = _selectedAmenities.contains(amenity);
                          return FilterChip(
                            label: Text(amenity),
                            selected: isSelected,
                            selectedColor: AppTheme.primaryGold,
                            backgroundColor: AppTheme.softBlack,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAmenities.add(amenity);
                                } else {
                                  _selectedAmenities.remove(amenity);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filteredRooms = _allRooms.where((room) {
                                final matchesPrice = room.price >= _priceRange.start && 
                                    room.price <= _priceRange.end;
                                
                                final matchesAmenities = _selectedAmenities.isEmpty ||
                                    _selectedAmenities.every((amenity) => 
                                        room.amenities.contains(amenity));
                                
                                final matchesCapacity = room.capacity >= _selectedCapacity;
                                
                                final matchesType = _selectedType == null || 
                                    room.type.toLowerCase() == _selectedType!.toLowerCase();
                                
                                return matchesPrice && matchesAmenities && 
                                    matchesCapacity && matchesType;
                              }).toList();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

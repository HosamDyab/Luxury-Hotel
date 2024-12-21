import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Import screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/booking/booking_confirmation_screen.dart';
import 'screens/booking/booking_history_screen.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/room/room_details_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/payment/payment_methods_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/help_support/help_support_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/room/featured_rooms_screen.dart';
import 'screens/room/popular_rooms_screen.dart';
import 'layout/main_layout.dart';
import 'theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/room_provider.dart';
import 'providers/room_provider_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider<RoomProvider>(
            create: (_) => InitializedRoomProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Luxury Hotel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        if (settings.name == '/room-details') {
          final roomProvider =
              Provider.of<RoomProvider>(context, listen: false);
          final String roomId = settings.arguments as String;
          final room = roomProvider.getRoomById(roomId);
          if (room == null) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Room not found')),
              ),
            );
          }
          return MaterialPageRoute(
            builder: (context) => RoomDetailsScreen(room: room),
          );
        }
        if (settings.name == '/booking') {
          final roomProvider =
              Provider.of<RoomProvider>(context, listen: false);
          final String roomId = settings.arguments as String;
          final room = roomProvider.getRoomById(roomId);
          if (room == null) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Room not found')),
              ),
            );
          }
          return MaterialPageRoute(
            builder: (context) => BookingScreen(room: room),
          );
        }
        if (settings.name == '/featured-rooms') {
          return MaterialPageRoute(
            builder: (context) => const FeaturedRoomsScreen(),
          );
        }
        if (settings.name == '/popular-rooms') {
          return MaterialPageRoute(
            builder: (context) => const PopularRoomsScreen(),
          );
        }
        return null;
      },
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainLayout(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/booking-history': (context) => const BookingHistoryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/payment-methods': (context) => const PaymentMethodsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/help-support': (context) => const HelpSupportScreen(),
      },
    );
  }
}

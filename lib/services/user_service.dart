import 'package:logger/logger.dart';
import 'package:luxury_hotel/models/user.dart';

final logger = Logger();

class UserService {
  static Future<User?> login(
      {required String email, required String password}) async {
    try {
      // Mock user data for demonstration
      if (email == 'hosam1dyab2@gmail.com' && password == 'Hosamhhm123#') {
        logger.i("User logged in successfully");
        return User(
          email: email,
          name: 'Test User',
          id: 'test_user_id',
          password: password, // Use the provided password
        );
      }
      logger.e("Invalid email or password");
      return null;
    } catch (e) {
      logger.e("Login error: $e");
      return null;
    }
  }

  static Future<User?> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      String userId = email;
      logger.i("User signed up successfully");
      return User(
        id: userId,
        email: email,
        name: name,
        password: password,
      );
    } catch (e) {
      logger.e("Signup error: $e");
      return null;
    }
  }
}

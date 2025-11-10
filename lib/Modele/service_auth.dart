import 'user.dart';

class AuthService {
  static final List<User> _validUsers = [
    User(username: 'admin', password: 'password'),
    User(username: 'user1', password: '1234'),
  ];

  Future<User?> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final validUser = _validUsers.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      return validUser;
    } catch (e) {
      return null;
    }
  }
}
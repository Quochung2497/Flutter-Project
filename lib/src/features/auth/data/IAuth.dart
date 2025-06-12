import '../model/model.dart';

enum AuthStatus{
  idle,
  loading,
  success,
  error
}

abstract class IAuth {
  /// Returns the logged-in User, or `null` on failure.
  Future<User?> login(String email, String password);

  /// Registers a new user. Throws if e.g. email already exists.
  Future<void> register(User user);

  /// Clears all stored users (for debug / logout).
  Future<void> clear();
}
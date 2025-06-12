import 'IAuth.dart';
import '../../../services/services.dart';
import '../model/model.dart';

class AuthModel implements IAuth {
  final MockDatabase _db;
  AuthModel({required MockDatabase db}) : _db = db;

  @override
  Future<User?> login(String email, String password) => _db.login(email, password);

  @override
  Future<void> register(User user) => _db.register(user);

  @override
  Future<void> clear() => _db.clear();
}

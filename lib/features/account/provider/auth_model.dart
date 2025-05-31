import '../../../features/account/provider/IAuth.dart';
import '../../../services/services.dart';
import '../model/model.dart';

class AuthModel extends IAuth {
  final _db = MockDatabase();

  AuthStatus _status = AuthStatus.idle;
  String? _error;
  User?   _user;

  @override
  AuthStatus   get status => _status;

  @override
  String? get error     => _error;

  @override
  User?   get user      => _user;

  @override
  Future<bool> login(String email, String password) async {
    setStatus(AuthStatus.loading);
    _error = null;

    final u = await _db.login(email, password);
    if (u == null) {
      _error = 'Invalid email or password';
      setStatus(AuthStatus.error);
      return false;
    }

    _user = u;
    setStatus(AuthStatus.success);
    return true;
  }

  @override
  Future<bool> register(User newUser) async {
    setStatus(AuthStatus.loading);
    _error = null;

    try {
      await _db.register(newUser);
      setStatus(AuthStatus.success);
      return true;
    } catch (e) {
      String msg = e.toString();
      const prefix = 'Exception: ';
      if(msg.startsWith(prefix))
        msg = msg.substring(prefix.length);
      _error = msg;
      setStatus(AuthStatus.error);
      return false;
    }
  }

  @override
  Future<void> clear() => _db.clear();

  @override
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  void setStatus(AuthStatus s) {
    _status = s;
    notifyListeners();
  }
}

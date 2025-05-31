import 'package:flutter/cupertino.dart';
import '../model/model.dart';

enum AuthStatus{
  idle,
  loading,
  success,
  error
}

abstract class IAuth extends ChangeNotifier{
  AuthStatus get status;
  String? get error;
  User? get user;
  Future<bool> login(String email, String password);
  Future<bool> register(User newUser);
  Future<void> clear();

  void clearError();
}
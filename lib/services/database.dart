import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/account/model/user.dart';
import 'package:collection/collection.dart';

class MockDatabase {
  static const _key = 'mock_users';

  Future<List<User>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    return list.map((e) => User.fromJson(e)).toList();
  }

  Future<void> register(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getAllUsers();

    if (users.any((u) => u.email == user.email)) {
      throw Exception('Email already registered.');
    }

    users.add(user);
    final updated = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_key, updated);
  }

  Future<User?> login(String email, String password) async {
    final users = await _getAllUsers();
    return users.firstWhereOrNull(
          (u) => u.email == email && u.password == password,
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> debugPrintAllUsers() async {
    final users = await _getAllUsers();
    for (var u in users) {
      debugPrint(' ${u.firstName} ${u.lastName} (${u.email})');
    }
  }
}

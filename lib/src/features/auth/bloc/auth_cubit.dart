import 'package:bloc/bloc.dart';
import '../data/IAuth.dart';
import '../model/model.dart';
part 'auth_state.dart';

/// Handles login & registration flows by talking to IAuthRepository.
class AuthCubit extends Cubit<AuthState> {
  final IAuth _repo;

  AuthCubit({required IAuth repository})
      : _repo = repository,
        super(AuthState.idle());

  /// Attempts to sign in; on success emits [success], on failure [error].
  Future<void> login(String email, String password) async {
    emit(AuthState.loading());
    try {
      final user = await _repo.login(email, password);
      if (user == null) throw Exception('Invalid email or password');
      emit(AuthState.success(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Attempts to register; on success emits [registered], on failure [error].
  Future<void> register(User user) async {
    emit(AuthState.loading());
    try {
      await _repo.register(user);
      emit(AuthState.registered());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Clears both the cubit’s error and any persisted user data.
  Future<void> clear() async {
    // Clear the persisted account
    await _repo.clear();
    // Reset state
    emit(AuthState.idle());
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
part of 'auth_cubit.dart';

/// Represents all possible states of [AuthCubit].
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;
  final bool registered;

  AuthState({
    required this.isLoading,
    this.user,
    this.error,
    this.registered = false,
  });

  /// Initial, nothing happening.
  factory AuthState.idle() => AuthState(isLoading: false);

  /// A request (login/register) is in progress.
  factory AuthState.loading() => AuthState(isLoading: true);

  /// Login succeeded, carries the authenticated [User].
  factory AuthState.success(User u) =>
      AuthState(isLoading: false, user: u);

  /// Registration succeeded (no user returned here).
  factory AuthState.registered() =>
      AuthState(isLoading: false, registered: true);

  /// An error occurred; carries the error message.
  factory AuthState.error(String msg) =>
      AuthState(isLoading: false, error: msg);

  /// Creates a copy with optional overrides.
  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
    bool? registered,
  }) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        error: error,
        registered: registered ?? this.registered,
      );
}
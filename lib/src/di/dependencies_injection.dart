import 'package:example_app/src/features/auth/data/auth_model.dart';
import 'package:get_it/get_it.dart';
import '../features/auth/Bloc/auth_cubit.dart';
import '../features/auth/data/IAuth.dart';
import '../services/services.dart';


/// Service locator instance
final sl = GetIt.instance;

/// Call this at app startup to register all your dependencies.
Future<void> initDependencies() async {
  // --- Services ---
  sl.registerLazySingleton<MockDatabase>(
        () => MockDatabase(),
  );

  // --- Repository (interface → implementation) ---
  sl.registerLazySingleton<IAuth>(
        () => AuthModel(db: sl<MockDatabase>()),
  );

  // --- Cubits / Blocs ---
  sl.registerFactory<AuthCubit>(
        () => AuthCubit(repository: sl<IAuth>()),
  );
}
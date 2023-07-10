import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  void dispose();
}

class FakeAuthRepository implements AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  @override
  Stream<AppUser?> authStateChanges() => _authState.stream;

  @override
  AppUser? get currentUser => _authState.value;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (currentUser != null) {
      throw UnimplementedError();
    }

    _createNewUser(email, password);
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (currentUser != null) {
      throw UnimplementedError();
    }

    _createNewUser(email, password);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // throw Exception("A fake error occurred");
    _authState.value = null;
  }

  void _createNewUser(String email, String password) {
    _authState.value = AppUser(
      uid: email.split("").reversed.join(),
      email: email,
    );
  }

  @override
  void dispose() => _authState.close();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authRepository = FakeAuthRepository();

  ref.onDispose(() => authRepository.dispose());

  return authRepository;
});

final authStateChangeProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

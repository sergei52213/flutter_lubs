import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRepositoryInterface {
  User? get currentUser;

  Stream<User?> get authStateChanges;

  Future<User> signIn({required String email, required String password});

  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);
}

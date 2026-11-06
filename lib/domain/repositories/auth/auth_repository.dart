import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository({required this.firebaseAuth});

  final FirebaseAuth firebaseAuth;

  @override
  User? get currentUser => firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  @override
  Future<User> signIn({required String email, required String password}) async {
    try {
      final credentials = await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return _requireUser(credentials.user);
    } on FirebaseAuthException catch (exception) {
      throw AuthFailure(_messageFor(exception));
    }
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credentials = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = _requireUser(credentials.user);
      final name = displayName.trim();

      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
        await user.reload();
      }

      return firebaseAuth.currentUser ?? user;
    } on FirebaseAuthException catch (exception) {
      throw AuthFailure(_messageFor(exception));
    }
  }

  @override
  Future<void> signOut() => firebaseAuth.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (exception) {
      throw AuthFailure(_messageFor(exception));
    }
  }

  User _requireUser(User? user) {
    if (user == null) {
      throw const AuthFailure('Не удалось получить данные пользователя');
    }

    return user;
  }

  String _messageFor(FirebaseAuthException exception) {
    return switch (exception.code) {
      'invalid-email' => 'Некорректный адрес электронной почты',
      'user-disabled' => 'Учётная запись отключена',
      'user-not-found' => 'Пользователь с таким адресом не найден',
      'wrong-password' || 'invalid-credential' => 'Неверный пароль',
      'email-already-in-use' => 'Этот адрес уже зарегистрирован',
      'weak-password' => 'Пароль слишком простой: нужно не менее 6 символов',
      'too-many-requests' => 'Слишком много попыток. Попробуйте позже',
      'network-request-failed' => 'Нет соединения с Firebase',
      'operation-not-allowed' =>
        'Вход по электронной почте не включён в проекте Firebase',
      _ => exception.message ?? 'Ошибка аутентификации',
    };
  }
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

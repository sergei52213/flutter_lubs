import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';

import '../../../../domain/domain.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository, this.talker)
    : super(_initialState(authRepository.currentUser)) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthUserChanged>(_onUserChanged);

    _authSubscription = authRepository.authStateChanges.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  final AuthRepositoryInterface authRepository;
  final Talker talker;

  late final StreamSubscription<User?> _authSubscription;

  static AuthState _initialState(User? user) {
    return user == null
        ? const AuthUnauthenticated()
        : AuthAuthenticated(user: user);
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated(isLoading: true));

    try {
      final user = await authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } on AuthFailure catch (exception) {
      emit(AuthUnauthenticated(error: exception.message));
    } catch (exception, stackTrace) {
      emit(const AuthUnauthenticated(error: 'Не удалось выполнить вход'));
      talker.handle(exception, stackTrace);
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated(isLoading: true));

    try {
      final user = await authRepository.signUp(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      emit(AuthAuthenticated(user: user));
    } on AuthFailure catch (exception) {
      emit(AuthUnauthenticated(error: exception.message));
    } catch (exception, stackTrace) {
      emit(
        const AuthUnauthenticated(error: 'Не удалось создать учётную запись'),
      );
      talker.handle(exception, stackTrace);
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (exception, stackTrace) {
      talker.handle(exception, stackTrace);
    }
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.sendPasswordResetEmail(event.email);
      emit(const AuthPasswordResetSent());
    } on AuthFailure catch (exception) {
      emit(AuthUnauthenticated(error: exception.message));
    } catch (exception, stackTrace) {
      emit(
        const AuthUnauthenticated(
          error: 'Не удалось отправить письмо для сброса пароля',
        ),
      );
      talker.handle(exception, stackTrace);
    }
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    final user = event.user;

    if (user == null) {
      if (state is! AuthUnauthenticated) {
        emit(const AuthUnauthenticated());
      }
      return;
    }

    emit(AuthAuthenticated(user: user));
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    return super.close();
  }
}

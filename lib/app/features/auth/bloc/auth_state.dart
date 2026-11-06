part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  @override
  List<Object?> get props => [isLoading, error];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final User user;

  @override
  List<Object?> get props => [user.uid, user.email, user.displayName];
}

final class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}

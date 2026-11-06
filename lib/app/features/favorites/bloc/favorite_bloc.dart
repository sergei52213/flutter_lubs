import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';

import '../../../../domain/domain.dart';
import '../../auth/bloc/auth_bloc.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc(this.favoriteRepository, this.authBloc, this.talker)
    : super(const FavoriteInitial()) {
    on<FavoriteStarted>(_onStarted);
    on<FavoriteToggled>(_onToggled);
    on<FavoriteRemoved>(_onRemoved);
    on<FavoriteDataReceived>(_onDataReceived);
    on<FavoriteStreamFailed>(_onStreamFailed);
  }

  final FavoriteRepositoryInterface favoriteRepository;
  final AuthBloc authBloc;
  final Talker talker;

  StreamSubscription<List<FavoriteGame>>? _subscription;

  Future<void> _onStarted(
    FavoriteStarted event,
    Emitter<FavoriteState> emit,
  ) async {
    await _subscription?.cancel();

    final authState = authBloc.state;
    if (authState is! AuthAuthenticated) {
      emit(const FavoriteLoadSuccess(favorites: []));
      return;
    }

    emit(const FavoriteLoadInProgress());

    _subscription = favoriteRepository
        .favoritesStream(authState.user.uid)
        .listen(
          (favorites) => add(FavoriteDataReceived(favorites)),
          onError: (Object exception, StackTrace stackTrace) {
            talker.handle(exception, stackTrace);
            add(FavoriteStreamFailed(exception));
          },
        );
  }

  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoriteState> emit,
  ) async {
    final authState = authBloc.state;
    if (authState is! AuthAuthenticated) return;

    final current = state;
    final favorites = current is FavoriteLoadSuccess
        ? current.favorites
        : const <FavoriteGame>[];

    if (current is FavoriteLoadSuccess && current.error != null) {
      emit(FavoriteLoadSuccess(favorites: favorites));
    }

    try {
      if (event.isFavorite) {
        await favoriteRepository.removeFavorite(
          userId: authState.user.uid,
          contentId: event.contentId,
        );
      } else {
        await favoriteRepository.addFavorite(
          userId: authState.user.uid,
          contentId: event.contentId,
          title: event.title,
          image: event.image,
        );
      }
    } catch (exception, stackTrace) {
      talker.handle(exception, stackTrace);
      emit(
        FavoriteLoadSuccess(
          favorites: favorites,
          error: 'Не удалось обновить избранное',
        ),
      );
    }
  }

  Future<void> _onRemoved(
    FavoriteRemoved event,
    Emitter<FavoriteState> emit,
  ) async {
    final authState = authBloc.state;
    if (authState is! AuthAuthenticated) return;

    try {
      await favoriteRepository.removeFavorite(
        userId: authState.user.uid,
        contentId: event.contentId,
      );
    } catch (exception, stackTrace) {
      talker.handle(exception, stackTrace);
      final current = state;
      if (current is FavoriteLoadSuccess) {
        emit(
          FavoriteLoadSuccess(
            favorites: current.favorites,
            error: 'Не удалось удалить игру из избранного',
          ),
        );
      }
    }
  }

  void _onDataReceived(
    FavoriteDataReceived event,
    Emitter<FavoriteState> emit,
  ) {
    emit(FavoriteLoadSuccess(favorites: event.favorites));
  }

  void _onStreamFailed(
    FavoriteStreamFailed event,
    Emitter<FavoriteState> emit,
  ) {
    emit(FavoriteLoadFailure(exception: event.exception));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

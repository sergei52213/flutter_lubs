part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

final class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

final class FavoriteLoadInProgress extends FavoriteState {
  const FavoriteLoadInProgress();
}

final class FavoriteLoadSuccess extends FavoriteState {
  const FavoriteLoadSuccess({required this.favorites, this.error});

  final List<FavoriteGame> favorites;
  final String? error;

  bool contains(int contentId) {
    return favorites.any((favorite) => favorite.id == contentId);
  }

  @override
  List<Object?> get props => [favorites, error];
}

final class FavoriteLoadFailure extends FavoriteState {
  const FavoriteLoadFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}

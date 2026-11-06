part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteStarted extends FavoriteEvent {
  const FavoriteStarted();
}

class FavoriteToggled extends FavoriteEvent {
  const FavoriteToggled({
    required this.contentId,
    required this.title,
    required this.image,
    required this.isFavorite,
  });

  final int contentId;
  final String title;
  final String image;
  final bool isFavorite;

  @override
  List<Object?> get props => [contentId, isFavorite];
}

class FavoriteRemoved extends FavoriteEvent {
  const FavoriteRemoved(this.contentId);

  final int contentId;

  @override
  List<Object?> get props => [contentId];
}

class FavoriteDataReceived extends FavoriteEvent {
  const FavoriteDataReceived(this.favorites);

  final List<FavoriteGame> favorites;

  @override
  List<Object?> get props => [favorites];
}

class FavoriteStreamFailed extends FavoriteEvent {
  const FavoriteStreamFailed(this.exception);

  final Object exception;

  @override
  List<Object?> get props => [exception];
}

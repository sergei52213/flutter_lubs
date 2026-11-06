part of 'detail_bloc.dart';

sealed class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

final class DetailInitial extends DetailState {}

final class DetailLoadInProgress extends DetailState {}

final class DetailLoadSuccess extends DetailState {
  const DetailLoadSuccess({required this.content});

  final ContentDetail content;

  @override
  List<Object?> get props => [content];
}

final class DetailLoadFailure extends DetailState {
  const DetailLoadFailure({required this.exception});

  final Object? exception;

  @override
  List<Object?> get props => [exception];
}

part of 'detail_bloc.dart';

sealed class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

class DetailLoad extends DetailEvent {
  const DetailLoad({required this.id, this.completer});

  final int id;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [id, completer];
}

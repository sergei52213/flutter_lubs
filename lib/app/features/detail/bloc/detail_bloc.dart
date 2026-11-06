import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';

import '../../../../domain/domain.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(this.contentRepository, this.talker) : super(DetailInitial()) {
    on<DetailLoad>(_detailLoad);
  }

  final ContentRepositoryInterface contentRepository;
  final Talker talker;

  Future<void> _detailLoad(DetailLoad event, Emitter<DetailState> emit) async {
    try {
      emit(DetailLoadInProgress());

      final content = await contentRepository.getContentById(event.id);
      emit(DetailLoadSuccess(content: content));
    } catch (exception, stackTrace) {
      emit(DetailLoadFailure(exception: exception));
      talker.handle(exception, stackTrace);
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}

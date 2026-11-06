import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker/talker.dart';

import '../../../../domain/domain.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.contentRepository, this.talker) : super(HomeInitial()) {
    on<HomeLoad>(_homeLoad);
  }

  final ContentRepositoryInterface contentRepository;
  final Talker talker;

  Future<void> _homeLoad(HomeLoad event, Emitter<HomeState> emit) async {
    try {
      if (state is! HomeLoadSuccess) {
        emit(HomeLoadInProgress());
      }

      final content = await contentRepository.getContent();
      emit(HomeLoadSuccess(content: content));
    } catch (exception, stackTrace) {
      emit(HomeLoadFailure(exception: exception));
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

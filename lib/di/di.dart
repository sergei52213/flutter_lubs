import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../app/features/auth/bloc/auth_bloc.dart';
import '../app/features/detail/bloc/detail_bloc.dart';
import '../app/features/favorites/bloc/favorite_bloc.dart';
import '../app/features/home/bloc/home_bloc.dart';
import '../data/data.dart';
import '../domain/domain.dart';

final getIt = GetIt.instance;
final talker = TalkerFlutter.init();

Future<void> setupLocator() async {
  getIt.registerSingleton(talker);
  Bloc.observer = TalkerBlocObserver(talker: talker);

  setUpDio(talker: talker);
  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  getIt.registerSingleton<AuthRepositoryInterface>(
    AuthRepository(firebaseAuth: getIt<FirebaseAuth>()),
  );

  getIt.registerSingleton<FavoriteRepositoryInterface>(
    FavoriteRepository(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerSingleton<ContentRepositoryInterface>(
    ContentRepository(dio: dio),
  );

  getIt.registerSingleton<HomeBloc>(
    HomeBloc(getIt<ContentRepositoryInterface>(), talker),
  );

  getIt.registerFactory<DetailBloc>(
    () => DetailBloc(getIt<ContentRepositoryInterface>(), talker),
  );

  getIt.registerSingleton<AuthBloc>(
    AuthBloc(getIt<AuthRepositoryInterface>(), talker),
  );

  getIt.registerFactory<FavoriteBloc>(
    () => FavoriteBloc(
      getIt<FavoriteRepositoryInterface>(),
      getIt<AuthBloc>(),
      talker,
    ),
  );
}

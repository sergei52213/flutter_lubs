import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'dio.dart';

const String _apiBase = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'https://www.freetogame.com/api',
);

void setUpDio({required Talker talker}) {
  dio.options
    ..baseUrl = _apiBase
    ..connectTimeout = const Duration(seconds: 10)
    ..receiveTimeout = const Duration(seconds: 10)
    ..responseType = ResponseType.json;

  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: false,
        printRequestData: true,
        printResponseData: false,
      ),
    ),
  );
}

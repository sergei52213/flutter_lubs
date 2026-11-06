import 'package:dio/dio.dart';

import '../../../../data/data.dart';
import 'content_repository_interface.dart';
import 'model/model.dart';

class ContentRepository implements ContentRepositoryInterface {
  ContentRepository({required this.dio});

  final Dio dio;

  static const int contentLimit = 5;

  @override
  Future<List<Content>> getContent() async {
    try {
      final response = await dio.get<dynamic>(Endpoints.content);
      final data = response.data;

      if (data is! List) {
        throw const FormatException('Неожиданный формат ответа сервера');
      }

      return data
          .take(contentLimit)
          .map((element) => Content.fromJson(element as Map<String, dynamic>))
          .toList();
    } on DioException catch (exception) {
      throw Exception(exception.message ?? 'Ошибка при выполнении запроса');
    }
  }

  @override
  Future<ContentDetail> getContentById(int id) async {
    try {
      final response = await dio.get<dynamic>(
        Endpoints.contentDetail,
        queryParameters: {'id': id},
      );
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const FormatException('Неожиданный формат ответа сервера');
      }

      return ContentDetail.fromJson(data);
    } on DioException catch (exception) {
      throw Exception(exception.message ?? 'Ошибка при выполнении запроса');
    }
  }
}

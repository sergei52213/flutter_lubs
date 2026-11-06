import 'model/model.dart';

abstract interface class ContentRepositoryInterface {
  Future<List<Content>> getContent();

  Future<ContentDetail> getContentById(int id);
}

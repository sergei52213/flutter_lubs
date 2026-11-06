import 'model/model.dart';

abstract interface class FavoriteRepositoryInterface {
  Stream<List<FavoriteGame>> favoritesStream(String userId);

  Future<void> addFavorite({
    required String userId,
    required int contentId,
    required String title,
    required String image,
  });

  Future<void> removeFavorite({required String userId, required int contentId});
}

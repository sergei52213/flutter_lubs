import 'package:cloud_firestore/cloud_firestore.dart';

import 'favorite_repository_interface.dart';
import 'model/model.dart';

class FavoriteRepository implements FavoriteRepositoryInterface {
  FavoriteRepository({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return firestore.collection('users').doc(userId).collection('favorites');
  }

  @override
  Stream<List<FavoriteGame>> favoritesStream(String userId) {
    return _collection(userId)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(FavoriteGame.fromDocument)
              .toList(growable: false),
        );
  }

  @override
  Future<void> addFavorite({
    required String userId,
    required int contentId,
    required String title,
    required String image,
  }) {
    return _collection(userId).doc('$contentId').set({
      'id': contentId,
      'title': title,
      'image': image,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required int contentId,
  }) {
    return _collection(userId).doc('$contentId').delete();
  }
}

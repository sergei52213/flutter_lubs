import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FavoriteGame extends Equatable {
  const FavoriteGame({
    required this.id,
    required this.title,
    required this.image,
    this.addedAt,
  });

  final int id;
  final String title;
  final String image;
  final DateTime? addedAt;

  factory FavoriteGame.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? const <String, dynamic>{};
    final rawId = data['id'];
    final timestamp = data['addedAt'];

    return FavoriteGame(
      id: rawId is num ? rawId.toInt() : int.tryParse(document.id) ?? 0,
      title: data['title'] as String? ?? 'Без названия',
      image: data['image'] as String? ?? '',
      addedAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }

  @override
  List<Object?> get props => [id, title, image, addedAt];
}

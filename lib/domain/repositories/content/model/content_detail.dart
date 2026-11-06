import 'package:json_annotation/json_annotation.dart';

part 'content_detail.g.dart';

@JsonSerializable()
class ContentDetail {
  const ContentDetail({
    required this.id,
    required this.title,
    required this.image,
    required this.status,
    required this.shortDescription,
    required this.description,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
  });

  final int id;
  final String title;

  @JsonKey(name: 'thumbnail')
  final String image;

  final String status;

  @JsonKey(name: 'short_description')
  final String shortDescription;

  final String description;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;

  @JsonKey(name: 'release_date')
  final String releaseDate;

  int get releaseYear => int.tryParse(releaseDate.split('-').first) ?? 0;

  factory ContentDetail.fromJson(Map<String, dynamic> json) =>
      _$ContentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ContentDetailToJson(this);
}

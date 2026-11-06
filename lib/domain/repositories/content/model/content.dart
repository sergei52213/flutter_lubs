import 'package:json_annotation/json_annotation.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
  const Content({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.image,
  });

  final int id;
  final String title;

  @JsonKey(name: 'developer')
  final String author;

  @JsonKey(name: 'short_description')
  final String description;

  @JsonKey(name: 'thumbnail')
  final String image;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

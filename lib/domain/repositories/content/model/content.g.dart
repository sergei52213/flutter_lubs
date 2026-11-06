// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  author: json['developer'] as String,
  description: json['short_description'] as String,
  image: json['thumbnail'] as String,
);

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'developer': instance.author,
  'short_description': instance.description,
  'thumbnail': instance.image,
};

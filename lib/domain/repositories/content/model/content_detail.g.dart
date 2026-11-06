// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentDetail _$ContentDetailFromJson(Map<String, dynamic> json) =>
    ContentDetail(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['thumbnail'] as String,
      status: json['status'] as String,
      shortDescription: json['short_description'] as String,
      description: json['description'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
      publisher: json['publisher'] as String,
      developer: json['developer'] as String,
      releaseDate: json['release_date'] as String,
    );

Map<String, dynamic> _$ContentDetailToJson(ContentDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'thumbnail': instance.image,
      'status': instance.status,
      'short_description': instance.shortDescription,
      'description': instance.description,
      'genre': instance.genre,
      'platform': instance.platform,
      'publisher': instance.publisher,
      'developer': instance.developer,
      'release_date': instance.releaseDate,
    };

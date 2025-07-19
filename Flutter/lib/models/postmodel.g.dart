// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['_id'] as String,
      userID: json['userID'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      img: json['img'] as String,
      creationDate: json['creationDate'] as String,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'title': instance.title,
      'content': instance.content,
      'img': instance.img,
      'creationDate': instance.creationDate,
    };

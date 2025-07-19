// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetchpostsmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchPostModel _$FetchPostModelFromJson(Map<String, dynamic> json) =>
    FetchPostModel(
      id: json['_id'] as String,
      userID: json['userID'] as String,
      title: json['title'] as String,
      user:
          SocialInformationModel.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      img: json['img'] as String,
      creationDate: json['creationDate'] as String,
    );

Map<String, dynamic> _$FetchPostModelToJson(FetchPostModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'user': instance.user,
      'title': instance.title,
      'content': instance.content,
      'img': instance.img,
      'creationDate': instance.creationDate,
    };

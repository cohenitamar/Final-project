// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
      id: json['_id'] as String?,
      userID: json['userID'] as String?,
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      img: json['img'] as String,
      creationDate: json['creationDate'] as String,
      days: (json['days'] as List<dynamic>).map((e) => e as String).toList(),
      rating: json['rating'] as num,
      exercises: (json['exercises'] as List<dynamic>?)
          ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isShared: json['isShared'] as bool,
      raters: json['raters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'img': instance.img,
      'creationDate': instance.creationDate,
      'days': instance.days,
      'rating': instance.rating,
      'exercises': instance.exercises,
      'isShared': instance.isShared,
      'raters': instance.raters,
    };

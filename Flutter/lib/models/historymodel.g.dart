// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historymodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
      id: json['_id'] as String,
      userID: json['userID'] as String,
      title: json['title'] as String,
      executionDate: json['executionDate'] as String,
      duration: json['duration'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'title': instance.title,
      'executionDate': instance.executionDate,
      'duration': instance.duration,
      'exercises': instance.exercises,
    };

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    ExerciseModel(
      name: json['name'] as String,
      img: json['img'] as String,
      category: json['category'] as String,
      exerciseDetails: ExerciseDetailsModel.fromJson(
          json['exerciseDetails'] as Map<String, dynamic>),
      checked: json['checked'] as bool,
    );

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'img': instance.img,
      'category': instance.category,
      'exerciseDetails': instance.exerciseDetails,
      'checked': instance.checked,
    };

ExerciseDetailsModel _$ExerciseDetailsModelFromJson(
        Map<String, dynamic> json) =>
    ExerciseDetailsModel(
      reps: (json['reps'] as num).toInt(),
      sets: (json['sets'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
    );

Map<String, dynamic> _$ExerciseDetailsModelToJson(
        ExerciseDetailsModel instance) =>
    <String, dynamic>{
      'reps': instance.reps,
      'sets': instance.sets,
      'weight': instance.weight,
    };

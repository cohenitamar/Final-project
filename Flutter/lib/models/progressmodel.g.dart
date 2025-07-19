// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progressmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressModel _$ProgressModelFromJson(Map<String, dynamic> json) =>
    ProgressModel(
      id: json['_id'] as String,
      userID: json['userID'] as String,
      exercise: json['exercise'] as String,
      dataByWeek: (json['dataByWeek'] as List<dynamic>)
          .map((e) => DataByWeekModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProgressModelToJson(ProgressModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'exercise': instance.exercise,
      'dataByWeek': instance.dataByWeek.map((e) => e.toJson()).toList(),
    };

DataByWeekModel _$DataByWeekModelFromJson(Map<String, dynamic> json) =>
    DataByWeekModel(
      week: (json['week'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      dataByDate: (json['dataByDate'] as List<dynamic>)
          .map((e) => DataByDateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataByWeekModelToJson(DataByWeekModel instance) =>
    <String, dynamic>{
      'week': instance.week,
      'year': instance.year,
      'dataByDate': instance.dataByDate.map((e) => e.toJson()).toList(),
    };

DataByDateModel _$DataByDateModelFromJson(Map<String, dynamic> json) =>
    DataByDateModel(
      exerciseDetails: ExerciseDetailsModel.fromJson(
          json['exerciseDetails'] as Map<String, dynamic>),
      date: json['date'] as String,
    );

Map<String, dynamic> _$DataByDateModelToJson(DataByDateModel instance) =>
    <String, dynamic>{
      'exerciseDetails': instance.exerciseDetails.toJson(),
      'date': instance.date,
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

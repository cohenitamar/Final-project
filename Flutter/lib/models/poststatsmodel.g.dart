// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poststatsmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostStatsModel _$PostStatsModelFromJson(Map<String, dynamic> json) =>
    PostStatsModel(
      exercise: (json['exercise'] as List<dynamic>)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      history: (json['history'] as List<dynamic>)
          .map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      year: (json['year'] as num).toInt(),
      week: (json['week'] as num).toInt(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$PostStatsModelToJson(PostStatsModel instance) =>
    <String, dynamic>{
      'exercise': instance.exercise,
      'history': instance.history,
      'year': instance.year,
      'week': instance.week,
      'date': instance.date,
    };

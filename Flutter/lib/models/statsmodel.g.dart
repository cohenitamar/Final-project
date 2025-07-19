// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statsmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsModel _$StatsModelFromJson(Map<String, dynamic> json) => StatsModel(
      progress: (json['progress'] as List<dynamic>)
          .map((e) => ProgressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      history: (json['history'] as List<dynamic>)
          .map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatsModelToJson(StatsModel instance) =>
    <String, dynamic>{
      'progress': instance.progress,
      'history': instance.history,
    };

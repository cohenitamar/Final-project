// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievementmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementModel _$AchievementModelFromJson(Map<String, dynamic> json) =>
    AchievementModel(
      id: json['_id'] as String,
      userID: json['userID'] as String,
      maxWeight: (json['maxWeight'] as num).toInt(),
      highestReps: (json['highestReps'] as num).toInt(),
      longestWorkoutDuration:
          (json['longestWorkoutDuration'] as num).toDouble(),
      totalWorkouts: (json['totalWorkouts'] as num).toInt(),
      totalWeightLifted: (json['totalWeightLifted'] as num).toInt(),
      totalReps: (json['totalReps'] as num).toInt(),
      activeDays: (json['activeDays'] as num).toInt(),
      lastActiveDay: json['lastActiveDay'] as String,
      totalWorkoutDuration: (json['totalWorkoutDuration'] as num).toDouble(),
      longestWorkoutStreak: (json['longestWorkoutStreak'] as num).toInt(),
      lastDayOfStreak: json['lastDayOfStreak'] as String,
      lowestBodyFatPercent: (json['lowestBodyFatPercent'] as num).toDouble(),
    );

Map<String, dynamic> _$AchievementModelToJson(AchievementModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'maxWeight': instance.maxWeight,
      'highestReps': instance.highestReps,
      'longestWorkoutDuration': instance.longestWorkoutDuration,
      'longestWorkoutStreak': instance.longestWorkoutStreak,
      'lowestBodyFatPercent': instance.lowestBodyFatPercent,
      'totalWorkouts': instance.totalWorkouts,
      'totalWeightLifted': instance.totalWeightLifted,
      'totalReps': instance.totalReps,
      'activeDays': instance.activeDays,
      'lastActiveDay': instance.lastActiveDay,
      'totalWorkoutDuration': instance.totalWorkoutDuration,
      'lastDayOfStreak': instance.lastDayOfStreak,
    };

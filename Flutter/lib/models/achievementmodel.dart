import 'package:json_annotation/json_annotation.dart';
part 'achievementmodel.g.dart';

@JsonSerializable()
class AchievementModel {
  @JsonKey(name: '_id')
  final String id;
  final String userID;
  final int maxWeight;
  final int highestReps;
  final double longestWorkoutDuration;
  final int longestWorkoutStreak;
  final double lowestBodyFatPercent;
  final int totalWorkouts;
  final int totalWeightLifted;
  final int totalReps;
  final int activeDays;
  final String lastActiveDay;
  final double totalWorkoutDuration;
  final String lastDayOfStreak;

  AchievementModel({
    required this.id,
    required this.userID,
    required this.maxWeight,
    required this.highestReps,
    required this.longestWorkoutDuration,
    required this.totalWorkouts,
    required this.totalWeightLifted,
    required this.totalReps,
    required this.activeDays,
    required this.lastActiveDay,
    required this.totalWorkoutDuration,
    required this.longestWorkoutStreak,
    required this.lastDayOfStreak,
    required this.lowestBodyFatPercent,

  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementModelToJson(this);

}
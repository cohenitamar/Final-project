import 'package:IOFit/Progress/Achievements.dart';

import '../models/achievementmodel.dart';

class AchievementAdapter {
// Convert AchievementModel to GeneralAchievements
  static GeneralAchievements achievementModelToGeneralAchievements(
      AchievementModel model) {
    return GeneralAchievements(
      model.id,
      model.userID,
      model.maxWeight,
      model.highestReps,
      model.longestWorkoutDuration,
      model.lowestBodyFatPercent,
      model.longestWorkoutStreak,
      model.totalWorkouts,
      model.totalWeightLifted,
      model.totalReps,
      model.activeDays,
      model.lastActiveDay,
      model.totalWorkoutDuration,
      model.lastDayOfStreak,
    );
  }

// Convert GeneralAchievements to AchievementModel
  static AchievementModel generalAchievementsToAchievementModel(
      GeneralAchievements achievements) {
    return AchievementModel(
      id: achievements.id,
      userID: achievements.userID,
      maxWeight: achievements.maxWeight,
      highestReps: achievements.highestReps,
      longestWorkoutDuration: achievements.longestWorkoutDuration,
      lowestBodyFatPercent: achievements.lowestBodyFatPercent,
      longestWorkoutStreak: achievements.longestWorkoutStreak,
      totalWorkouts: achievements.totalWorkouts,
      totalWeightLifted: achievements.totalWeightLifted,
      totalReps: achievements.totalReps,
      activeDays: achievements.activeDays,
      lastActiveDay: achievements.lastActiveDay,
      totalWorkoutDuration: achievements.totalWorkoutDuration,
      lastDayOfStreak: achievements.lastDayOfStreak,
    );
  }
}

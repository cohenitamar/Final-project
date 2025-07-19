

import '../Progress/PersonGeneralData.dart';
import '../Progress/workoutProgramData.dart';
import '../models/progressmodel.dart';

class ProgressAdapter {


  static List<WorkoutProgramData> transformToWorkoutProgramData(
      List<ProgressModel> progressList) {
    return progressList.map((progress) {
      return WorkoutProgramData(
        id: progress.id,
        userID: progress.userID,
        name: progress.exercise,
        dataByDateWeek: progress.dataByWeek.map((weekData) {
          return DataByWeek(
            weekNum: weekData.week,
            year: weekData.year,
            dataByDate: weekData.dataByDate.map((dateData) {
              return DataByDate(
                weight: dateData.exerciseDetails.weight,
                reps: dateData.exerciseDetails.reps,
                sets: dateData.exerciseDetails.sets,
                date:
                DateTime.parse(dateData.date), // Convert String to DateTime
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();
  }
}
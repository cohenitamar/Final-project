import 'package:IOFit/Plans/History.dart';
import 'package:IOFit/models/historymodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Plans/plan_exercise.dart';

class Achievements extends StatelessWidget {
  const Achievements({
    Key? key,
    required this.text,
    required this.icon,
    required this.measurement,
    required this.color,
    required this.val,
  }) : super(key: key);

  final String text;
  final String measurement;
  final IconData icon;
  final Color color;
  final double val;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        children: [
          // Left column (fixed width) with ellipsis
          SizedBox(
            width: 265,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis, // <=== ellipsis
            ),
          ),
          // Right column (fixed width) with ellipsis
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 6),
                // If this text is potentially long, wrap it in Expanded or limit it:
                Expanded(
                  child: Text(
                    '${val.toStringAsFixed(0)} $measurement',
                    overflow: TextOverflow.ellipsis, // <=== ellipsis
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneralAchievements {
  String id;
  String userID;
  int maxWeight;
  int highestReps;
  double longestWorkoutDuration;
  int longestWorkoutStreak;
  double lowestBodyFatPercent;
  int totalWorkouts;
  int totalWeightLifted;
  int totalReps;
  int activeDays;
  String lastActiveDay;
  double totalWorkoutDuration;
  String lastDayOfStreak;

  GeneralAchievements(this.id,
      this.userID,
      this.maxWeight,
      this.highestReps,
      this.longestWorkoutDuration,
      this.lowestBodyFatPercent,
      this.longestWorkoutStreak,
      this.totalWorkouts,
      this.totalWeightLifted,
      this.totalReps,
      this.activeDays,
      this.lastActiveDay,
      this.totalWorkoutDuration,
      this.lastDayOfStreak);

  int findMaxWeight(List<ExerciseModel> exc) {
    int max = 0;
    exc.forEach((element) {
      if (element.checked) {
        if (element.exerciseDetails.weight > max) {
          max = element.exerciseDetails.weight;
        }
      }
    });
    return max;
  }


  int findMaxReps(List<ExerciseModel> exc) {
    int max = 0;
    exc.forEach((element) {
      if (element.checked) {
        if (element.exerciseDetails.reps > max) {
          max = element.exerciseDetails.reps;
        }
      }
    });
    return max;
  }

  int sumWeight(List<ExerciseModel> exc) {
    int sum = 0;
    exc.forEach((element) {
      sum += element.exerciseDetails.weight;
    });
    return sum;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int sumReps(List<ExerciseModel> exc) {
    int sum = 0;
    exc.forEach((element) {
      sum += element.exerciseDetails.reps;
    });
    return sum;
  }

  double convertToHours(String time) {
    // Split the time string into components
    List<String> parts = time.split(':');

    if (parts.length != 3) {
      throw FormatException('Invalid time format. Expected hh:mm:ss');
    }

    // Parse hours, minutes, and seconds
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Convert the time into total hours
    double totalHours = hours + (minutes / 60) + (seconds / 3600);

    // Format to one decimal place and parse back to double
    return double.parse(totalHours.toStringAsFixed(1));
  }

  void handleFinish(HistoryModel history) {
    final maxWeight = findMaxWeight(history.exercises);
    if (this.maxWeight < maxWeight) {
      this.maxWeight = maxWeight;
    }
    final maxReps = findMaxReps(history.exercises);
    if (this.highestReps < maxReps) {
      this.highestReps = maxReps;
    }
    this.totalWorkouts += 1;
    this.totalReps += sumReps(history.exercises);
    this.totalWeightLifted += sumWeight(history.exercises);
    if (history.executionDate != this.lastActiveDay) {
      this.activeDays += 1;
    }
    this.lastActiveDay = history.executionDate;
    final time = convertToHours(history.duration);
    if (this.longestWorkoutDuration < time) {
      this.longestWorkoutDuration = time;
    }
    this.totalWorkoutDuration += time;


    if (lastDayOfStreak != "N/A" && history.executionDate != "N/A") {
      DateTime lastDayOfStreakDate =
      DateFormat('dd.MM.yyyy').parse(lastDayOfStreak);
      DateTime historyDate =
      DateFormat('dd.MM.yyyy').parse(history.executionDate);

      lastDayOfStreakDate.add(Duration(days: 1));
      if (!isSameDay(
          DateFormat('dd.MM.yyyy').parse(lastDayOfStreak), DateTime.now())) {
        if (lastDayOfStreakDate == historyDate) {
          this.longestWorkoutStreak += 1;
        } else {
          this.longestWorkoutStreak = 1;
          this.lastDayOfStreak = history.executionDate;
        }
      }
    }
  }
}

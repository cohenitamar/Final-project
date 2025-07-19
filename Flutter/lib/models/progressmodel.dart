import 'package:json_annotation/json_annotation.dart';

part 'progressmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class ProgressModel {
  @JsonKey(name: '_id')
  final String id;
  final String userID;
  final String exercise;
  final List<DataByWeekModel> dataByWeek;

  ProgressModel({
    required this.id,
    required this.userID,
    required this.exercise,
    required this.dataByWeek,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressModelToJson(this);

  @override
  String toString() {
    return 'ProgressModel(id: $id, userID: $userID, exercise: $exercise, dataByWeek: $dataByWeek)';
  }
}

@JsonSerializable(explicitToJson: true)
class DataByWeekModel {
  final int week;
  final int year;
  final List<DataByDateModel> dataByDate;

  DataByWeekModel({
    required this.week,
    required this.year,
    required this.dataByDate,
  });

  factory DataByWeekModel.fromJson(Map<String, dynamic> json) =>
      _$DataByWeekModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataByWeekModelToJson(this);

  @override
  String toString() {
    return 'DataByWeekModel(week: $week, year: $year, dataByDate: $dataByDate)';
  }
}

@JsonSerializable(explicitToJson: true)
class DataByDateModel {
  final ExerciseDetailsModel exerciseDetails;
  final String date;

  DataByDateModel({
    required this.exerciseDetails,
    required this.date,
  });

  factory DataByDateModel.fromJson(Map<String, dynamic> json) =>
      _$DataByDateModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataByDateModelToJson(this);

  @override
  String toString() {
    return 'DataByDateModel(exerciseDetails: $exerciseDetails, date: $date)';
  }
}

@JsonSerializable()
class ExerciseDetailsModel {
  final int reps;
  final int sets;
  final int weight;

  ExerciseDetailsModel({
    required this.reps,
    required this.sets,
    required this.weight,
  });

  factory ExerciseDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseDetailsModelToJson(this);

  @override
  String toString() {
    return 'ExerciseDetailsModel(reps: $reps, sets: $sets, weight: $weight)';
  }
}

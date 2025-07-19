import 'package:json_annotation/json_annotation.dart';

part 'historymodel.g.dart';

@JsonSerializable()
class HistoryModel {
  @JsonKey(name: '_id')
  final String id;
  final String userID;
  final String title;
  final String executionDate;
  final String duration;
  final List<ExerciseModel> exercises;

  HistoryModel({
    required this.id,
    required this.userID,
    required this.title,
    required this.executionDate,
    required this.duration,
    required this.exercises,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);

  @override
  String toString() {
    return 'HistoryModel(id: $id, userID: $userID, title: $title, executionDate: $executionDate, duration: $duration, exercises: $exercises)';
  }
}

@JsonSerializable()
class ExerciseModel {
  final String name;
  final String img;
  final String category;
  final ExerciseDetailsModel exerciseDetails;
  final bool checked;

  ExerciseModel({
    required this.name,
    required this.img,
    required this.category,
    required this.exerciseDetails,
    required this.checked,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseModelToJson(this);

  @override
  String toString() {
    return 'ExerciseModel(name: $name, img: $img, category: $category, exerciseDetails: $exerciseDetails, checked: $checked)';
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

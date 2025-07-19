import 'package:json_annotation/json_annotation.dart';

import 'historymodel.dart';
import 'socialinformationmodel.dart';

part 'fetchplanmodel.g.dart';

@JsonSerializable()
class FetchPlanModel {
  @JsonKey(name: '_id')
  final String? id; // Made nullable
  final SocialInformationModel user;
  final String? userID; // Made nullable
  final String title;
  final String subTitle;
  final String img;
  final String creationDate;
  final List<String> days;
  final num rating;
  final List<ExerciseModel>? exercises;
  final bool isShared;
  final Map<String, dynamic>? raters; // Made nullable

  FetchPlanModel({
    required this.id,
    required this.userID,
    required this.title,
    required this.subTitle,
    required this.img,
    required this.user,
    required this.creationDate,
    required this.days,
    required this.rating,
    required this.exercises,
    required this.isShared,
    required this.raters,
  });

  factory FetchPlanModel.fromJson(Map<String, dynamic> json) =>
      _$FetchPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$FetchPlanModelToJson(this);

  @override
  String toString() {
    return 'PlanModel(id: $id, userID: $userID, title: $title, subTitle: $subTitle, img: $img, creationDate: $creationDate, days: $days, rating: $rating, exercises: $exercises, isShared: $isShared, raters: $raters)';
  }
}

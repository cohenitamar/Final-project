import 'package:json_annotation/json_annotation.dart';
import 'achievementmodel.dart';
import 'personalinformationmodel.dart';
import 'planmodel.dart';
import 'historymodel.dart';
import 'postmodel.dart';
import 'progressmodel.dart';

part 'usermodel.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  @JsonKey(name: '_id')
  final String id;
  final String email;
  final PersonalInformationModel personalInformation;
  @JsonKey(defaultValue: [])
  final List<PlanModel> plans;

  @JsonKey(defaultValue: [])
  final List<HistoryModel> history;

  @JsonKey(defaultValue: [])
  final List<PostModel> posts;

  @JsonKey(defaultValue: [])
  final List<ProgressModel> progress;
  final AchievementModel achievements;

  UserModel({
    required this.id,
    required this.email,
    required this.personalInformation,
    required this.plans,
    required this.history,
    required this.posts,
    required this.progress,
    required this.achievements
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

}

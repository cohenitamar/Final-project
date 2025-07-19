// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usermodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      personalInformation: PersonalInformationModel.fromJson(
          json['personalInformation'] as Map<String, dynamic>),
      plans: (json['plans'] as List<dynamic>?)
              ?.map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => HistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => PostModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      progress: (json['progress'] as List<dynamic>?)
              ?.map((e) => ProgressModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      achievements: AchievementModel.fromJson(
          json['achievements'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'personalInformation': instance.personalInformation.toJson(),
      'plans': instance.plans.map((e) => e.toJson()).toList(),
      'history': instance.history.map((e) => e.toJson()).toList(),
      'posts': instance.posts.map((e) => e.toJson()).toList(),
      'progress': instance.progress.map((e) => e.toJson()).toList(),
      'achievements': instance.achievements.toJson(),
    };

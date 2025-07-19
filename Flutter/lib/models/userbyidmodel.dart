// lib/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'userbyidmodel.g.dart';

@JsonSerializable()
class UserByIDModel {
  @JsonKey(name: '_id')
  final String id;
  final String firstName;
  final String lastName;
  final String profilePic;
  final int age;
  final String gender;
  final String occupation;
  final String experienceLevel;
  final List<String> certifications;
  final List<String> languages;
  final List<String> specializations;
  final Map<String, dynamic> socialAccounts;

  UserByIDModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.experienceLevel,
    required this.certifications,
    required this.languages,
    required this.specializations,
    required this.socialAccounts,
  });

  factory UserByIDModel.fromJson(Map<String, dynamic> json) =>
      _$UserByIDModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserByIDModelToJson(this);

  @override
  String toString() {
    return '''
UserModel {
  id: $id,
  firstName: $firstName,
  lastName: $lastName,
  profilePic: $profilePic,
  age: $age,
  gender: $gender,
  occupation: $occupation,
  experienceLevel: $experienceLevel,
  certifications: $certifications,
  languages: $languages,
  specializations: $specializations,
  socialAccounts: $socialAccounts
}
''';
  }
}

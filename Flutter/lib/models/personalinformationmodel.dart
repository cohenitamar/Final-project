import 'package:json_annotation/json_annotation.dart';

part 'personalinformationmodel.g.dart';

@JsonSerializable(explicitToJson: true)
class PersonalInformationModel {
  @JsonKey(name: '_id')
  final String id;
  final String userID;
  final String firstName;
  final String lastName;
  final String profilePic;
  final double height;
  final double weight;
  final double bodyFat;
  final int trainingsPerWeek;
  final bool doingAerobic;
  final int age;
  final String gender;
  final String occupation;
  final String experienceLevel;
  final List<CertificationModel> certifications;
  final List<String> languages;
  final List<String> specializations;
  final Map<String, String> socialAccounts;

  PersonalInformationModel({
    required this.id,
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.profilePic,
    required this.height,
    required this.weight,
    required this.bodyFat,
    required this.trainingsPerWeek,
    required this.doingAerobic,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.experienceLevel,
    required this.certifications,
    required this.languages,
    required this.specializations,
    required this.socialAccounts,
  });

  factory PersonalInformationModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInformationModelToJson(this);

  @override
  String toString() {
    return 'PersonalInformationModel(id: $id, userID: $userID, firstName: $firstName, lastName: $lastName, profilePic: $profilePic, height: $height, weight: $weight, bodyFat: $bodyFat, trainingsPerWeek: $trainingsPerWeek, doingAerobic: $doingAerobic, age: $age, gender: $gender, occupation: $occupation, experienceLevel: $experienceLevel, certifications: $certifications, languages: $languages, specializations: $specializations, socialAccounts: $socialAccounts)';
  }
}

@JsonSerializable()
class CertificationModel {
  final String title;
  final String link;

  CertificationModel({
    required this.title,
    required this.link,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) =>
      _$CertificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationModelToJson(this);

  @override
  String toString() {
    return 'CertificationModel(title: $title, link: $link)';
  }
}

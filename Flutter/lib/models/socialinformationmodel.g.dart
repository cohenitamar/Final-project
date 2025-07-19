// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socialinformationmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialInformationModel _$SocialInformationModelFromJson(
        Map<String, dynamic> json) =>
    SocialInformationModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePicture: json['profilePicture'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      occupation: json['occupation'] as String,
      experienceLevel: json['experienceLevel'] as String,
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      socialAccounts: Map<String, String>.from(json['socialAccounts'] as Map),
    );

Map<String, dynamic> _$SocialInformationModelToJson(
        SocialInformationModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePicture': instance.profilePicture,
      'age': instance.age,
      'gender': instance.gender,
      'occupation': instance.occupation,
      'experienceLevel': instance.experienceLevel,
      'certifications': instance.certifications,
      'languages': instance.languages,
      'specializations': instance.specializations,
      'socialAccounts': instance.socialAccounts,
    };

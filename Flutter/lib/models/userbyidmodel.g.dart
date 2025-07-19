// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userbyidmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserByIDModel _$UserByIDModelFromJson(Map<String, dynamic> json) =>
    UserByIDModel(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePic: json['profilePic'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      occupation: json['occupation'] as String,
      experienceLevel: json['experienceLevel'] as String,
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      socialAccounts: json['socialAccounts'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$UserByIDModelToJson(UserByIDModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'age': instance.age,
      'gender': instance.gender,
      'occupation': instance.occupation,
      'experienceLevel': instance.experienceLevel,
      'certifications': instance.certifications,
      'languages': instance.languages,
      'specializations': instance.specializations,
      'socialAccounts': instance.socialAccounts,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalinformationmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInformationModel _$PersonalInformationModelFromJson(
        Map<String, dynamic> json) =>
    PersonalInformationModel(
      id: json['_id'] as String,
      userID: json['userID'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePic: json['profilePic'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bodyFat: (json['bodyFat'] as num).toDouble(),
      trainingsPerWeek: (json['trainingsPerWeek'] as num).toInt(),
      doingAerobic: json['doingAerobic'] as bool,
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

Map<String, dynamic> _$PersonalInformationModelToJson(
        PersonalInformationModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userID': instance.userID,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'height': instance.height,
      'weight': instance.weight,
      'bodyFat': instance.bodyFat,
      'trainingsPerWeek': instance.trainingsPerWeek,
      'doingAerobic': instance.doingAerobic,
      'age': instance.age,
      'gender': instance.gender,
      'occupation': instance.occupation,
      'experienceLevel': instance.experienceLevel,
      'certifications': instance.certifications.map((e) => e.toJson()).toList(),
      'languages': instance.languages,
      'specializations': instance.specializations,
      'socialAccounts': instance.socialAccounts,
    };

CertificationModel _$CertificationModelFromJson(Map<String, dynamic> json) =>
    CertificationModel(
      title: json['title'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$CertificationModelToJson(CertificationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'link': instance.link,
    };

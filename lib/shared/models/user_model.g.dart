// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  dailyCalorieGoal: (json['dailyCalorieGoal'] as num?)?.toInt() ?? 2500,
  dailyProteinGoal: (json['dailyProteinGoal'] as num?)?.toInt() ?? 150,
  dailyCarbsGoal: (json['dailyCarbsGoal'] as num?)?.toInt() ?? 275,
  dailyFatGoal: (json['dailyFatGoal'] as num?)?.toInt() ?? 70,
  currentWeight: (json['currentWeight'] as num?)?.toDouble(),
  goalWeight: (json['goalWeight'] as num?)?.toDouble(),
  heightFeet: (json['heightFeet'] as num?)?.toDouble(),
  heightInches: (json['heightInches'] as num?)?.toDouble(),
  heightCm: (json['heightCm'] as num?)?.toDouble(),
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  gender: json['gender'] as String?,
  dailyStepGoal: (json['dailyStepGoal'] as num?)?.toInt() ?? 10000,
  onboardingCompleted: json['onboardingCompleted'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'dailyCalorieGoal': instance.dailyCalorieGoal,
      'dailyProteinGoal': instance.dailyProteinGoal,
      'dailyCarbsGoal': instance.dailyCarbsGoal,
      'dailyFatGoal': instance.dailyFatGoal,
      'currentWeight': instance.currentWeight,
      'goalWeight': instance.goalWeight,
      'heightFeet': instance.heightFeet,
      'heightInches': instance.heightInches,
      'heightCm': instance.heightCm,
      'birthDate': instance.birthDate?.toIso8601String(),
      'gender': instance.gender,
      'dailyStepGoal': instance.dailyStepGoal,
      'onboardingCompleted': instance.onboardingCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

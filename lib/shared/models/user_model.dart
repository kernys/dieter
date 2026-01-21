import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    String? roleModelImageUrl,
    @Default(2500) int dailyCalorieGoal,
    @Default(150) int dailyProteinGoal,
    @Default(275) int dailyCarbsGoal,
    @Default(70) int dailyFatGoal,
    double? currentWeight,
    double? goalWeight,
    double? heightFeet,
    double? heightInches,
    double? heightCm,
    DateTime? birthDate,
    String? gender,
    @Default(10000) int dailyStepGoal,
    bool? onboardingCompleted,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

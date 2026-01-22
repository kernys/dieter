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
    // Notification settings
    @Default(true) bool breakfastReminderEnabled,
    @Default('08:30') String breakfastReminderTime,
    @Default(true) bool lunchReminderEnabled,
    @Default('11:30') String lunchReminderTime,
    @Default(false) bool snackReminderEnabled,
    @Default('16:00') String snackReminderTime,
    @Default(true) bool dinnerReminderEnabled,
    @Default('18:00') String dinnerReminderTime,
    @Default(false) bool endOfDayReminderEnabled,
    @Default('21:00') String endOfDayReminderTime,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

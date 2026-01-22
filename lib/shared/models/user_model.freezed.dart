// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get email; String? get name; String? get avatarUrl; String? get roleModelImageUrl; int get dailyCalorieGoal; int get dailyProteinGoal; int get dailyCarbsGoal; int get dailyFatGoal; double? get currentWeight; double? get goalWeight; double? get heightFeet; double? get heightInches; double? get heightCm; DateTime? get birthDate; String? get gender; int get dailyStepGoal; bool? get onboardingCompleted;// Notification settings
 bool get breakfastReminderEnabled; String get breakfastReminderTime; bool get lunchReminderEnabled; String get lunchReminderTime; bool get snackReminderEnabled; String get snackReminderTime; bool get dinnerReminderEnabled; String get dinnerReminderTime; bool get endOfDayReminderEnabled; String get endOfDayReminderTime; DateTime? get createdAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.roleModelImageUrl, roleModelImageUrl) || other.roleModelImageUrl == roleModelImageUrl)&&(identical(other.dailyCalorieGoal, dailyCalorieGoal) || other.dailyCalorieGoal == dailyCalorieGoal)&&(identical(other.dailyProteinGoal, dailyProteinGoal) || other.dailyProteinGoal == dailyProteinGoal)&&(identical(other.dailyCarbsGoal, dailyCarbsGoal) || other.dailyCarbsGoal == dailyCarbsGoal)&&(identical(other.dailyFatGoal, dailyFatGoal) || other.dailyFatGoal == dailyFatGoal)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.heightFeet, heightFeet) || other.heightFeet == heightFeet)&&(identical(other.heightInches, heightInches) || other.heightInches == heightInches)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dailyStepGoal, dailyStepGoal) || other.dailyStepGoal == dailyStepGoal)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.breakfastReminderEnabled, breakfastReminderEnabled) || other.breakfastReminderEnabled == breakfastReminderEnabled)&&(identical(other.breakfastReminderTime, breakfastReminderTime) || other.breakfastReminderTime == breakfastReminderTime)&&(identical(other.lunchReminderEnabled, lunchReminderEnabled) || other.lunchReminderEnabled == lunchReminderEnabled)&&(identical(other.lunchReminderTime, lunchReminderTime) || other.lunchReminderTime == lunchReminderTime)&&(identical(other.snackReminderEnabled, snackReminderEnabled) || other.snackReminderEnabled == snackReminderEnabled)&&(identical(other.snackReminderTime, snackReminderTime) || other.snackReminderTime == snackReminderTime)&&(identical(other.dinnerReminderEnabled, dinnerReminderEnabled) || other.dinnerReminderEnabled == dinnerReminderEnabled)&&(identical(other.dinnerReminderTime, dinnerReminderTime) || other.dinnerReminderTime == dinnerReminderTime)&&(identical(other.endOfDayReminderEnabled, endOfDayReminderEnabled) || other.endOfDayReminderEnabled == endOfDayReminderEnabled)&&(identical(other.endOfDayReminderTime, endOfDayReminderTime) || other.endOfDayReminderTime == endOfDayReminderTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,name,avatarUrl,roleModelImageUrl,dailyCalorieGoal,dailyProteinGoal,dailyCarbsGoal,dailyFatGoal,currentWeight,goalWeight,heightFeet,heightInches,heightCm,birthDate,gender,dailyStepGoal,onboardingCompleted,breakfastReminderEnabled,breakfastReminderTime,lunchReminderEnabled,lunchReminderTime,snackReminderEnabled,snackReminderTime,dinnerReminderEnabled,dinnerReminderTime,endOfDayReminderEnabled,endOfDayReminderTime,createdAt]);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, roleModelImageUrl: $roleModelImageUrl, dailyCalorieGoal: $dailyCalorieGoal, dailyProteinGoal: $dailyProteinGoal, dailyCarbsGoal: $dailyCarbsGoal, dailyFatGoal: $dailyFatGoal, currentWeight: $currentWeight, goalWeight: $goalWeight, heightFeet: $heightFeet, heightInches: $heightInches, heightCm: $heightCm, birthDate: $birthDate, gender: $gender, dailyStepGoal: $dailyStepGoal, onboardingCompleted: $onboardingCompleted, breakfastReminderEnabled: $breakfastReminderEnabled, breakfastReminderTime: $breakfastReminderTime, lunchReminderEnabled: $lunchReminderEnabled, lunchReminderTime: $lunchReminderTime, snackReminderEnabled: $snackReminderEnabled, snackReminderTime: $snackReminderTime, dinnerReminderEnabled: $dinnerReminderEnabled, dinnerReminderTime: $dinnerReminderTime, endOfDayReminderEnabled: $endOfDayReminderEnabled, endOfDayReminderTime: $endOfDayReminderTime, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? name, String? avatarUrl, String? roleModelImageUrl, int dailyCalorieGoal, int dailyProteinGoal, int dailyCarbsGoal, int dailyFatGoal, double? currentWeight, double? goalWeight, double? heightFeet, double? heightInches, double? heightCm, DateTime? birthDate, String? gender, int dailyStepGoal, bool? onboardingCompleted, bool breakfastReminderEnabled, String breakfastReminderTime, bool lunchReminderEnabled, String lunchReminderTime, bool snackReminderEnabled, String snackReminderTime, bool dinnerReminderEnabled, String dinnerReminderTime, bool endOfDayReminderEnabled, String endOfDayReminderTime, DateTime? createdAt
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? avatarUrl = freezed,Object? roleModelImageUrl = freezed,Object? dailyCalorieGoal = null,Object? dailyProteinGoal = null,Object? dailyCarbsGoal = null,Object? dailyFatGoal = null,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? heightFeet = freezed,Object? heightInches = freezed,Object? heightCm = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? dailyStepGoal = null,Object? onboardingCompleted = freezed,Object? breakfastReminderEnabled = null,Object? breakfastReminderTime = null,Object? lunchReminderEnabled = null,Object? lunchReminderTime = null,Object? snackReminderEnabled = null,Object? snackReminderTime = null,Object? dinnerReminderEnabled = null,Object? dinnerReminderTime = null,Object? endOfDayReminderEnabled = null,Object? endOfDayReminderTime = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,roleModelImageUrl: freezed == roleModelImageUrl ? _self.roleModelImageUrl : roleModelImageUrl // ignore: cast_nullable_to_non_nullable
as String?,dailyCalorieGoal: null == dailyCalorieGoal ? _self.dailyCalorieGoal : dailyCalorieGoal // ignore: cast_nullable_to_non_nullable
as int,dailyProteinGoal: null == dailyProteinGoal ? _self.dailyProteinGoal : dailyProteinGoal // ignore: cast_nullable_to_non_nullable
as int,dailyCarbsGoal: null == dailyCarbsGoal ? _self.dailyCarbsGoal : dailyCarbsGoal // ignore: cast_nullable_to_non_nullable
as int,dailyFatGoal: null == dailyFatGoal ? _self.dailyFatGoal : dailyFatGoal // ignore: cast_nullable_to_non_nullable
as int,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,heightFeet: freezed == heightFeet ? _self.heightFeet : heightFeet // ignore: cast_nullable_to_non_nullable
as double?,heightInches: freezed == heightInches ? _self.heightInches : heightInches // ignore: cast_nullable_to_non_nullable
as double?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dailyStepGoal: null == dailyStepGoal ? _self.dailyStepGoal : dailyStepGoal // ignore: cast_nullable_to_non_nullable
as int,onboardingCompleted: freezed == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool?,breakfastReminderEnabled: null == breakfastReminderEnabled ? _self.breakfastReminderEnabled : breakfastReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,breakfastReminderTime: null == breakfastReminderTime ? _self.breakfastReminderTime : breakfastReminderTime // ignore: cast_nullable_to_non_nullable
as String,lunchReminderEnabled: null == lunchReminderEnabled ? _self.lunchReminderEnabled : lunchReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,lunchReminderTime: null == lunchReminderTime ? _self.lunchReminderTime : lunchReminderTime // ignore: cast_nullable_to_non_nullable
as String,snackReminderEnabled: null == snackReminderEnabled ? _self.snackReminderEnabled : snackReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,snackReminderTime: null == snackReminderTime ? _self.snackReminderTime : snackReminderTime // ignore: cast_nullable_to_non_nullable
as String,dinnerReminderEnabled: null == dinnerReminderEnabled ? _self.dinnerReminderEnabled : dinnerReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,dinnerReminderTime: null == dinnerReminderTime ? _self.dinnerReminderTime : dinnerReminderTime // ignore: cast_nullable_to_non_nullable
as String,endOfDayReminderEnabled: null == endOfDayReminderEnabled ? _self.endOfDayReminderEnabled : endOfDayReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,endOfDayReminderTime: null == endOfDayReminderTime ? _self.endOfDayReminderTime : endOfDayReminderTime // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? avatarUrl,  String? roleModelImageUrl,  int dailyCalorieGoal,  int dailyProteinGoal,  int dailyCarbsGoal,  int dailyFatGoal,  double? currentWeight,  double? goalWeight,  double? heightFeet,  double? heightInches,  double? heightCm,  DateTime? birthDate,  String? gender,  int dailyStepGoal,  bool? onboardingCompleted,  bool breakfastReminderEnabled,  String breakfastReminderTime,  bool lunchReminderEnabled,  String lunchReminderTime,  bool snackReminderEnabled,  String snackReminderTime,  bool dinnerReminderEnabled,  String dinnerReminderTime,  bool endOfDayReminderEnabled,  String endOfDayReminderTime,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.avatarUrl,_that.roleModelImageUrl,_that.dailyCalorieGoal,_that.dailyProteinGoal,_that.dailyCarbsGoal,_that.dailyFatGoal,_that.currentWeight,_that.goalWeight,_that.heightFeet,_that.heightInches,_that.heightCm,_that.birthDate,_that.gender,_that.dailyStepGoal,_that.onboardingCompleted,_that.breakfastReminderEnabled,_that.breakfastReminderTime,_that.lunchReminderEnabled,_that.lunchReminderTime,_that.snackReminderEnabled,_that.snackReminderTime,_that.dinnerReminderEnabled,_that.dinnerReminderTime,_that.endOfDayReminderEnabled,_that.endOfDayReminderTime,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? avatarUrl,  String? roleModelImageUrl,  int dailyCalorieGoal,  int dailyProteinGoal,  int dailyCarbsGoal,  int dailyFatGoal,  double? currentWeight,  double? goalWeight,  double? heightFeet,  double? heightInches,  double? heightCm,  DateTime? birthDate,  String? gender,  int dailyStepGoal,  bool? onboardingCompleted,  bool breakfastReminderEnabled,  String breakfastReminderTime,  bool lunchReminderEnabled,  String lunchReminderTime,  bool snackReminderEnabled,  String snackReminderTime,  bool dinnerReminderEnabled,  String dinnerReminderTime,  bool endOfDayReminderEnabled,  String endOfDayReminderTime,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.name,_that.avatarUrl,_that.roleModelImageUrl,_that.dailyCalorieGoal,_that.dailyProteinGoal,_that.dailyCarbsGoal,_that.dailyFatGoal,_that.currentWeight,_that.goalWeight,_that.heightFeet,_that.heightInches,_that.heightCm,_that.birthDate,_that.gender,_that.dailyStepGoal,_that.onboardingCompleted,_that.breakfastReminderEnabled,_that.breakfastReminderTime,_that.lunchReminderEnabled,_that.lunchReminderTime,_that.snackReminderEnabled,_that.snackReminderTime,_that.dinnerReminderEnabled,_that.dinnerReminderTime,_that.endOfDayReminderEnabled,_that.endOfDayReminderTime,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? name,  String? avatarUrl,  String? roleModelImageUrl,  int dailyCalorieGoal,  int dailyProteinGoal,  int dailyCarbsGoal,  int dailyFatGoal,  double? currentWeight,  double? goalWeight,  double? heightFeet,  double? heightInches,  double? heightCm,  DateTime? birthDate,  String? gender,  int dailyStepGoal,  bool? onboardingCompleted,  bool breakfastReminderEnabled,  String breakfastReminderTime,  bool lunchReminderEnabled,  String lunchReminderTime,  bool snackReminderEnabled,  String snackReminderTime,  bool dinnerReminderEnabled,  String dinnerReminderTime,  bool endOfDayReminderEnabled,  String endOfDayReminderTime,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.avatarUrl,_that.roleModelImageUrl,_that.dailyCalorieGoal,_that.dailyProteinGoal,_that.dailyCarbsGoal,_that.dailyFatGoal,_that.currentWeight,_that.goalWeight,_that.heightFeet,_that.heightInches,_that.heightCm,_that.birthDate,_that.gender,_that.dailyStepGoal,_that.onboardingCompleted,_that.breakfastReminderEnabled,_that.breakfastReminderTime,_that.lunchReminderEnabled,_that.lunchReminderTime,_that.snackReminderEnabled,_that.snackReminderTime,_that.dinnerReminderEnabled,_that.dinnerReminderTime,_that.endOfDayReminderEnabled,_that.endOfDayReminderTime,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.email, this.name, this.avatarUrl, this.roleModelImageUrl, this.dailyCalorieGoal = 2500, this.dailyProteinGoal = 150, this.dailyCarbsGoal = 275, this.dailyFatGoal = 70, this.currentWeight, this.goalWeight, this.heightFeet, this.heightInches, this.heightCm, this.birthDate, this.gender, this.dailyStepGoal = 10000, this.onboardingCompleted, this.breakfastReminderEnabled = true, this.breakfastReminderTime = '08:30', this.lunchReminderEnabled = true, this.lunchReminderTime = '11:30', this.snackReminderEnabled = false, this.snackReminderTime = '16:00', this.dinnerReminderEnabled = true, this.dinnerReminderTime = '18:00', this.endOfDayReminderEnabled = false, this.endOfDayReminderTime = '21:00', this.createdAt});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? name;
@override final  String? avatarUrl;
@override final  String? roleModelImageUrl;
@override@JsonKey() final  int dailyCalorieGoal;
@override@JsonKey() final  int dailyProteinGoal;
@override@JsonKey() final  int dailyCarbsGoal;
@override@JsonKey() final  int dailyFatGoal;
@override final  double? currentWeight;
@override final  double? goalWeight;
@override final  double? heightFeet;
@override final  double? heightInches;
@override final  double? heightCm;
@override final  DateTime? birthDate;
@override final  String? gender;
@override@JsonKey() final  int dailyStepGoal;
@override final  bool? onboardingCompleted;
// Notification settings
@override@JsonKey() final  bool breakfastReminderEnabled;
@override@JsonKey() final  String breakfastReminderTime;
@override@JsonKey() final  bool lunchReminderEnabled;
@override@JsonKey() final  String lunchReminderTime;
@override@JsonKey() final  bool snackReminderEnabled;
@override@JsonKey() final  String snackReminderTime;
@override@JsonKey() final  bool dinnerReminderEnabled;
@override@JsonKey() final  String dinnerReminderTime;
@override@JsonKey() final  bool endOfDayReminderEnabled;
@override@JsonKey() final  String endOfDayReminderTime;
@override final  DateTime? createdAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.roleModelImageUrl, roleModelImageUrl) || other.roleModelImageUrl == roleModelImageUrl)&&(identical(other.dailyCalorieGoal, dailyCalorieGoal) || other.dailyCalorieGoal == dailyCalorieGoal)&&(identical(other.dailyProteinGoal, dailyProteinGoal) || other.dailyProteinGoal == dailyProteinGoal)&&(identical(other.dailyCarbsGoal, dailyCarbsGoal) || other.dailyCarbsGoal == dailyCarbsGoal)&&(identical(other.dailyFatGoal, dailyFatGoal) || other.dailyFatGoal == dailyFatGoal)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.heightFeet, heightFeet) || other.heightFeet == heightFeet)&&(identical(other.heightInches, heightInches) || other.heightInches == heightInches)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dailyStepGoal, dailyStepGoal) || other.dailyStepGoal == dailyStepGoal)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.breakfastReminderEnabled, breakfastReminderEnabled) || other.breakfastReminderEnabled == breakfastReminderEnabled)&&(identical(other.breakfastReminderTime, breakfastReminderTime) || other.breakfastReminderTime == breakfastReminderTime)&&(identical(other.lunchReminderEnabled, lunchReminderEnabled) || other.lunchReminderEnabled == lunchReminderEnabled)&&(identical(other.lunchReminderTime, lunchReminderTime) || other.lunchReminderTime == lunchReminderTime)&&(identical(other.snackReminderEnabled, snackReminderEnabled) || other.snackReminderEnabled == snackReminderEnabled)&&(identical(other.snackReminderTime, snackReminderTime) || other.snackReminderTime == snackReminderTime)&&(identical(other.dinnerReminderEnabled, dinnerReminderEnabled) || other.dinnerReminderEnabled == dinnerReminderEnabled)&&(identical(other.dinnerReminderTime, dinnerReminderTime) || other.dinnerReminderTime == dinnerReminderTime)&&(identical(other.endOfDayReminderEnabled, endOfDayReminderEnabled) || other.endOfDayReminderEnabled == endOfDayReminderEnabled)&&(identical(other.endOfDayReminderTime, endOfDayReminderTime) || other.endOfDayReminderTime == endOfDayReminderTime)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,name,avatarUrl,roleModelImageUrl,dailyCalorieGoal,dailyProteinGoal,dailyCarbsGoal,dailyFatGoal,currentWeight,goalWeight,heightFeet,heightInches,heightCm,birthDate,gender,dailyStepGoal,onboardingCompleted,breakfastReminderEnabled,breakfastReminderTime,lunchReminderEnabled,lunchReminderTime,snackReminderEnabled,snackReminderTime,dinnerReminderEnabled,dinnerReminderTime,endOfDayReminderEnabled,endOfDayReminderTime,createdAt]);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, roleModelImageUrl: $roleModelImageUrl, dailyCalorieGoal: $dailyCalorieGoal, dailyProteinGoal: $dailyProteinGoal, dailyCarbsGoal: $dailyCarbsGoal, dailyFatGoal: $dailyFatGoal, currentWeight: $currentWeight, goalWeight: $goalWeight, heightFeet: $heightFeet, heightInches: $heightInches, heightCm: $heightCm, birthDate: $birthDate, gender: $gender, dailyStepGoal: $dailyStepGoal, onboardingCompleted: $onboardingCompleted, breakfastReminderEnabled: $breakfastReminderEnabled, breakfastReminderTime: $breakfastReminderTime, lunchReminderEnabled: $lunchReminderEnabled, lunchReminderTime: $lunchReminderTime, snackReminderEnabled: $snackReminderEnabled, snackReminderTime: $snackReminderTime, dinnerReminderEnabled: $dinnerReminderEnabled, dinnerReminderTime: $dinnerReminderTime, endOfDayReminderEnabled: $endOfDayReminderEnabled, endOfDayReminderTime: $endOfDayReminderTime, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? name, String? avatarUrl, String? roleModelImageUrl, int dailyCalorieGoal, int dailyProteinGoal, int dailyCarbsGoal, int dailyFatGoal, double? currentWeight, double? goalWeight, double? heightFeet, double? heightInches, double? heightCm, DateTime? birthDate, String? gender, int dailyStepGoal, bool? onboardingCompleted, bool breakfastReminderEnabled, String breakfastReminderTime, bool lunchReminderEnabled, String lunchReminderTime, bool snackReminderEnabled, String snackReminderTime, bool dinnerReminderEnabled, String dinnerReminderTime, bool endOfDayReminderEnabled, String endOfDayReminderTime, DateTime? createdAt
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? avatarUrl = freezed,Object? roleModelImageUrl = freezed,Object? dailyCalorieGoal = null,Object? dailyProteinGoal = null,Object? dailyCarbsGoal = null,Object? dailyFatGoal = null,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? heightFeet = freezed,Object? heightInches = freezed,Object? heightCm = freezed,Object? birthDate = freezed,Object? gender = freezed,Object? dailyStepGoal = null,Object? onboardingCompleted = freezed,Object? breakfastReminderEnabled = null,Object? breakfastReminderTime = null,Object? lunchReminderEnabled = null,Object? lunchReminderTime = null,Object? snackReminderEnabled = null,Object? snackReminderTime = null,Object? dinnerReminderEnabled = null,Object? dinnerReminderTime = null,Object? endOfDayReminderEnabled = null,Object? endOfDayReminderTime = null,Object? createdAt = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,roleModelImageUrl: freezed == roleModelImageUrl ? _self.roleModelImageUrl : roleModelImageUrl // ignore: cast_nullable_to_non_nullable
as String?,dailyCalorieGoal: null == dailyCalorieGoal ? _self.dailyCalorieGoal : dailyCalorieGoal // ignore: cast_nullable_to_non_nullable
as int,dailyProteinGoal: null == dailyProteinGoal ? _self.dailyProteinGoal : dailyProteinGoal // ignore: cast_nullable_to_non_nullable
as int,dailyCarbsGoal: null == dailyCarbsGoal ? _self.dailyCarbsGoal : dailyCarbsGoal // ignore: cast_nullable_to_non_nullable
as int,dailyFatGoal: null == dailyFatGoal ? _self.dailyFatGoal : dailyFatGoal // ignore: cast_nullable_to_non_nullable
as int,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,heightFeet: freezed == heightFeet ? _self.heightFeet : heightFeet // ignore: cast_nullable_to_non_nullable
as double?,heightInches: freezed == heightInches ? _self.heightInches : heightInches // ignore: cast_nullable_to_non_nullable
as double?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dailyStepGoal: null == dailyStepGoal ? _self.dailyStepGoal : dailyStepGoal // ignore: cast_nullable_to_non_nullable
as int,onboardingCompleted: freezed == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool?,breakfastReminderEnabled: null == breakfastReminderEnabled ? _self.breakfastReminderEnabled : breakfastReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,breakfastReminderTime: null == breakfastReminderTime ? _self.breakfastReminderTime : breakfastReminderTime // ignore: cast_nullable_to_non_nullable
as String,lunchReminderEnabled: null == lunchReminderEnabled ? _self.lunchReminderEnabled : lunchReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,lunchReminderTime: null == lunchReminderTime ? _self.lunchReminderTime : lunchReminderTime // ignore: cast_nullable_to_non_nullable
as String,snackReminderEnabled: null == snackReminderEnabled ? _self.snackReminderEnabled : snackReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,snackReminderTime: null == snackReminderTime ? _self.snackReminderTime : snackReminderTime // ignore: cast_nullable_to_non_nullable
as String,dinnerReminderEnabled: null == dinnerReminderEnabled ? _self.dinnerReminderEnabled : dinnerReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,dinnerReminderTime: null == dinnerReminderTime ? _self.dinnerReminderTime : dinnerReminderTime // ignore: cast_nullable_to_non_nullable
as String,endOfDayReminderEnabled: null == endOfDayReminderEnabled ? _self.endOfDayReminderEnabled : endOfDayReminderEnabled // ignore: cast_nullable_to_non_nullable
as bool,endOfDayReminderTime: null == endOfDayReminderTime ? _self.endOfDayReminderTime : endOfDayReminderTime // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

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

 String get id; String get email; String? get name; String? get avatarUrl; int get dailyCalorieGoal; int get dailyProteinGoal; int get dailyCarbsGoal; int get dailyFatGoal; double? get currentWeight; double? get goalWeight; DateTime? get createdAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.dailyCalorieGoal, dailyCalorieGoal) || other.dailyCalorieGoal == dailyCalorieGoal)&&(identical(other.dailyProteinGoal, dailyProteinGoal) || other.dailyProteinGoal == dailyProteinGoal)&&(identical(other.dailyCarbsGoal, dailyCarbsGoal) || other.dailyCarbsGoal == dailyCarbsGoal)&&(identical(other.dailyFatGoal, dailyFatGoal) || other.dailyFatGoal == dailyFatGoal)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,avatarUrl,dailyCalorieGoal,dailyProteinGoal,dailyCarbsGoal,dailyFatGoal,currentWeight,goalWeight,createdAt);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, dailyCalorieGoal: $dailyCalorieGoal, dailyProteinGoal: $dailyProteinGoal, dailyCarbsGoal: $dailyCarbsGoal, dailyFatGoal: $dailyFatGoal, currentWeight: $currentWeight, goalWeight: $goalWeight, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? name, String? avatarUrl, int dailyCalorieGoal, int dailyProteinGoal, int dailyCarbsGoal, int dailyFatGoal, double? currentWeight, double? goalWeight, DateTime? createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? avatarUrl = freezed,Object? dailyCalorieGoal = null,Object? dailyProteinGoal = null,Object? dailyCarbsGoal = null,Object? dailyFatGoal = null,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,dailyCalorieGoal: null == dailyCalorieGoal ? _self.dailyCalorieGoal : dailyCalorieGoal // ignore: cast_nullable_to_non_nullable
as int,dailyProteinGoal: null == dailyProteinGoal ? _self.dailyProteinGoal : dailyProteinGoal // ignore: cast_nullable_to_non_nullable
as int,dailyCarbsGoal: null == dailyCarbsGoal ? _self.dailyCarbsGoal : dailyCarbsGoal // ignore: cast_nullable_to_non_nullable
as int,dailyFatGoal: null == dailyFatGoal ? _self.dailyFatGoal : dailyFatGoal // ignore: cast_nullable_to_non_nullable
as int,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? avatarUrl,  int dailyCalorieGoal,  int dailyProteinGoal,  int dailyCarbsGoal,  int dailyFatGoal,  double? currentWeight,  double? goalWeight,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.avatarUrl,_that.dailyCalorieGoal,_that.dailyProteinGoal,_that.dailyCarbsGoal,_that.dailyFatGoal,_that.currentWeight,_that.goalWeight,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? avatarUrl,  int dailyCalorieGoal,  int dailyProteinGoal,  int dailyCarbsGoal,  int dailyFatGoal,  double? currentWeight,  double? goalWeight,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.name,_that.avatarUrl,_that.dailyCalorieGoal,_that.dailyProteinGoal,_that.dailyCarbsGoal,_that.dailyFatGoal,_that.currentWeight,_that.goalWeight,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? name,  String? avatarUrl,  int dailyCalorieGoal,  int dailyProteinGoal,  int dailyCarbsGoal,  int dailyFatGoal,  double? currentWeight,  double? goalWeight,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.avatarUrl,_that.dailyCalorieGoal,_that.dailyProteinGoal,_that.dailyCarbsGoal,_that.dailyFatGoal,_that.currentWeight,_that.goalWeight,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.email, this.name, this.avatarUrl, this.dailyCalorieGoal = 2500, this.dailyProteinGoal = 150, this.dailyCarbsGoal = 275, this.dailyFatGoal = 70, this.currentWeight, this.goalWeight, this.createdAt});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? name;
@override final  String? avatarUrl;
@override@JsonKey() final  int dailyCalorieGoal;
@override@JsonKey() final  int dailyProteinGoal;
@override@JsonKey() final  int dailyCarbsGoal;
@override@JsonKey() final  int dailyFatGoal;
@override final  double? currentWeight;
@override final  double? goalWeight;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.dailyCalorieGoal, dailyCalorieGoal) || other.dailyCalorieGoal == dailyCalorieGoal)&&(identical(other.dailyProteinGoal, dailyProteinGoal) || other.dailyProteinGoal == dailyProteinGoal)&&(identical(other.dailyCarbsGoal, dailyCarbsGoal) || other.dailyCarbsGoal == dailyCarbsGoal)&&(identical(other.dailyFatGoal, dailyFatGoal) || other.dailyFatGoal == dailyFatGoal)&&(identical(other.currentWeight, currentWeight) || other.currentWeight == currentWeight)&&(identical(other.goalWeight, goalWeight) || other.goalWeight == goalWeight)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,avatarUrl,dailyCalorieGoal,dailyProteinGoal,dailyCarbsGoal,dailyFatGoal,currentWeight,goalWeight,createdAt);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, dailyCalorieGoal: $dailyCalorieGoal, dailyProteinGoal: $dailyProteinGoal, dailyCarbsGoal: $dailyCarbsGoal, dailyFatGoal: $dailyFatGoal, currentWeight: $currentWeight, goalWeight: $goalWeight, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? name, String? avatarUrl, int dailyCalorieGoal, int dailyProteinGoal, int dailyCarbsGoal, int dailyFatGoal, double? currentWeight, double? goalWeight, DateTime? createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? avatarUrl = freezed,Object? dailyCalorieGoal = null,Object? dailyProteinGoal = null,Object? dailyCarbsGoal = null,Object? dailyFatGoal = null,Object? currentWeight = freezed,Object? goalWeight = freezed,Object? createdAt = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,dailyCalorieGoal: null == dailyCalorieGoal ? _self.dailyCalorieGoal : dailyCalorieGoal // ignore: cast_nullable_to_non_nullable
as int,dailyProteinGoal: null == dailyProteinGoal ? _self.dailyProteinGoal : dailyProteinGoal // ignore: cast_nullable_to_non_nullable
as int,dailyCarbsGoal: null == dailyCarbsGoal ? _self.dailyCarbsGoal : dailyCarbsGoal // ignore: cast_nullable_to_non_nullable
as int,dailyFatGoal: null == dailyFatGoal ? _self.dailyFatGoal : dailyFatGoal // ignore: cast_nullable_to_non_nullable
as int,currentWeight: freezed == currentWeight ? _self.currentWeight : currentWeight // ignore: cast_nullable_to_non_nullable
as double?,goalWeight: freezed == goalWeight ? _self.goalWeight : goalWeight // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

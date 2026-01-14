// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeightLogModel {

 String get id; String get userId; double get weight; DateTime get loggedAt; String? get note;
/// Create a copy of WeightLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightLogModelCopyWith<WeightLogModel> get copyWith => _$WeightLogModelCopyWithImpl<WeightLogModel>(this as WeightLogModel, _$identity);

  /// Serializes this WeightLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,weight,loggedAt,note);

@override
String toString() {
  return 'WeightLogModel(id: $id, userId: $userId, weight: $weight, loggedAt: $loggedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $WeightLogModelCopyWith<$Res>  {
  factory $WeightLogModelCopyWith(WeightLogModel value, $Res Function(WeightLogModel) _then) = _$WeightLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, double weight, DateTime loggedAt, String? note
});




}
/// @nodoc
class _$WeightLogModelCopyWithImpl<$Res>
    implements $WeightLogModelCopyWith<$Res> {
  _$WeightLogModelCopyWithImpl(this._self, this._then);

  final WeightLogModel _self;
  final $Res Function(WeightLogModel) _then;

/// Create a copy of WeightLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? weight = null,Object? loggedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightLogModel].
extension WeightLogModelPatterns on WeightLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightLogModel value)  $default,){
final _that = this;
switch (_that) {
case _WeightLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _WeightLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  double weight,  DateTime loggedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.weight,_that.loggedAt,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  double weight,  DateTime loggedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _WeightLogModel():
return $default(_that.id,_that.userId,_that.weight,_that.loggedAt,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  double weight,  DateTime loggedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _WeightLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.weight,_that.loggedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightLogModel implements WeightLogModel {
  const _WeightLogModel({required this.id, required this.userId, required this.weight, required this.loggedAt, this.note});
  factory _WeightLogModel.fromJson(Map<String, dynamic> json) => _$WeightLogModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  double weight;
@override final  DateTime loggedAt;
@override final  String? note;

/// Create a copy of WeightLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightLogModelCopyWith<_WeightLogModel> get copyWith => __$WeightLogModelCopyWithImpl<_WeightLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,weight,loggedAt,note);

@override
String toString() {
  return 'WeightLogModel(id: $id, userId: $userId, weight: $weight, loggedAt: $loggedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$WeightLogModelCopyWith<$Res> implements $WeightLogModelCopyWith<$Res> {
  factory _$WeightLogModelCopyWith(_WeightLogModel value, $Res Function(_WeightLogModel) _then) = __$WeightLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, double weight, DateTime loggedAt, String? note
});




}
/// @nodoc
class __$WeightLogModelCopyWithImpl<$Res>
    implements _$WeightLogModelCopyWith<$Res> {
  __$WeightLogModelCopyWithImpl(this._self, this._then);

  final _WeightLogModel _self;
  final $Res Function(_WeightLogModel) _then;

/// Create a copy of WeightLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? weight = null,Object? loggedAt = null,Object? note = freezed,}) {
  return _then(_WeightLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

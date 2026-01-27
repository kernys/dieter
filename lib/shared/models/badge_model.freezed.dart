// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BadgeModel {

 String get id; String get name; String get description; String? get iconUrl; String get category; Map<String, dynamic> get requirement; bool get isHidden; bool get earned; DateTime? get earnedAt; int get progress; bool get isNew;
/// Create a copy of BadgeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeModelCopyWith<BadgeModel> get copyWith => _$BadgeModelCopyWithImpl<BadgeModel>(this as BadgeModel, _$identity);

  /// Serializes this BadgeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.requirement, requirement)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isNew, isNew) || other.isNew == isNew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconUrl,category,const DeepCollectionEquality().hash(requirement),isHidden,earned,earnedAt,progress,isNew);

@override
String toString() {
  return 'BadgeModel(id: $id, name: $name, description: $description, iconUrl: $iconUrl, category: $category, requirement: $requirement, isHidden: $isHidden, earned: $earned, earnedAt: $earnedAt, progress: $progress, isNew: $isNew)';
}


}

/// @nodoc
abstract mixin class $BadgeModelCopyWith<$Res>  {
  factory $BadgeModelCopyWith(BadgeModel value, $Res Function(BadgeModel) _then) = _$BadgeModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String? iconUrl, String category, Map<String, dynamic> requirement, bool isHidden, bool earned, DateTime? earnedAt, int progress, bool isNew
});




}
/// @nodoc
class _$BadgeModelCopyWithImpl<$Res>
    implements $BadgeModelCopyWith<$Res> {
  _$BadgeModelCopyWithImpl(this._self, this._then);

  final BadgeModel _self;
  final $Res Function(BadgeModel) _then;

/// Create a copy of BadgeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconUrl = freezed,Object? category = null,Object? requirement = null,Object? isHidden = null,Object? earned = null,Object? earnedAt = freezed,Object? progress = null,Object? isNew = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,requirement: null == requirement ? _self.requirement : requirement // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as bool,earnedAt: freezed == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeModel].
extension BadgeModelPatterns on BadgeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeModel value)  $default,){
final _that = this;
switch (_that) {
case _BadgeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeModel value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? iconUrl,  String category,  Map<String, dynamic> requirement,  bool isHidden,  bool earned,  DateTime? earnedAt,  int progress,  bool isNew)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconUrl,_that.category,_that.requirement,_that.isHidden,_that.earned,_that.earnedAt,_that.progress,_that.isNew);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String? iconUrl,  String category,  Map<String, dynamic> requirement,  bool isHidden,  bool earned,  DateTime? earnedAt,  int progress,  bool isNew)  $default,) {final _that = this;
switch (_that) {
case _BadgeModel():
return $default(_that.id,_that.name,_that.description,_that.iconUrl,_that.category,_that.requirement,_that.isHidden,_that.earned,_that.earnedAt,_that.progress,_that.isNew);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String? iconUrl,  String category,  Map<String, dynamic> requirement,  bool isHidden,  bool earned,  DateTime? earnedAt,  int progress,  bool isNew)?  $default,) {final _that = this;
switch (_that) {
case _BadgeModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconUrl,_that.category,_that.requirement,_that.isHidden,_that.earned,_that.earnedAt,_that.progress,_that.isNew);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgeModel implements BadgeModel {
  const _BadgeModel({required this.id, required this.name, required this.description, this.iconUrl, required this.category, final  Map<String, dynamic> requirement = const {}, this.isHidden = false, this.earned = false, this.earnedAt, this.progress = 0, this.isNew = false}): _requirement = requirement;
  factory _BadgeModel.fromJson(Map<String, dynamic> json) => _$BadgeModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String? iconUrl;
@override final  String category;
 final  Map<String, dynamic> _requirement;
@override@JsonKey() Map<String, dynamic> get requirement {
  if (_requirement is EqualUnmodifiableMapView) return _requirement;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_requirement);
}

@override@JsonKey() final  bool isHidden;
@override@JsonKey() final  bool earned;
@override final  DateTime? earnedAt;
@override@JsonKey() final  int progress;
@override@JsonKey() final  bool isNew;

/// Create a copy of BadgeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeModelCopyWith<_BadgeModel> get copyWith => __$BadgeModelCopyWithImpl<_BadgeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._requirement, _requirement)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isNew, isNew) || other.isNew == isNew));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconUrl,category,const DeepCollectionEquality().hash(_requirement),isHidden,earned,earnedAt,progress,isNew);

@override
String toString() {
  return 'BadgeModel(id: $id, name: $name, description: $description, iconUrl: $iconUrl, category: $category, requirement: $requirement, isHidden: $isHidden, earned: $earned, earnedAt: $earnedAt, progress: $progress, isNew: $isNew)';
}


}

/// @nodoc
abstract mixin class _$BadgeModelCopyWith<$Res> implements $BadgeModelCopyWith<$Res> {
  factory _$BadgeModelCopyWith(_BadgeModel value, $Res Function(_BadgeModel) _then) = __$BadgeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String? iconUrl, String category, Map<String, dynamic> requirement, bool isHidden, bool earned, DateTime? earnedAt, int progress, bool isNew
});




}
/// @nodoc
class __$BadgeModelCopyWithImpl<$Res>
    implements _$BadgeModelCopyWith<$Res> {
  __$BadgeModelCopyWithImpl(this._self, this._then);

  final _BadgeModel _self;
  final $Res Function(_BadgeModel) _then;

/// Create a copy of BadgeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconUrl = freezed,Object? category = null,Object? requirement = null,Object? isHidden = null,Object? earned = null,Object? earnedAt = freezed,Object? progress = null,Object? isNew = null,}) {
  return _then(_BadgeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,requirement: null == requirement ? _self._requirement : requirement // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as bool,earnedAt: freezed == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BadgesResponse {

 List<BadgeModel> get badges; BadgeStats get stats;
/// Create a copy of BadgesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgesResponseCopyWith<BadgesResponse> get copyWith => _$BadgesResponseCopyWithImpl<BadgesResponse>(this as BadgesResponse, _$identity);

  /// Serializes this BadgesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgesResponse&&const DeepCollectionEquality().equals(other.badges, badges)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(badges),stats);

@override
String toString() {
  return 'BadgesResponse(badges: $badges, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $BadgesResponseCopyWith<$Res>  {
  factory $BadgesResponseCopyWith(BadgesResponse value, $Res Function(BadgesResponse) _then) = _$BadgesResponseCopyWithImpl;
@useResult
$Res call({
 List<BadgeModel> badges, BadgeStats stats
});


$BadgeStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$BadgesResponseCopyWithImpl<$Res>
    implements $BadgesResponseCopyWith<$Res> {
  _$BadgesResponseCopyWithImpl(this._self, this._then);

  final BadgesResponse _self;
  final $Res Function(BadgesResponse) _then;

/// Create a copy of BadgesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? badges = null,Object? stats = null,}) {
  return _then(_self.copyWith(
badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<BadgeModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as BadgeStats,
  ));
}
/// Create a copy of BadgesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BadgeStatsCopyWith<$Res> get stats {
  
  return $BadgeStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [BadgesResponse].
extension BadgesResponsePatterns on BadgesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgesResponse value)  $default,){
final _that = this;
switch (_that) {
case _BadgesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BadgesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BadgeModel> badges,  BadgeStats stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgesResponse() when $default != null:
return $default(_that.badges,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BadgeModel> badges,  BadgeStats stats)  $default,) {final _that = this;
switch (_that) {
case _BadgesResponse():
return $default(_that.badges,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BadgeModel> badges,  BadgeStats stats)?  $default,) {final _that = this;
switch (_that) {
case _BadgesResponse() when $default != null:
return $default(_that.badges,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgesResponse implements BadgesResponse {
  const _BadgesResponse({required final  List<BadgeModel> badges, required this.stats}): _badges = badges;
  factory _BadgesResponse.fromJson(Map<String, dynamic> json) => _$BadgesResponseFromJson(json);

 final  List<BadgeModel> _badges;
@override List<BadgeModel> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

@override final  BadgeStats stats;

/// Create a copy of BadgesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgesResponseCopyWith<_BadgesResponse> get copyWith => __$BadgesResponseCopyWithImpl<_BadgesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgesResponse&&const DeepCollectionEquality().equals(other._badges, _badges)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_badges),stats);

@override
String toString() {
  return 'BadgesResponse(badges: $badges, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$BadgesResponseCopyWith<$Res> implements $BadgesResponseCopyWith<$Res> {
  factory _$BadgesResponseCopyWith(_BadgesResponse value, $Res Function(_BadgesResponse) _then) = __$BadgesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<BadgeModel> badges, BadgeStats stats
});


@override $BadgeStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$BadgesResponseCopyWithImpl<$Res>
    implements _$BadgesResponseCopyWith<$Res> {
  __$BadgesResponseCopyWithImpl(this._self, this._then);

  final _BadgesResponse _self;
  final $Res Function(_BadgesResponse) _then;

/// Create a copy of BadgesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? badges = null,Object? stats = null,}) {
  return _then(_BadgesResponse(
badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<BadgeModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as BadgeStats,
  ));
}

/// Create a copy of BadgesResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BadgeStatsCopyWith<$Res> get stats {
  
  return $BadgeStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$BadgeStats {

 int get total; int get earned; int get newBadges;
/// Create a copy of BadgeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeStatsCopyWith<BadgeStats> get copyWith => _$BadgeStatsCopyWithImpl<BadgeStats>(this as BadgeStats, _$identity);

  /// Serializes this BadgeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeStats&&(identical(other.total, total) || other.total == total)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.newBadges, newBadges) || other.newBadges == newBadges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,earned,newBadges);

@override
String toString() {
  return 'BadgeStats(total: $total, earned: $earned, newBadges: $newBadges)';
}


}

/// @nodoc
abstract mixin class $BadgeStatsCopyWith<$Res>  {
  factory $BadgeStatsCopyWith(BadgeStats value, $Res Function(BadgeStats) _then) = _$BadgeStatsCopyWithImpl;
@useResult
$Res call({
 int total, int earned, int newBadges
});




}
/// @nodoc
class _$BadgeStatsCopyWithImpl<$Res>
    implements $BadgeStatsCopyWith<$Res> {
  _$BadgeStatsCopyWithImpl(this._self, this._then);

  final BadgeStats _self;
  final $Res Function(BadgeStats) _then;

/// Create a copy of BadgeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? earned = null,Object? newBadges = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,newBadges: null == newBadges ? _self.newBadges : newBadges // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeStats].
extension BadgeStatsPatterns on BadgeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeStats value)  $default,){
final _that = this;
switch (_that) {
case _BadgeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeStats value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int earned,  int newBadges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeStats() when $default != null:
return $default(_that.total,_that.earned,_that.newBadges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int earned,  int newBadges)  $default,) {final _that = this;
switch (_that) {
case _BadgeStats():
return $default(_that.total,_that.earned,_that.newBadges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int earned,  int newBadges)?  $default,) {final _that = this;
switch (_that) {
case _BadgeStats() when $default != null:
return $default(_that.total,_that.earned,_that.newBadges);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BadgeStats implements BadgeStats {
  const _BadgeStats({required this.total, required this.earned, this.newBadges = 0});
  factory _BadgeStats.fromJson(Map<String, dynamic> json) => _$BadgeStatsFromJson(json);

@override final  int total;
@override final  int earned;
@override@JsonKey() final  int newBadges;

/// Create a copy of BadgeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeStatsCopyWith<_BadgeStats> get copyWith => __$BadgeStatsCopyWithImpl<_BadgeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BadgeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeStats&&(identical(other.total, total) || other.total == total)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.newBadges, newBadges) || other.newBadges == newBadges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,earned,newBadges);

@override
String toString() {
  return 'BadgeStats(total: $total, earned: $earned, newBadges: $newBadges)';
}


}

/// @nodoc
abstract mixin class _$BadgeStatsCopyWith<$Res> implements $BadgeStatsCopyWith<$Res> {
  factory _$BadgeStatsCopyWith(_BadgeStats value, $Res Function(_BadgeStats) _then) = __$BadgeStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int earned, int newBadges
});




}
/// @nodoc
class __$BadgeStatsCopyWithImpl<$Res>
    implements _$BadgeStatsCopyWith<$Res> {
  __$BadgeStatsCopyWithImpl(this._self, this._then);

  final _BadgeStats _self;
  final $Res Function(_BadgeStats) _then;

/// Create a copy of BadgeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? earned = null,Object? newBadges = null,}) {
  return _then(_BadgeStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,newBadges: null == newBadges ? _self.newBadges : newBadges // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

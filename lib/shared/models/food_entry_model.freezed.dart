// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodEntryModel {

 String get id; String get userId; String get name; int get calories; double get protein; double get carbs; double get fat; String? get imageUrl; List<IngredientModel> get ingredients; int get servings; DateTime get loggedAt;
/// Create a copy of FoodEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodEntryModelCopyWith<FoodEntryModel> get copyWith => _$FoodEntryModelCopyWithImpl<FoodEntryModel>(this as FoodEntryModel, _$identity);

  /// Serializes this FoodEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,calories,protein,carbs,fat,imageUrl,const DeepCollectionEquality().hash(ingredients),servings,loggedAt);

@override
String toString() {
  return 'FoodEntryModel(id: $id, userId: $userId, name: $name, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, imageUrl: $imageUrl, ingredients: $ingredients, servings: $servings, loggedAt: $loggedAt)';
}


}

/// @nodoc
abstract mixin class $FoodEntryModelCopyWith<$Res>  {
  factory $FoodEntryModelCopyWith(FoodEntryModel value, $Res Function(FoodEntryModel) _then) = _$FoodEntryModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, int calories, double protein, double carbs, double fat, String? imageUrl, List<IngredientModel> ingredients, int servings, DateTime loggedAt
});




}
/// @nodoc
class _$FoodEntryModelCopyWithImpl<$Res>
    implements $FoodEntryModelCopyWith<$Res> {
  _$FoodEntryModelCopyWithImpl(this._self, this._then);

  final FoodEntryModel _self;
  final $Res Function(FoodEntryModel) _then;

/// Create a copy of FoodEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? imageUrl = freezed,Object? ingredients = null,Object? servings = null,Object? loggedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<IngredientModel>,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodEntryModel].
extension FoodEntryModelPatterns on FoodEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _FoodEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _FoodEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  int calories,  double protein,  double carbs,  double fat,  String? imageUrl,  List<IngredientModel> ingredients,  int servings,  DateTime loggedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodEntryModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.calories,_that.protein,_that.carbs,_that.fat,_that.imageUrl,_that.ingredients,_that.servings,_that.loggedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  int calories,  double protein,  double carbs,  double fat,  String? imageUrl,  List<IngredientModel> ingredients,  int servings,  DateTime loggedAt)  $default,) {final _that = this;
switch (_that) {
case _FoodEntryModel():
return $default(_that.id,_that.userId,_that.name,_that.calories,_that.protein,_that.carbs,_that.fat,_that.imageUrl,_that.ingredients,_that.servings,_that.loggedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  int calories,  double protein,  double carbs,  double fat,  String? imageUrl,  List<IngredientModel> ingredients,  int servings,  DateTime loggedAt)?  $default,) {final _that = this;
switch (_that) {
case _FoodEntryModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.calories,_that.protein,_that.carbs,_that.fat,_that.imageUrl,_that.ingredients,_that.servings,_that.loggedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodEntryModel implements FoodEntryModel {
  const _FoodEntryModel({required this.id, required this.userId, required this.name, required this.calories, required this.protein, required this.carbs, required this.fat, this.imageUrl, final  List<IngredientModel> ingredients = const [], this.servings = 1, required this.loggedAt}): _ingredients = ingredients;
  factory _FoodEntryModel.fromJson(Map<String, dynamic> json) => _$FoodEntryModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  int calories;
@override final  double protein;
@override final  double carbs;
@override final  double fat;
@override final  String? imageUrl;
 final  List<IngredientModel> _ingredients;
@override@JsonKey() List<IngredientModel> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

@override@JsonKey() final  int servings;
@override final  DateTime loggedAt;

/// Create a copy of FoodEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodEntryModelCopyWith<_FoodEntryModel> get copyWith => __$FoodEntryModelCopyWithImpl<_FoodEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,calories,protein,carbs,fat,imageUrl,const DeepCollectionEquality().hash(_ingredients),servings,loggedAt);

@override
String toString() {
  return 'FoodEntryModel(id: $id, userId: $userId, name: $name, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, imageUrl: $imageUrl, ingredients: $ingredients, servings: $servings, loggedAt: $loggedAt)';
}


}

/// @nodoc
abstract mixin class _$FoodEntryModelCopyWith<$Res> implements $FoodEntryModelCopyWith<$Res> {
  factory _$FoodEntryModelCopyWith(_FoodEntryModel value, $Res Function(_FoodEntryModel) _then) = __$FoodEntryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, int calories, double protein, double carbs, double fat, String? imageUrl, List<IngredientModel> ingredients, int servings, DateTime loggedAt
});




}
/// @nodoc
class __$FoodEntryModelCopyWithImpl<$Res>
    implements _$FoodEntryModelCopyWith<$Res> {
  __$FoodEntryModelCopyWithImpl(this._self, this._then);

  final _FoodEntryModel _self;
  final $Res Function(_FoodEntryModel) _then;

/// Create a copy of FoodEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? calories = null,Object? protein = null,Object? carbs = null,Object? fat = null,Object? imageUrl = freezed,Object? ingredients = null,Object? servings = null,Object? loggedAt = null,}) {
  return _then(_FoodEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,carbs: null == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<IngredientModel>,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$IngredientModel {

 String get name; int get calories; String? get amount; double? get protein; double? get carbs; double? get fat;
/// Create a copy of IngredientModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IngredientModelCopyWith<IngredientModel> get copyWith => _$IngredientModelCopyWithImpl<IngredientModel>(this as IngredientModel, _$identity);

  /// Serializes this IngredientModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IngredientModel&&(identical(other.name, name) || other.name == name)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,calories,amount,protein,carbs,fat);

@override
String toString() {
  return 'IngredientModel(name: $name, calories: $calories, amount: $amount, protein: $protein, carbs: $carbs, fat: $fat)';
}


}

/// @nodoc
abstract mixin class $IngredientModelCopyWith<$Res>  {
  factory $IngredientModelCopyWith(IngredientModel value, $Res Function(IngredientModel) _then) = _$IngredientModelCopyWithImpl;
@useResult
$Res call({
 String name, int calories, String? amount, double? protein, double? carbs, double? fat
});




}
/// @nodoc
class _$IngredientModelCopyWithImpl<$Res>
    implements $IngredientModelCopyWith<$Res> {
  _$IngredientModelCopyWithImpl(this._self, this._then);

  final IngredientModel _self;
  final $Res Function(IngredientModel) _then;

/// Create a copy of IngredientModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? calories = null,Object? amount = freezed,Object? protein = freezed,Object? carbs = freezed,Object? fat = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,carbs: freezed == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double?,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [IngredientModel].
extension IngredientModelPatterns on IngredientModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IngredientModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IngredientModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IngredientModel value)  $default,){
final _that = this;
switch (_that) {
case _IngredientModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IngredientModel value)?  $default,){
final _that = this;
switch (_that) {
case _IngredientModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int calories,  String? amount,  double? protein,  double? carbs,  double? fat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IngredientModel() when $default != null:
return $default(_that.name,_that.calories,_that.amount,_that.protein,_that.carbs,_that.fat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int calories,  String? amount,  double? protein,  double? carbs,  double? fat)  $default,) {final _that = this;
switch (_that) {
case _IngredientModel():
return $default(_that.name,_that.calories,_that.amount,_that.protein,_that.carbs,_that.fat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int calories,  String? amount,  double? protein,  double? carbs,  double? fat)?  $default,) {final _that = this;
switch (_that) {
case _IngredientModel() when $default != null:
return $default(_that.name,_that.calories,_that.amount,_that.protein,_that.carbs,_that.fat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IngredientModel implements IngredientModel {
  const _IngredientModel({required this.name, required this.calories, this.amount, this.protein, this.carbs, this.fat});
  factory _IngredientModel.fromJson(Map<String, dynamic> json) => _$IngredientModelFromJson(json);

@override final  String name;
@override final  int calories;
@override final  String? amount;
@override final  double? protein;
@override final  double? carbs;
@override final  double? fat;

/// Create a copy of IngredientModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IngredientModelCopyWith<_IngredientModel> get copyWith => __$IngredientModelCopyWithImpl<_IngredientModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IngredientModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IngredientModel&&(identical(other.name, name) || other.name == name)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carbs, carbs) || other.carbs == carbs)&&(identical(other.fat, fat) || other.fat == fat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,calories,amount,protein,carbs,fat);

@override
String toString() {
  return 'IngredientModel(name: $name, calories: $calories, amount: $amount, protein: $protein, carbs: $carbs, fat: $fat)';
}


}

/// @nodoc
abstract mixin class _$IngredientModelCopyWith<$Res> implements $IngredientModelCopyWith<$Res> {
  factory _$IngredientModelCopyWith(_IngredientModel value, $Res Function(_IngredientModel) _then) = __$IngredientModelCopyWithImpl;
@override @useResult
$Res call({
 String name, int calories, String? amount, double? protein, double? carbs, double? fat
});




}
/// @nodoc
class __$IngredientModelCopyWithImpl<$Res>
    implements _$IngredientModelCopyWith<$Res> {
  __$IngredientModelCopyWithImpl(this._self, this._then);

  final _IngredientModel _self;
  final $Res Function(_IngredientModel) _then;

/// Create a copy of IngredientModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? calories = null,Object? amount = freezed,Object? protein = freezed,Object? carbs = freezed,Object? fat = freezed,}) {
  return _then(_IngredientModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,protein: freezed == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double?,carbs: freezed == carbs ? _self.carbs : carbs // ignore: cast_nullable_to_non_nullable
as double?,fat: freezed == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$DailySummaryModel {

 String get id; String get userId; DateTime get date; int get totalCalories; double get totalProtein; double get totalCarbs; double get totalFat; List<FoodEntryModel> get entries;
/// Create a copy of DailySummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailySummaryModelCopyWith<DailySummaryModel> get copyWith => _$DailySummaryModelCopyWithImpl<DailySummaryModel>(this as DailySummaryModel, _$identity);

  /// Serializes this DailySummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailySummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalCalories, totalCalories) || other.totalCalories == totalCalories)&&(identical(other.totalProtein, totalProtein) || other.totalProtein == totalProtein)&&(identical(other.totalCarbs, totalCarbs) || other.totalCarbs == totalCarbs)&&(identical(other.totalFat, totalFat) || other.totalFat == totalFat)&&const DeepCollectionEquality().equals(other.entries, entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,totalCalories,totalProtein,totalCarbs,totalFat,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'DailySummaryModel(id: $id, userId: $userId, date: $date, totalCalories: $totalCalories, totalProtein: $totalProtein, totalCarbs: $totalCarbs, totalFat: $totalFat, entries: $entries)';
}


}

/// @nodoc
abstract mixin class $DailySummaryModelCopyWith<$Res>  {
  factory $DailySummaryModelCopyWith(DailySummaryModel value, $Res Function(DailySummaryModel) _then) = _$DailySummaryModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DateTime date, int totalCalories, double totalProtein, double totalCarbs, double totalFat, List<FoodEntryModel> entries
});




}
/// @nodoc
class _$DailySummaryModelCopyWithImpl<$Res>
    implements $DailySummaryModelCopyWith<$Res> {
  _$DailySummaryModelCopyWithImpl(this._self, this._then);

  final DailySummaryModel _self;
  final $Res Function(DailySummaryModel) _then;

/// Create a copy of DailySummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? totalCalories = null,Object? totalProtein = null,Object? totalCarbs = null,Object? totalFat = null,Object? entries = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalCalories: null == totalCalories ? _self.totalCalories : totalCalories // ignore: cast_nullable_to_non_nullable
as int,totalProtein: null == totalProtein ? _self.totalProtein : totalProtein // ignore: cast_nullable_to_non_nullable
as double,totalCarbs: null == totalCarbs ? _self.totalCarbs : totalCarbs // ignore: cast_nullable_to_non_nullable
as double,totalFat: null == totalFat ? _self.totalFat : totalFat // ignore: cast_nullable_to_non_nullable
as double,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<FoodEntryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailySummaryModel].
extension DailySummaryModelPatterns on DailySummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailySummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailySummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailySummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _DailySummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailySummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _DailySummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  int totalCalories,  double totalProtein,  double totalCarbs,  double totalFat,  List<FoodEntryModel> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailySummaryModel() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.totalCalories,_that.totalProtein,_that.totalCarbs,_that.totalFat,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DateTime date,  int totalCalories,  double totalProtein,  double totalCarbs,  double totalFat,  List<FoodEntryModel> entries)  $default,) {final _that = this;
switch (_that) {
case _DailySummaryModel():
return $default(_that.id,_that.userId,_that.date,_that.totalCalories,_that.totalProtein,_that.totalCarbs,_that.totalFat,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DateTime date,  int totalCalories,  double totalProtein,  double totalCarbs,  double totalFat,  List<FoodEntryModel> entries)?  $default,) {final _that = this;
switch (_that) {
case _DailySummaryModel() when $default != null:
return $default(_that.id,_that.userId,_that.date,_that.totalCalories,_that.totalProtein,_that.totalCarbs,_that.totalFat,_that.entries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailySummaryModel implements DailySummaryModel {
  const _DailySummaryModel({required this.id, required this.userId, required this.date, this.totalCalories = 0, this.totalProtein = 0.0, this.totalCarbs = 0.0, this.totalFat = 0.0, final  List<FoodEntryModel> entries = const []}): _entries = entries;
  factory _DailySummaryModel.fromJson(Map<String, dynamic> json) => _$DailySummaryModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DateTime date;
@override@JsonKey() final  int totalCalories;
@override@JsonKey() final  double totalProtein;
@override@JsonKey() final  double totalCarbs;
@override@JsonKey() final  double totalFat;
 final  List<FoodEntryModel> _entries;
@override@JsonKey() List<FoodEntryModel> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of DailySummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailySummaryModelCopyWith<_DailySummaryModel> get copyWith => __$DailySummaryModelCopyWithImpl<_DailySummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailySummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailySummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalCalories, totalCalories) || other.totalCalories == totalCalories)&&(identical(other.totalProtein, totalProtein) || other.totalProtein == totalProtein)&&(identical(other.totalCarbs, totalCarbs) || other.totalCarbs == totalCarbs)&&(identical(other.totalFat, totalFat) || other.totalFat == totalFat)&&const DeepCollectionEquality().equals(other._entries, _entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,date,totalCalories,totalProtein,totalCarbs,totalFat,const DeepCollectionEquality().hash(_entries));

@override
String toString() {
  return 'DailySummaryModel(id: $id, userId: $userId, date: $date, totalCalories: $totalCalories, totalProtein: $totalProtein, totalCarbs: $totalCarbs, totalFat: $totalFat, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$DailySummaryModelCopyWith<$Res> implements $DailySummaryModelCopyWith<$Res> {
  factory _$DailySummaryModelCopyWith(_DailySummaryModel value, $Res Function(_DailySummaryModel) _then) = __$DailySummaryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DateTime date, int totalCalories, double totalProtein, double totalCarbs, double totalFat, List<FoodEntryModel> entries
});




}
/// @nodoc
class __$DailySummaryModelCopyWithImpl<$Res>
    implements _$DailySummaryModelCopyWith<$Res> {
  __$DailySummaryModelCopyWithImpl(this._self, this._then);

  final _DailySummaryModel _self;
  final $Res Function(_DailySummaryModel) _then;

/// Create a copy of DailySummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? date = null,Object? totalCalories = null,Object? totalProtein = null,Object? totalCarbs = null,Object? totalFat = null,Object? entries = null,}) {
  return _then(_DailySummaryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalCalories: null == totalCalories ? _self.totalCalories : totalCalories // ignore: cast_nullable_to_non_nullable
as int,totalProtein: null == totalProtein ? _self.totalProtein : totalProtein // ignore: cast_nullable_to_non_nullable
as double,totalCarbs: null == totalCarbs ? _self.totalCarbs : totalCarbs // ignore: cast_nullable_to_non_nullable
as double,totalFat: null == totalFat ? _self.totalFat : totalFat // ignore: cast_nullable_to_non_nullable
as double,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<FoodEntryModel>,
  ));
}


}

// dart format on

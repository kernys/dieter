// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightLogModel _$WeightLogModelFromJson(Map<String, dynamic> json) =>
    _WeightLogModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weight: (json['weight'] as num).toDouble(),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$WeightLogModelToJson(_WeightLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'weight': instance.weight,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'note': instance.note,
    };

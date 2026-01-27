// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BadgeModel _$BadgeModelFromJson(Map<String, dynamic> json) => _BadgeModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  iconUrl: json['iconUrl'] as String?,
  category: json['category'] as String,
  requirement: json['requirement'] as Map<String, dynamic>? ?? const {},
  isHidden: json['isHidden'] as bool? ?? false,
  earned: json['earned'] as bool? ?? false,
  earnedAt: json['earnedAt'] == null
      ? null
      : DateTime.parse(json['earnedAt'] as String),
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  isNew: json['isNew'] as bool? ?? false,
);

Map<String, dynamic> _$BadgeModelToJson(_BadgeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'category': instance.category,
      'requirement': instance.requirement,
      'isHidden': instance.isHidden,
      'earned': instance.earned,
      'earnedAt': instance.earnedAt?.toIso8601String(),
      'progress': instance.progress,
      'isNew': instance.isNew,
    };

_BadgesResponse _$BadgesResponseFromJson(Map<String, dynamic> json) =>
    _BadgesResponse(
      badges: (json['badges'] as List<dynamic>)
          .map((e) => BadgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: BadgeStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BadgesResponseToJson(_BadgesResponse instance) =>
    <String, dynamic>{'badges': instance.badges, 'stats': instance.stats};

_BadgeStats _$BadgeStatsFromJson(Map<String, dynamic> json) => _BadgeStats(
  total: (json['total'] as num).toInt(),
  earned: (json['earned'] as num).toInt(),
  newBadges: (json['newBadges'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BadgeStatsToJson(_BadgeStats instance) =>
    <String, dynamic>{
      'total': instance.total,
      'earned': instance.earned,
      'newBadges': instance.newBadges,
    };

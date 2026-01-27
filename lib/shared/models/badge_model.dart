import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge_model.freezed.dart';
part 'badge_model.g.dart';

@freezed
abstract class BadgeModel with _$BadgeModel {
  const factory BadgeModel({
    required String id,
    required String name,
    required String description,
    String? iconUrl,
    required String category,
    @Default({}) Map<String, dynamic> requirement,
    @Default(false) bool isHidden,
    @Default(false) bool earned,
    DateTime? earnedAt,
    @Default(0) int progress,
    @Default(false) bool isNew,
  }) = _BadgeModel;

  factory BadgeModel.fromJson(Map<String, dynamic> json) =>
      _$BadgeModelFromJson(json);
}

@freezed
abstract class BadgesResponse with _$BadgesResponse {
  const factory BadgesResponse({
    required List<BadgeModel> badges,
    required BadgeStats stats,
  }) = _BadgesResponse;

  factory BadgesResponse.fromJson(Map<String, dynamic> json) =>
      _$BadgesResponseFromJson(json);
}

@freezed
abstract class BadgeStats with _$BadgeStats {
  const factory BadgeStats({
    required int total,
    required int earned,
    @Default(0) int newBadges,
  }) = _BadgeStats;

  factory BadgeStats.fromJson(Map<String, dynamic> json) =>
      _$BadgeStatsFromJson(json);
}

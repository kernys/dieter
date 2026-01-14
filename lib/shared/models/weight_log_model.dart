import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_log_model.freezed.dart';
part 'weight_log_model.g.dart';

@freezed
abstract class WeightLogModel with _$WeightLogModel {
  const factory WeightLogModel({
    required String id,
    required String userId,
    required double weight,
    required DateTime loggedAt,
    String? note,
  }) = _WeightLogModel;

  factory WeightLogModel.fromJson(Map<String, dynamic> json) =>
      _$WeightLogModelFromJson(json);
}

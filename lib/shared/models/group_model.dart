import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const factory GroupModel({
    required String id,
    required String name,
    required String description,
    required int memberCount,
    String? imageUrl,
    required bool isPrivate,
    required bool isMember,
    required DateTime createdAt,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}

@freezed
class GroupMember with _$GroupMember {
  const factory GroupMember({
    required String id,
    required String userId,
    required String username,
    String? profileImage,
    required int score,
    required int rank,
  }) = _GroupMember;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);
}

@freezed
class GroupMessage with _$GroupMessage {
  const factory GroupMessage({
    required String id,
    required String groupId,
    required String userId,
    required String username,
    String? userProfileImage,
    required String message,
    required DateTime createdAt,
  }) = _GroupMessage;

  factory GroupMessage.fromJson(Map<String, dynamic> json) =>
      _$GroupMessageFromJson(json);
}

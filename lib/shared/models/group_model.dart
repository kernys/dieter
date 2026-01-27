import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
abstract class GroupModel with _$GroupModel {
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
abstract class GroupMember with _$GroupMember {
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
abstract class GroupMessage with _$GroupMessage {
  const factory GroupMessage({
    required String id,
    required String groupId,
    required String userId,
    required String username,
    String? userProfileImage,
    required String message,
    String? imageUrl,
    String? replyToId,
    GroupMessage? replyTo,
    @Default([]) List<MessageReaction> reactions,
    @Default(0) int replyCount,
    required DateTime createdAt,
  }) = _GroupMessage;

  factory GroupMessage.fromJson(Map<String, dynamic> json) =>
      _$GroupMessageFromJson(json);
}

@freezed
abstract class MessageReaction with _$MessageReaction {
  const factory MessageReaction({
    required String emoji,
    required int count,
    @Default(false) bool userReacted,
  }) = _MessageReaction;

  factory MessageReaction.fromJson(Map<String, dynamic> json) =>
      _$MessageReactionFromJson(json);
}

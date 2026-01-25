// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => _GroupModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  memberCount: (json['memberCount'] as num).toInt(),
  imageUrl: json['imageUrl'] as String?,
  isPrivate: json['isPrivate'] as bool,
  isMember: json['isMember'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$GroupModelToJson(_GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'memberCount': instance.memberCount,
      'imageUrl': instance.imageUrl,
      'isPrivate': instance.isPrivate,
      'isMember': instance.isMember,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => _GroupMember(
  id: json['id'] as String,
  userId: json['userId'] as String,
  username: json['username'] as String,
  profileImage: json['profileImage'] as String?,
  score: (json['score'] as num).toInt(),
  rank: (json['rank'] as num).toInt(),
);

Map<String, dynamic> _$GroupMemberToJson(_GroupMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'profileImage': instance.profileImage,
      'score': instance.score,
      'rank': instance.rank,
    };

_GroupMessage _$GroupMessageFromJson(Map<String, dynamic> json) =>
    _GroupMessage(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userProfileImage: json['userProfileImage'] as String?,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$GroupMessageToJson(_GroupMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'userId': instance.userId,
      'username': instance.username,
      'userProfileImage': instance.userProfileImage,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
    };

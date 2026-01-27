import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/api_service.dart';
import '../../../../shared/models/group_model.dart';

// Discover groups - all public groups
final discoverGroupsProvider = FutureProvider<List<GroupModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getGroups();
});

// User's joined groups
final myGroupsProvider = FutureProvider<List<GroupModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getMyGroups();
});

// Selected group for detail view
final selectedGroupProvider = FutureProvider.family<GroupModel, String>((ref, groupId) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getGroup(groupId);
});

// Group leaderboard data
final groupLeaderboardProvider = FutureProvider.family<List<GroupMember>, String>((ref, groupId) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getGroupMembers(groupId);
});

// Group chat messages
final groupMessagesProvider = FutureProvider.family<List<GroupMessage>, String>((ref, groupId) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getGroupMessages(groupId);
});

// Join group action
final joinGroupProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String groupId) async {
    await apiService.joinGroup(groupId);
    // Invalidate providers to refresh data
    ref.invalidate(discoverGroupsProvider);
    ref.invalidate(myGroupsProvider);
    ref.invalidate(selectedGroupProvider);
  };
});

// Leave group action
final leaveGroupProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String groupId) async {
    await apiService.leaveGroup(groupId);
    // Invalidate providers to refresh data
    ref.invalidate(discoverGroupsProvider);
    ref.invalidate(myGroupsProvider);
    ref.invalidate(selectedGroupProvider);
  };
});

// Send message action
final sendMessageProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String groupId, String message, {String? imageUrl, String? replyToId}) async {
    await apiService.sendGroupMessage(groupId, message, imageUrl: imageUrl, replyToId: replyToId);
    // Invalidate messages to refresh
    ref.invalidate(groupMessagesProvider);
  };
});

// Toggle reaction action
final toggleReactionProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return (String groupId, String messageId, String emoji) async {
    await apiService.toggleMessageReaction(groupId, messageId, emoji);
    // Invalidate messages to refresh
    ref.invalidate(groupMessagesProvider);
  };
});

// Get message replies
final messageRepliesProvider = FutureProvider.family<List<GroupMessage>, ({String groupId, String messageId})>((ref, params) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getMessageReplies(params.groupId, params.messageId);
});

// Create group action
final createGroupProvider = Provider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ({required String name, String description = '', bool isPrivate = false, String? imageUrl}) async {
    final group = await apiService.createGroup(name: name, description: description, isPrivate: isPrivate, imageUrl: imageUrl);
    // Invalidate providers to refresh data
    ref.invalidate(discoverGroupsProvider);
    ref.invalidate(myGroupsProvider);
    return group;
  };
});

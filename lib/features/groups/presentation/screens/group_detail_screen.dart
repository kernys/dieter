import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/group_model.dart';
import '../../../../services/api_service.dart';
import '../providers/groups_provider.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(selectedGroupProvider(widget.groupId));
    final leaderboardAsync = ref.watch(groupLeaderboardProvider(widget.groupId));
    final messagesAsync = ref.watch(groupMessagesProvider(widget.groupId));

    return groupAsync.when(
      data: (group) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.group, size: 20, color: AppColors.textTertiary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.group_outlined, color: AppColors.textPrimary),
              onPressed: () {
                // TODO: Show members
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Chat'),
              Tab(text: 'Leaderboard'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Chat Tab
            messagesAsync.when(
              data: (messages) => _ChatTab(messages: messages, groupId: widget.groupId),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),

            // Leaderboard Tab
            leaderboardAsync.when(
              data: (leaderboard) => _LeaderboardTab(leaderboard: leaderboard),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
        bottomNavigationBar: group.isMember
            ? null
            : Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: () async {
                      final joinGroup = ref.read(joinGroupProvider);
                      try {
                        await joinGroup(widget.groupId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Joined group successfully')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to join group: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF77),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.workspace_premium, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Upgrade to Join Group',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ChatTab extends ConsumerStatefulWidget {
  final List<GroupMessage> messages;
  final String groupId;

  const _ChatTab({required this.messages, required this.groupId});

  @override
  ConsumerState<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<_ChatTab> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  GroupMessage? _replyingTo;
  bool _isUploading = false;
  String? _selectedImagePath;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    
    if (pickedFile == null) return;
    
    setState(() => _selectedImagePath = pickedFile.path);
  }

  void _removeSelectedImage() {
    setState(() => _selectedImagePath = null);
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty && _selectedImagePath == null) return;

    setState(() => _isUploading = true);

    try {
      String? imageUrl;
      
      // Upload image if selected
      if (_selectedImagePath != null) {
        final apiService = ref.read(apiServiceProvider);
        imageUrl = await apiService.uploadImage(File(_selectedImagePath!));
      }
      
      // Send message with optional image
      final sendMessage = ref.read(sendMessageProvider);
      await sendMessage(
        widget.groupId, 
        message,
        imageUrl: imageUrl,
        replyToId: _replyingTo?.id,
      );
      
      _messageController.clear();
      setState(() {
        _replyingTo = null;
        _selectedImagePath = null;
        _isUploading = false;
      });
      
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _showReactionPicker(GroupMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ReactionPicker(
        onReactionSelected: (emoji) async {
          Navigator.pop(context);
          final toggleReaction = ref.read(toggleReactionProvider);
          try {
            await toggleReaction(widget.groupId, message.id, emoji);
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add reaction: $e')),
              );
            }
          }
        },
        onReply: () {
          Navigator.pop(context);
          setState(() => _replyingTo = message);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[index];
              return _MessageBubble(
                message: message,
                onLongPress: () => _showReactionPicker(message),
                onAddReaction: () => _showReactionPicker(message),
                onReactionTap: (emoji) async {
                  final toggleReaction = ref.read(toggleReactionProvider);
                  await toggleReaction(widget.groupId, message.id, emoji);
                },
                onViewReplies: message.replyCount > 0 ? () {
                  _showRepliesSheet(message);
                } : null,
              );
            },
          ),
        ),
        // Reply indicator
        if (_replyingTo != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: Row(
              children: [
                const Icon(Icons.reply, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Replying to ${_replyingTo!.username}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() => _replyingTo = null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        // Selected image preview
        if (_selectedImagePath != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_selectedImagePath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Image selected',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                  onPressed: _removeSelectedImage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        // Input area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Camera button
                IconButton(
                  onPressed: _isUploading ? null : _pickImage,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _selectedImagePath != null 
                              ? Icons.add_photo_alternate 
                              : Icons.camera_alt_outlined, 
                          color: _selectedImagePath != null 
                              ? AppColors.primary 
                              : AppColors.textSecondary,
                        ),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _selectedImagePath != null 
                          ? 'Add a caption...' 
                          : 'Type a message...',
                      hintStyle: const TextStyle(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isUploading ? null : _sendMessage,
                  icon: Icon(
                    Icons.send, 
                    color: _isUploading ? AppColors.textSecondary : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showRepliesSheet(GroupMessage message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _RepliesSheet(
          message: message,
          groupId: widget.groupId,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final GroupMessage message;
  final VoidCallback? onLongPress;
  final VoidCallback? onAddReaction;
  final Function(String emoji)? onReactionTap;
  final VoidCallback? onViewReplies;

  const _MessageBubble({
    required this.message,
    this.onLongPress,
    this.onAddReaction,
    this.onReactionTap,
    this.onViewReplies,
  });

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                image: message.userProfileImage != null
                    ? DecorationImage(
                        image: NetworkImage(message.userProfileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: message.userProfileImage == null
                  ? Center(
                      child: Text(
                        message.username.isNotEmpty ? message.username[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        message.username,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(message.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Message text
                  if (message.message.isNotEmpty)
                    Text(
                      message.message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  // Image
                  if (message.imageUrl != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        message.imageUrl!,
                        width: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 200,
                          height: 150,
                          color: AppColors.surface,
                          child: const Icon(Icons.broken_image, color: AppColors.textTertiary),
                        ),
                      ),
                    ),
                  ],
                  // Reactions with add button
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      // Add reaction button
                      GestureDetector(
                        onTap: onAddReaction,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_reaction_outlined, size: 16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                      // Existing reactions
                      ...message.reactions.map((reaction) {
                        return GestureDetector(
                          onTap: () => onReactionTap?.call(reaction.emoji),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: reaction.userReacted
                                  ? AppColors.primary.withOpacity(0.2)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: reaction.userReacted
                                  ? Border.all(color: AppColors.primary.withOpacity(0.5))
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(reaction.emoji, style: const TextStyle(fontSize: 14)),
                                if (reaction.count > 1) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '${reaction.count}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: reaction.userReacted
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  // Reply count
                  if (message.replyCount > 0) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onViewReplies,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, size: 12, color: AppColors.primary),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${message.replyCount} ${message.replyCount == 1 ? 'Reply' : 'Replies'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reaction picker sheet
class _ReactionPicker extends StatelessWidget {
  final Function(String emoji) onReactionSelected;
  final VoidCallback onReply;

  const _ReactionPicker({
    required this.onReactionSelected,
    required this.onReply,
  });

  static const List<String> _emojis = [
    '❤️', '😊', '🔥', '💯', '😔', '🙌',
    '👌', '😍', '👏', '😁', '👨‍🍳', '👩‍🍳',
    '🤩', '⭐', '🍽️', '🏆', '🤯', '😂',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: _emojis.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onReactionSelected(_emojis[index]),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(_emojis[index], style: const TextStyle(fontSize: 28)),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          // Reply option
          ListTile(
            leading: const Icon(Icons.reply, color: AppColors.textPrimary),
            title: const Text('Reply'),
            onTap: onReply,
          ),
          // Report option
          ListTile(
            leading: const Icon(Icons.flag_outlined, color: Colors.red),
            title: const Text('Report', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement report
            },
          ),
        ],
      ),
    );
  }
}

// Replies sheet
class _RepliesSheet extends ConsumerStatefulWidget {
  final GroupMessage message;
  final String groupId;
  final ScrollController scrollController;

  const _RepliesSheet({
    required this.message,
    required this.groupId,
    required this.scrollController,
  });

  @override
  ConsumerState<_RepliesSheet> createState() => _RepliesSheetState();
}

class _RepliesSheetState extends ConsumerState<_RepliesSheet> {
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repliesAsync = ref.watch(
      messageRepliesProvider((groupId: widget.groupId, messageId: widget.message.id)),
    );

    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textTertiary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Thread',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Original message
        Padding(
          padding: const EdgeInsets.all(16),
          child: _MessageBubble(message: widget.message),
        ),
        const Divider(height: 1),
        // Replies
        Expanded(
          child: repliesAsync.when(
            data: (replies) => ListView.builder(
              controller: widget.scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: replies.length,
              itemBuilder: (context, index) {
                return _MessageBubble(message: replies[index]);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
        // Reply input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Reply...',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    final text = _replyController.text.trim();
                    if (text.isEmpty) return;

                    final sendMessage = ref.read(sendMessageProvider);
                    try {
                      await sendMessage(widget.groupId, text, replyToId: widget.message.id);
                      _replyController.clear();
                      ref.invalidate(messageRepliesProvider((
                        groupId: widget.groupId,
                        messageId: widget.message.id,
                      )));
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send reply: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardTab extends StatelessWidget {
  final List<GroupMember> leaderboard;

  const _LeaderboardTab({required this.leaderboard});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final member = leaderboard[index];
        return _LeaderboardItem(member: member);
      },
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final GroupMember member;

  const _LeaderboardItem({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 32,
            child: Text(
              '${member.rank}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),

          // User avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 24,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: 12),

          // Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '@${member.username.replaceAll(' ', '').toLowerCase()}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                size: 20,
                color: Color(0xFFFF6B35),
              ),
              const SizedBox(width: 4),
              Text(
                '${member.score}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

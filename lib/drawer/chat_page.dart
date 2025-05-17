import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  String _selectedChat = 'all'; // 'all' or specific user ID
  Map<String, dynamic>? _selectedUser;
  bool _isSupportChatOpen = false;
  bool _isUploading = false;

  // Mock data - Replace with actual data from WebSocket/Stream Chat
  final List<Map<String, dynamic>> _referrals = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@example.com',
      'status': 'active',
      'joinedDate': DateTime.now().subtract(const Duration(days: 5)),
      'earnings': 150.0,
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'status': 'pending',
      'joinedDate': DateTime.now().subtract(const Duration(days: 2)),
      'earnings': 0.0,
    },
  ];

  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'sender': 'User 1',
      'message': 'Hey, how are you?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isMe': false,
    },
    {
      'id': '2',
      'sender': 'Me',
      'message': 'I\'m good! How about you?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 4)),
      'isMe': true,
    },
    {
      'id': '3',
      'sender': 'User 1',
      'message': 'Great! Did you check out the new features?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
      'isMe': false,
    },
  ];

  // Add support chat messages
  final List<Map<String, dynamic>> _supportMessages = [
    {
      'id': '1',
      'sender': 'Support',
      'message': 'Welcome to InfiniPay Support! How can we help you today?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isMe': false,
      'type': 'text',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _uploadScreenshot() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1200,
      );

      if (image == null) return;

      setState(() {
        _isUploading = true;
      });

      // TODO: Implement actual image upload to your server
      // For now, we'll use the local file path
      final String imagePath = image.path;

      setState(() {
        _supportMessages.add({
          'id': DateTime.now().toString(),
          'sender': 'Me',
          'message': 'Screenshot uploaded',
          'timestamp': DateTime.now(),
          'isMe': true,
          'type': 'image',
          'imageUrl': imagePath, // In production, this should be the uploaded URL
        });
        _isUploading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final messageList = _selectedChat == 'support' ? _supportMessages : _messages;
    
    setState(() {
      messageList.add({
        'id': DateTime.now().toString(),
        'sender': 'Me',
        'message': _messageController.text,
        'timestamp': DateTime.now(),
        'isMe': true,
        'type': 'text',
      });
    });

    _messageController.clear();
    _scrollToBottom();
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

  void _selectUser(Map<String, dynamic> user) {
    setState(() {
      _selectedChat = user['id'];
      _selectedUser = user;
    });
  }

  void _goBack() {
    if (_selectedChat != 'all') {
      setState(() {
        _selectedChat = 'all';
        _selectedUser = null;
        _isSupportChatOpen = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _openSupportChat() {
    setState(() {
      _isSupportChatOpen = true;
      _selectedChat = 'support';
    });
  }

  void _closeSupportChat() {
    setState(() {
      _isSupportChatOpen = false;
      _selectedChat = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return WillPopScope(
      onWillPop: () async {
        if (_selectedChat != 'all') {
          setState(() {
            _selectedChat = 'all';
            _selectedUser = null;
            _isSupportChatOpen = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.primaryColor,
                child: _selectedChat == 'support'
                  ? const Icon(Icons.support_agent, color: Colors.white)
                  : _selectedUser != null
                    ? Text(
                        _selectedUser!['name'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedChat == 'support'
                      ? 'Support Chat'
                      : _selectedChat == 'all' 
                        ? 'All Referrals' 
                        : _selectedUser?['name'] ?? 'User',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _selectedChat == 'support'
                      ? 'Online'
                      : _selectedChat == 'all' 
                        ? '${_referrals.length} referrals' 
                        : _selectedUser?['status'] == 'active' 
                          ? 'Online' 
                          : 'Offline',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _selectedChat == 'support' || _selectedUser?['status'] == 'active' 
                        ? Colors.green 
                        : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            if (_selectedChat != 'all') ...[
              IconButton(
                icon: const Icon(Icons.video_call),
                onPressed: () {
                  // TODO: Implement video call
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // TODO: Show more options
                },
              ),
            ],
          ],
        ),
        body: _selectedChat == 'all' 
          ? _buildReferralsList(theme, isDarkMode)
          : _buildChatMessages(theme, isDarkMode),
        floatingActionButton: _selectedChat == 'all'
          ? FloatingActionButton(
              onPressed: _openSupportChat,
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.support_agent),
            ).animate()
              .scale(duration: const Duration(milliseconds: 300))
              .fadeIn()
          : null,
      ),
    );
  }

  Widget _buildReferralsList(ThemeData theme, bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _referrals.length,
      itemBuilder: (context, index) {
        final referral = _referrals[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            onTap: () => _selectUser(referral),
            leading: CircleAvatar(
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: Text(
                referral['name'][0].toUpperCase(),
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              referral['name'],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              referral['email'],
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: referral['status'] == 'active'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    referral['status'].toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: referral['status'] == 'active'
                        ? Colors.green
                        : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${referral['earnings'].toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ).animate()
          .fadeIn(delay: Duration(milliseconds: 100 * index))
          .slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildChatMessages(ThemeData theme, bool isDarkMode) {
    final messages = _selectedChat == 'support' ? _supportMessages : _messages;
    
    return Column(
      children: [
        // Chat Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildMessageBubble(message, theme, isDarkMode)
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 300))
                  .slideX(
                    begin: message['isMe'] ? 0.2 : -0.2,
                    end: 0,
                  );
            },
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (_selectedChat == 'support')
                IconButton(
                  icon: _isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.screenshot),
                  onPressed: _isUploading ? null : _uploadScreenshot,
                  tooltip: 'Upload Screenshot',
                ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  // TODO: Implement file attachment
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: _selectedChat == 'support' 
                      ? 'Describe your issue...'
                      : 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.primaryColor.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, ThemeData theme, bool isDarkMode) {
    final isMe = message['isMe'] as bool;
    final isImage = message['type'] == 'image';
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isMe 
            ? theme.primaryColor 
            : isDarkMode 
              ? Colors.grey[800]
              : theme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isImage)
              GestureDetector(
                onTap: () {
                  // Show full screen image
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        body: Center(
                          child: InteractiveViewer(
                            child: Image.file(
                              File(message['imageUrl'] as String),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(message['imageUrl'] as String)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            else
              Text(
                message['message'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isMe ? Colors.white : null,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message['timestamp'] as DateTime),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isMe ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 
import 'package:flutter/material.dart';

class ChatMessage {
  final String username;
  final String message;
  final String time;

  const ChatMessage({
    required this.username,
    required this.message,
    required this.time,
  });
}

class GroupChat extends StatefulWidget {
  const GroupChat({super.key});

  @override
  State<GroupChat> createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      username: 'Maria_fit',
      message: 'Всем привет! Как ваши тренировки?',
      time: '10:30',
    ),
    ChatMessage(
      username: 'John_doe',
      message: 'Только что закончил пробежку! 🏃‍♂️',
      time: '10:32',
    ),
    ChatMessage(
      username: 'Alex123',
      message: 'Молодец! Я сегодня тоже собираюсь',
      time: '10:35',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            username: 'FitnessGuru', // Placeholder current user
            message: _messageController.text,
            time: '${DateTime.now().hour}:${DateTime.now().minute}',
          ),
        );
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Групповой чат',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return _buildMessageItem(message);
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Написать сообщение...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 16,
            child: Text(
              message.username[0].toUpperCase(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      message.time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(message.message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
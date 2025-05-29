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
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  final List<ChatMessage> _messages = [
    ChatMessage(username: 'Alice', message: 'Привет, как дела?', time: '10:01'),
    ChatMessage(username: 'Bob', message: 'Всё отлично!', time: '10:02'),
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final now = TimeOfDay.now();
    final formatted = now.format(context);
    setState(() {
      _messages.add(ChatMessage(
        username: 'You',
        message: text,
        time: formatted,
      ));
    });
    _controller.clear();
    // optionally scroll to bottom
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Text(message.username[0]),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  message.username,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  message.time,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
              },
            ),
          ),
          const Divider(height: 1),
          // Input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Написать сообщение...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'chat_manager.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chats = ChatManager.chatsNotifier.value;
    final summary =
        chats.firstWhere((c) => c.id == widget.chatId, orElse: () => ChatSummary(id: widget.chatId, hotelName: 'Chat', contactName: ''));

    final messages = ChatManager.messagesFor(widget.chatId);

    return Scaffold(
      appBar: AppBar(
        title: Text(summary.hotelName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final alignment =
                    msg.isMe ? Alignment.centerRight : Alignment.centerLeft;
                final color =
                    msg.isMe ? const Color(0xFF1A75FF) : Colors.grey[200];
                final textColor = msg.isMe ? Colors.white : Colors.black87;
                return Align(
                  alignment: alignment,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF1A75FF),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    ChatManager.addMessage(
                      chatId: widget.chatId,
                      text: text,
                      isMe: true,
                    );
                    setState(() {
                      _controller.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



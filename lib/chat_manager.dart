import 'package:flutter/foundation.dart';

class ChatSummary {
  final String id;
  final String hotelName;
  final String contactName;
  final String? lastMessage;

  const ChatSummary({
    required this.id,
    required this.hotelName,
    required this.contactName,
    this.lastMessage,
  });

  ChatSummary copyWith({
    String? lastMessage,
  }) {
    return ChatSummary(
      id: id,
      hotelName: hotelName,
      contactName: contactName,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}

class ChatManager {
  ChatManager._();

  static final ValueNotifier<List<ChatSummary>> chatsNotifier =
      ValueNotifier<List<ChatSummary>>([]);

  static final Map<String, List<_ChatMessage>> _messages = {};

  static String ensureChat(String hotelName, String contactName) {
    final existing = chatsNotifier.value
        .firstWhere((c) => c.hotelName == hotelName, orElse: () => ChatSummary(id: '', hotelName: '', contactName: ''));
    if (existing.id.isNotEmpty) {
      return existing.id;
    }
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final summary = ChatSummary(
      id: id,
      hotelName: hotelName,
      contactName: contactName,
    );
    final current = List<ChatSummary>.from(chatsNotifier.value)..insert(0, summary);
    chatsNotifier.value = current;
    _messages[id] = [];
    return id;
  }

  static List<_ChatMessage> messagesFor(String chatId) {
    return _messages[chatId] ?? <_ChatMessage>[];
  }

  static void addMessage({
    required String chatId,
    required String text,
    required bool isMe,
  }) {
    final msgs = List<_ChatMessage>.from(_messages[chatId] ?? []);
    msgs.add(_ChatMessage(
      text: text,
      isMe: isMe,
      time: DateTime.now(),
    ));
    _messages[chatId] = msgs;

    final current = List<ChatSummary>.from(chatsNotifier.value);
    final index = current.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      final updated = current[index].copyWith(lastMessage: text);
      current
        ..removeAt(index)
        ..insert(0, updated);
      chatsNotifier.value = current;
    }
  }
}

class _ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}



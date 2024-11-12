import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String botToken = 'YOUR_BOT_TOKEN';
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  Future<void> fetchMessages() async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/getUpdates');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> updates = jsonDecode(response.body)['result'];
      final List<ChatMessage> loadedMessages = updates
          .where((update) =>
              update['message']['chat']['id'].toString() == widget.chatId)
          .map((update) => ChatMessage.fromJson(update['message']))
          .toList();

      setState(() {
        _messages.clear();
        _messages.addAll(loadedMessages);
      });
    } else {
      print('Failed to fetch messages');
    }
  }

  Future<void> sendMessage(String messageText) async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chat_id': widget.chatId, 'text': messageText}),
      );

      if (response.statusCode == 200) {
        _messageController.clear();
        fetchMessages();
      } else {
        print('Failed to send message');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ID: ${widget.chatId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.sender),
                  subtitle: Text(message.text),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final messageText = _messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      sendMessage(messageText);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: fetchMessages,
      ),
    );
  }
}

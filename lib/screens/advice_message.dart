import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdviceMessage extends StatefulWidget {
  @override
  _AdviceMessageState createState() => _AdviceMessageState();
}

class _AdviceMessageState extends State<AdviceMessage> {
  final TextEditingController _controller = TextEditingController();

  final String chatId = dotenv.env['CHAT_ID'].toString();
  final String channelId = dotenv.env['CHANNEL_ID'].toString();
  final String botToken = dotenv.env['BOT_TOKEN'].toString();

  Future<void> sendMessage(String message) async {
    final url = Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': chatId,
          'text': message,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message sent!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Advice to Telegram Bot'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your advice',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final message = _controller.text.trim();
                if (message.isNotEmpty) {
                  sendMessage(message);
                  _controller.clear();
                }
              },
              child: Text('Send Advice'),
            ),
          ],
        ),
      ),
    );
  }
}

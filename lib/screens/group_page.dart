import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../screens/page_menu.dart';

class TopicsPage extends StatefulWidget {
  final String chatId;

  const TopicsPage({Key? key, required this.chatId}) : super(key: key);

  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  final String botDomain = dotenv.env['BOT_DOMAIN'].toString();
  List<Map<String, dynamic>> _topics = [];

  Future<void> fetchTopics() async {
    final url = Uri.parse('$botDomain/getUpdates');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> updates = jsonDecode(response.body)['result'];

      // Extract distinct topics or threads from the updates
      final List<Map<String, dynamic>> loadedTopics = updates
          .where((update) =>
              update['message']['chat']['id'].toString() == widget.chatId)
          .map((update) => {
                'id': update['message']['message_id'].toString(),
                'title': update['message']['text'] ?? 'No Title',
              })
          .toList();

      setState(() {
        _topics = loadedTopics;
      });
    } else {
      print('Failed to fetch topics');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics in Chat ${widget.chatId}'),
      ),
      drawer: PageMenu(), // Use the PageMenu here
      body: _topics.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final topic = _topics[index];
                return ListTile(
                  title: Text(topic['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatId: topic['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

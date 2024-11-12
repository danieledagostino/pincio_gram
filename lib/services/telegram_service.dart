import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TelegramService {
  Future<List<String>> getGroupTopics(String groupId) async {
    try {
      var response = await http.get(
        Uri.parse('https://api.telegram.org/botc/getUpdates'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<String> topics = [];

        for (var update in jsonResponse['result']) {
          if (update['message'] != null &&
              update['message']['chat']['id'].toString() == groupId) {
            topics.add(update['message']['text']);
          }
        }

        return topics;
      } else {
        throw Exception('Failed to load topics');
      }
    } catch (e) {
      throw Exception('Error retrieving topics: $e');
    }
  }
}

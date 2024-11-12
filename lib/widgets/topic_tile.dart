import 'package:flutter/material.dart';
import '../models/topic.dart';
import 'notification_switch.dart';

class TopicTile extends StatelessWidget {
  final Topic topic;
  final Function(bool) onToggleVisibility;
  final Function(bool) onToggleNotifications;
  final Function(String) onSendMessage;

  TopicTile({
    required this.topic,
    required this.onToggleVisibility,
    required this.onToggleNotifications,
    required this.onSendMessage,
  });

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(topic.title, style: TextStyle(decoration: topic.isVisible ? null : TextDecoration.lineThrough)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NotificationSwitch(
            value: topic.notificationsEnabled,
            onChanged: onToggleNotifications,
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Send Message to ${topic.title}'),
                    content: TextField(
                      controller: messageController,
                      decoration: InputDecoration(hintText: 'Enter message'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          onSendMessage(messageController.text);
                          messageController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text('Send'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      onTap: () => onToggleVisibility(!topic.isVisible),
    );
  }
}

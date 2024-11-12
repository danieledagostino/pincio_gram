class ChatMessage {
  final String sender;
  final String text;

  ChatMessage({required this.sender, required this.text});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['from']['first_name'] ?? 'Unknown',
      text: json['text'] ?? '',
    );
  }
}

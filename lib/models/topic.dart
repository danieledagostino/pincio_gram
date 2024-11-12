class Topic {
  final String id;
  final String title;
  bool isVisible;
  bool notificationsEnabled;

  Topic({
    required this.id,
    required this.title,
    this.isVisible = true,
    this.notificationsEnabled = true,
  });
}

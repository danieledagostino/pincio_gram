import 'package:flutter/material.dart';

class NotificationSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  NotificationSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
    );
  }
}

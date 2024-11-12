import 'package:flutter/material.dart';
import 'package:flutter_telegram_login/flutter_telegram_login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/telegram_client.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  final botId = dotenv.env['BOT_TOKEN'].toString();
  final botDomain = dotenv.env['BOT_DOMAIN'].toString();

  @override
  void initState() {
    super.initState();
    TelegramClient.initializeClient();
  }

  void _sendPhoneNumber() async {
    await TelegramClient.setPhoneNumber(_phoneController.text);
  }

  void _verifyCode() async {
    await TelegramClient.checkCode(_codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login to Telegram")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            ElevatedButton(
              onPressed: _sendPhoneNumber,
              child: Text("Send Phone Number"),
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: "Verification Code"),
            ),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text("Verify Code"),
            ),
          ],
        ),
      ),
    );
  }
}

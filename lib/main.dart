import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/group_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/settings_page.dart';

import 'package:tdlib/td_api.dart' as tdApi;
import 'package:tdlib/tdlib.dart';
import 'dart:io';

Future main() async {
  await dotenv.load(fileName: ".env"); // Load .env file
  HttpOverrides.global = MyHttpOverrides();
  final tdlibPath = (Platform.isAndroid || Platform.isLinux || Platform.isWindows) ? 'libtdjson.so' : null;
  await TdPlugin.initialize(tdlibPath);
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Telegram Topics',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) =>
              TopicsPage(chatId: dotenv.env['CHAT_ID'].toString()),
          '/settings': (context) => SettingsPage(),
        });
  }
}

import 'package:flutter/services.dart';

class TelegramClient {
  static const MethodChannel _channel = MethodChannel('telegram_client');

  static Future<void> initializeClient() async {
    await _channel.invokeMethod('initializeClient');
  }

  static Future<void> setPhoneNumber(String phoneNumber) async {
    await _channel.invokeMethod('setPhoneNumber', {"phoneNumber": phoneNumber});
  }

  static Future<void> checkCode(String code) async {
    await _channel.invokeMethod('checkCode', {"code": code});
  }
}

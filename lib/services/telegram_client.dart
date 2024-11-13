import 'package:tdlib/tdlib.dart';

class TelegramClient {
  late final TdLib _tdLib;

  TelegramClient() {
    // Initialize TDLib
    _tdLib = TdLib();
    _tdLib.tdSend({'@type': 'getAuthorizationState'});

    // Listen for updates
    _tdLib.eventsStream.listen((event) {
      print('Received event: $event');
      _handleUpdate(event);
    });
  }

  // Example function to authenticate with Telegram
  void authenticate(String phoneNumber) {
    _tdLib.tdSend({
      '@type': 'setAuthenticationPhoneNumber',
      'phone_number': phoneNumber,
    });
  }

  // Handle incoming updates from TDLib
  void _handleUpdate(Map<String, dynamic> update) {
    final type = update['@type'];

    if (type == 'updateAuthorizationState') {
      final authState = update['authorization_state']['@type'];
      if (authState == 'authorizationStateWaitCode') {
        print('Waiting for the authentication code...');
        // Handle the code input by the user
      } else if (authState == 'authorizationStateReady') {
        print('Authorization complete!');
      }
    }
  }
}

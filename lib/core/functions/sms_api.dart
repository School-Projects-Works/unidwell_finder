import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class SmsApi {
  static const String baseUrl = 'https://sms.arkesel.com/sms/api?action=send-sms&api_key=SmtPRE5HZk11Q3lKdHNGamJFRnE&to=PhoneNumber&from=SenderID&sms=YourMessage';
  static const String apiKey = '';

  Future<bool> sendMessage(String phoneNumber, String message) async {
    try {
      final response = await http.get(Uri.parse(baseUrl
          .replaceFirst('PhoneNumber', phoneNumber)
          .replaceFirst('SenderID', 'Acc.Finder')
          .replaceFirst('YourMessage', message)));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

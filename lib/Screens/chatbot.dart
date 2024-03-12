import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class ChatService {
  static void startConversation() {
    dynamic conversationObject = {
      'appId': '30d7ce92d71360c2f91bf97860321afd6', // The APP_ID obtained from the Kommunicate dashboard.
    };

    KommunicateFlutterPlugin.buildConversation(conversationObject)
        .then((clientConversationId) {
      print("Conversation builder success : " + clientConversationId.toString());
    }).catchError((error) {
      print("Conversation builder error : " + error.toString());
    });
  }
}
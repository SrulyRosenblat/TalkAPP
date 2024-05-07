import 'dart:typed_data';

import 'package:http/http.dart';

Future<Uint8List> download_mp3(String url) async {
  Response response = await get(Uri.parse(url));
  return response.bodyBytes;
}

String getTranslatedPart(String text) {
  List<String> humanSplit = text.split("Human:");
  List<String> aiSplit = text.split("AI:");
  if (humanSplit.last.length < aiSplit.last.length) {
    return humanSplit.last.trim();
  } else {
    return aiSplit.last.trim();
  }
}

String build_Conversation_String(List messages, List roles, String text) {
  String result = '';
  for (int i = 0; i < messages.length; i++) {
    result += '${roles[i] == "assistant" ? "AI" : "Human"}: ${messages[i]}\n';
  }
  result += 'Human: $text';
  return result;
}

List<Map<String, String>> convert_to_openai_format(List messages, List roles) {
  List<Map<String, String>> result = [];
  for (int i = 0; i < messages.length; i++) {
    result.add({'role': roles[i], 'content': messages[i]});
  }
  return result;
}

dynamic encoderForDateTime(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  }
  return item;
}

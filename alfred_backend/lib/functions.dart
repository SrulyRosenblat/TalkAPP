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

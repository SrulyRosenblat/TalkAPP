import 'dart:convert';
import 'dart:io';

import 'package:alfred_backend/enviroment.dart';
import 'package:alfred_backend/gcp_storage.dart';
import 'package:http/http.dart' as http;

class openai {
  static final api_key = env['openai'] ?? '';
  static text_to_speech({text, voice = "alloy"}) async {
    print(api_key);
    var headers = {
      'Authorization': "Bearer " + api_key,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.openai.com/v1/audio/speech'));
    request.body =
        json.encode({"model": "tts-1", "input": text, "voice": voice});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // make so that writes to mp3 file
      var filePath = 'output-test534.mp3'; // Replace with desired file path
      var storage = GCP_Storage();
      await storage.init();
      await storage.depositInBucket(response.stream, filePath);
      print('uplouded to fp');
    } else {
      print(response.reasonPhrase);
    }
  }

  static speech_to_text(audio) async {
    //TODO
  }
  static chat(messages) async {
    //TODO
  }
  static translate(text, from_language, to_language) async {
    //TODO
  }
}

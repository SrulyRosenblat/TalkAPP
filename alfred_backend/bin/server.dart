import 'dart:convert';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:alfred_backend/gcp_storage.dart';
import 'package:alfred_backend/db.dart';
import 'package:alfred_backend/openai.dart';
import 'package:alfred_backend/uuid.dart';

class Server {
  final app = Alfred();
  final db = DB();
  final storage = GCP_Storage();

  Future start() async {
    await db.init();
    await storage.init();

    app.get('hello_world/', (HttpRequest req, HttpResponse res) {
      final length = req.headers.contentLength;
      return {'len': length, 'connected': db.isConnected()};
    });

    app.get('chat/', (HttpRequest req, HttpResponse res) async {
      print((await db.execute("select * from chat;"))[0][0]);
      return {'connected': db.isConnected()};
    });

    app.post('talk/', (HttpRequest req, HttpResponse res) async {
      final body = await req.bodyAsJsonMap;
      String? text = body['text'];
      if (text == null) throw Exception('expected a "text" in body');
      String path = await openai.text_to_speech(text: text);
      return {
        'connected': db.isConnected(),
        'filePath': 'https://storage.cloud.google.com/talkapp/' + path
      };
    });

    app.post('transcribe/', (HttpRequest req, HttpResponse res) async {
      final body = await req.bodyAsJsonMap;
      String? url = body['url'];
      if (url == null) throw Exception('expected a "url" in body');
      // String path = await openai.text_to_speech(text: text);
      return {
        'connected': db.isConnected(),
        'transcription': await openai.speech_to_text(url)
      };
    });
    app.post('translate/', (HttpRequest req, HttpResponse res) async {
      final body = await req.bodyAsJsonMap;

      String? conversation = body['conversation'];
      if (conversation == null)
        throw Exception('expected a "conversation" in body');
      String? from_language = body['from_language'];
      if (from_language == null)
        throw Exception('expected a "from_language" in body');
      String? to_language = body['to_language'];
      if (to_language == null)
        throw Exception('expected a "to_language" in body');
      return {
        "translation":
            await openai.translate(conversation, from_language, to_language)
      };
    });
    app.post('/upload', (req, res) async {
      final body = await req.bodyAsJsonMap;
      final file = (body['file'] as HttpBodyFileUpload);
      List<int> content = file.content;
      String path = id_generator.v4() + '.mp3';

      Stream<List<int>> stream = Stream.fromIterable([content]);
      await storage.depositInBucket(stream, path);
      return {
        'connected': db.isConnected(),
        'filePath': 'https://storage.cloud.google.com/talkapp/' + path
      };
    });
    app.all('getChat/:id/', (HttpRequest req, HttpResponse res) async {
      String id = req.params['id'];

      return await db.getMessages(id);
    });

    await app.listen();
  }
}

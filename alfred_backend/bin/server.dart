import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:alfred_backend/gcp_storage.dart';
import 'package:alfred_backend/db.dart';
import 'package:alfred_backend/openai.dart';

class Server {
  final app = Alfred();
  final db = DB();

  Future start() async {
    await db.init();

    app.get('hello_world/', (HttpRequest req, HttpResponse res) {
      final length = req.headers.contentLength;
      return {'len': length, 'connected': db.isConnected()};
    });
    app.get('chat/', (HttpRequest req, HttpResponse res) async {
      print((await db.execute("select * from chat;"))[0][0]);
      return {'connected': db.isConnected()};
    });
    app.get('talk/', (HttpRequest req, HttpResponse res) async {
      await openai.text_to_speech(text: "what is me");
      return {'connected': db.isConnected()};
    });
    app.get('test/', (HttpRequest req, HttpResponse res) async {
      print('starting');
      test_storage();
    });
    await app.listen();
  }
}

import 'dart:convert';

import 'package:alfred/alfred.dart';
import 'package:alfred_backend/functions.dart';
import 'package:alfred_backend/gcp_storage.dart';
import 'package:alfred_backend/db.dart';
import 'package:alfred_backend/openai.dart';
import 'package:alfred_backend/uuid.dart';

class Server {
  final app = Alfred();
  final db = DB();
  final storage = GCP_Storage();

  Future start(int port) async {
    await db.init();
    await storage.init();

    app.all('/', (req, res) => 'congrats it works 🎉🎉🎉');

    app.post('/upload', (req, res) async {
      final body = await req.bodyAsJsonMap;
      final file = (body['file'] as HttpBodyFileUpload);
      List<int> content = file.content;
      String path = id_generator.v4() + '.mp3';

      Stream<List<int>> stream = Stream.fromIterable([content]);
      await storage.depositInBucket(stream, path);
      return 'https://storage.googleapis.com/talkapp/' + path;
    });

    app.all('getChat/:id/', (HttpRequest req, HttpResponse res) async {
      String id = req.params['id'];

      return await db.get_chat_messages(id);
    });

    app.all('getUserChats/:userID/', (HttpRequest req, HttpResponse res) async {
      String id = req.params['userID'];
//https://stackoverflow.com/questions/21813942/how-to-convert-datetime-object-to-json
      List<dynamic> chats = await db.get_user_chats(id);
      List<int> chatIDs = [];
      List<String> nativeLanguages = [];
      List<String> forignLanguages = [];
      List<String> chatNames = [];
      for (var chat in chats) {
        chatIDs.add(chat[0]);
        nativeLanguages.add(chat[2]);
        forignLanguages.add(chat[3]);
        chatNames.add(chat[4]);
      }
      return jsonEncode({
        // 'chatIDs': chatIDs,
        'chatNames': chatNames.map((e) => e.trim()).toList(),
        'nativeLanguages': nativeLanguages.map((e) => e.trim()).toList(),
        'forignLanguages': forignLanguages.map((e) => e.trim()).toList(),
      });
    });
    app.all('getUserFavorites/:userID/',
        (HttpRequest req, HttpResponse res) async {
      String id = req.params['userID'];
      List<dynamic> messages = await db.get_user_favorites(id);
      List<String> originalTexts = [];
      List<String?> translatedTexts = [];
      List<String> roles = [];
      List<String?> sounds = [];

      for (final m in messages) {
        translatedTexts.add(m[3]?.trim());
        originalTexts.add(m[4].trim());

        sounds.add(m[5]?.trim());
        roles.add(m[6] ? "assistant" : "user");
      }

      return {
        "originalTexts": originalTexts,
        "translatedTexts": translatedTexts,
        "sounds": sounds,
        "roles": roles,
      };
    });
    app.post('createUser/', (req, res) async {
      final body = await req.bodyAsJsonMap;
      String userID = body['userID'];
      String nativeLanguage = body['nativeLanguage'];

      return db.add_user(userID, nativeLanguage);
    });

    app.post('createChat/', (req, res) async {
      final body = await req.bodyAsJsonMap;
      String userID = body['userID'];
      String foreignLang = body['foreignLang'];
      String chatName = body['chatName'];
      try {
        List<dynamic> user = await db.get_user(userID)!;
        String native = user[2];
        return db.add_chat(native, foreignLang, userID, chatName);
      } catch (identifier) {
        throw Exception("user doesn't exist");
      }
    });
    // app.all('getChatInfo/:id/', (HttpRequest req, HttpResponse res) async {
    //   String id = req.params['id'];

    //   return (await db.get_chat_info(id)).toString();
    // });

    app.post('send_message/:id/', (HttpRequest req, HttpResponse res) async {
      // call this api to send message
      //  pass in a audio_url in the body
      // both computes the extra fields and gets the chatbots answer uploads both to db.
      final body = await req.bodyAsJsonMap;

      String chatID = req.params['id'];

      List chat_info = await db.get_chat_info(chatID);
      String userID = chat_info[1];
      String native = chat_info[2];
      String foreign = chat_info[3];

      String? audio = body['audio_url'];

      if (audio == null) throw Exception('expected a "audio_url" in body');

      String messegeText = await openai.speech_to_text(audio);

      Map<String, List<dynamic>> chat = await db.get_chat_messages(chatID);
      List texts = chat['originalTexts']!;
      List roles = chat['roles']!;
      String conversationString =
          build_Conversation_String(texts, roles, messegeText);

      //  translate text
      String translatedText =
          await openai.translate(conversationString, native);

      // print("messeges");
      // print(chat);

      // print('messegeText');
      // print(messegeText);

      // print('audio');
      // print(audio);

      // print('chat info');
      // print(chat_info);

      // print('conversation string');
      // print(conversationString);

      await db.add_message(chatID, userID, messegeText, translatedText,
          sound: audio, ai: false);

      List messages_in_correct_format = convert_to_openai_format(texts, roles);
      String response =
          await openai.chat(messages_in_correct_format, foreign, messegeText);
      String translatedResponse = await openai.translate(response, native);
      String responseAudio = await openai.text_to_speech(text: response);
      return db.add_message(chatID, userID, translatedResponse, response,
          sound: 'https://storage.googleapis.com/talkapp/' + responseAudio,
          ai: true);
    });

    await app.listen(port = port);
  }
}

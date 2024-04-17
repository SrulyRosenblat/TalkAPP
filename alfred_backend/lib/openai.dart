import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfred_backend/enviroment.dart';
import 'package:alfred_backend/functions.dart';
import 'package:alfred_backend/gcp_storage.dart';
import 'package:alfred_backend/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class openai {
  static final api_key = env['openai'] ?? '';

  static Future<String> text_to_speech({text, voice = "alloy"}) async {
    var filePath = id_generator.v4() + '.mp3';
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
      var storage = GCP_Storage();
      await storage.init();
      await storage.depositInBucket(response.stream, filePath);

      return filePath;
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<String> speech_to_text(String url) async {
    Uint8List sound = await download_mp3(url);
    var headers = {'Authorization': 'Bearer ' + api_key};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.openai.com/v1/audio/transcriptions'));
    request.fields.addAll({'model': 'whisper-1'});

    request.files.add(await http.MultipartFile.fromBytes('file', sound,
        filename: 'output-test.mp3'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString())['text'];
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<String> chat(
      List messages, String language, String text) async {
    //TODO
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $api_key'
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.openai.com/v1/chat/completions'));
    messages.insert(0, {
      "role": "system",
      "content":
          "You are a language model that is built to teach the user $language. \n\nIn order to accomplish this you answer every question and explain everything in $language, no matter what language the user speaks in."
    });
    messages.add({"content": text, "role": "user"});
    request.body = json.encode({
      "model": "gpt-3.5-turbo",
      "messages": messages,
      "temperature": 1,
      "max_tokens": 1000,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final res = (await response.stream.bytesToString());

      Map<String, dynamic> data = json.decode(res);

      String text = data['choices'][0]['message']['content'];
      return text;
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<String> translate(String text, String to_language) async {
    Map<String, String> message = {
      "to_language": to_language,
      "conversation": text
    };

    //TODO
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + openai.api_key,
      'Cookie':
          '__cf_bm=k.FP1lg7LTJUJSdtWcT2PQU8.bmMD49i59ZKKN9uOEw-1713068805-1.0.1.1-vh7UnRw.foSDM8RpQvsFjt0L8XJypkhL.uS2RqrDKZmwjOOhSGdeDvr05d2zqLIgvccQ1z0mnC4yCYYZKJCDxw; _cfuvid=Yg.YRrwhQfVfvF61hG4Hx7m.2BGz0LWYO5n3YGflr70-1712954806411-0.0.1.1-604800000'
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.openai.com/v1/chat/completions'));
    request.body = json.encode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a translation machine given a conversation as context a input language and a target language you translate accurately.  You never ask for clarification just translate, you are not a chatbot just a translator."
        },
        {
          "role": "user",
          "content":
              "{\n    \"to_language\" : \"english\",\n    \"conversation\":\"AI: שלום, איך אני יכול לעזור לך היום?\\n\\nHuman: שלום, אני מחפש מידע על תחום האינטליגנציה המלאכותית. יש לך מושג על זה?\\n\\nAI: כן, אני מבין ממש טוב את התחום הזה. האינטליגנציה המלאכותית היא תחום שמבוסס על פיתוח תוכניות ואלגוריתמים שמאפשרים למערכות ממוחשבות לבצע פעולות שדרשו עד כה אנ\"\n}"
        },
        {
          "role": "assistant",
          "content":
              "Yes, I understand this field very well. Artificial intelligence is a field based on the development of programs and algorithms that enable computer systems to perform tasks that previously required human intelligence."
        },
        {
          "role": "user",
          "content":
              "{\n    \"to_language\":\"English\",\n    \"Conversation\" :\"AI: Добрий день! Чим можу допомогти?\\n\\nHuman: Привіт! Я хочу замовити піцу. Які у вас є види і скільки часу потрібно на доставку?\\n\\nAI: У нас є багато різних видів піци - від класичних до авторських страв. Час доставки зазвичай становить близько 30-45 хвилин, в залежності від вашого місцезнаходження.\\n\\nHuman: Дуже цікаво! Якщо я хочу замовити піцу з тунцем і ананасами, це можливо?\\n\\nAI: Звичайно! Ми готуємо піцу на замовлення, тому будь-які поєднання і\"\n    }"
        },
        {
          "role": "assistant",
          "content":
              "Of course! We prepare pizzas to order, so any combination is possible."
        },
        {
          "role": "user",
          "content":
              "{\n\"to_language\":\"English\",\n\"Conversation\" :\"Human: Hola, estoy interesado en aprender más sobre los leopardos. ¿Puedes darme información sobre ellos?\\n\\nAI: ¡Claro! Los leopardos son felinos majestuosos que se encuentran principalmente en África y algunas partes de Asia. Son conocidos por su agilidad y velocidad, así como por sus impresionantes habilidades de caza. ¿Hay algo en particular que te interese saber sobre los leopardos?\"\n}"
        },
        {
          "role": "assistant",
          "content":
              "Yes, of course! Leopards are majestic felines found mainly in Africa and some parts of Asia. They are known for their agility and speed, as well as their impressive hunting skills. Is there anything specific you would like to know about leopards?"
        },
        {
          "role": "user",
          "content":
              "{\n    \"to_language\" : \"English\",\n    \"conversation\":\"AI: שלום, איך אני יכול לעזור לך היום? \\n\\nHuman: שלום, רוצה לדעת איך אפשר לדבר בעברית יותר טוב. \\n\\nAI: כמובן! אני כאן כדי לעזור לך לשפר את כישורי העברית שלך.\\n\\nHuman: Thank you! Can you teach me some basic phrases in Hebrew?\\n\\nAI: כן, איך אתה אומר '\''thank you'\'' בעברית?\"\n}"
        },
        {
          "role": "assistant",
          "content": "Yes, how do you say \"thank you\" in Hebrew?"
        },
        {"role": "user", "content": message.toString()}
      ],
      "temperature": 0,
      "max_tokens": 1000,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final res = (await response.stream.bytesToString());

      Map<String, dynamic> data = json.decode(res);

      String text = data['choices'][0]['message']['content'];

      return getTranslatedPart(text);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}

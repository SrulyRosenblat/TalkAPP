import 'dart:ffi';

import 'package:alfred_backend/enviroment.dart';
import 'package:gcloud/pubsub.dart';
import 'package:postgres/postgres.dart';

class DB {
  Connection? conn = null;
  Future init() async {
    print('connecting..');
    conn = await Connection.open(Endpoint(
      host: '34.170.66.40',
      database: 'beta1',
      username: 'postgres',
      password: env['postgres'],
    ));
    print('connected');
  }

  execute(String query) async {
    return await conn!.execute(query);
  }

  add_user(userID, nativeLanguage) async {
    if (await get_user(userID) != null) {
      throw Exception("user already exists");
    }
    return (await conn!.execute(
            '''INSERT INTO AppUser (UserID, NativeLanguage) VALUES ('$userID', '$nativeLanguage') RETURNING UserID;'''))[
        0][0];
  }

  add_chat(nativeLang, foreignLang, userID, name) async {
    return (await conn!.execute('''
      INSERT INTO Chat (NativeLang, ForeignLang, UserID, Name)
      VALUES
      ('$nativeLang', '$foreignLang', '$userID', '$name') RETURNING ChatID;
    '''))[0][0];
  }

  add_message(chatID, userID, textNative, textForeign,
      {sound = null, ai = true, favorite = false}) async {
    if (sound != null) {
      return (await conn!.execute(r'''
      INSERT INTO AudioMessage (ChatID, UserID, TextNative, TextForeign, Sound, AI,favorite)
      VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING MessageID;
      ''', parameters: [
        chatID,
        userID,
        textNative,
        textForeign,
        sound,
        ai,
        favorite
      ]))[0][0];
    } else {
      return (await conn!.execute(r'''
      INSERT INTO AudioMessage (ChatID, UserID, TextNative, TextForeign, AI,favorite)
      VALUES ($1, $2, $3, $4, $5, $6) RETURNING MessageID;
      ''', parameters: [
        chatID,
        userID,
        textNative,
        textForeign,
        ai,
        favorite
      ]))[0][0];
    }
  }

  Future<Map<String, List<dynamic>>> get_chat_messages(chatID) async {
    List messages = await conn!.execute('''
      SELECT * FROM AudioMessage Where ChatID ='$chatID'
      ORDER BY CreatedAt ASC;
      ''');
    List<String> originalTexts = [];
    List<String?> translatedTexts = [];
    List<String> roles = [];
    List<String?> sounds = [];
    List<bool> favorites = [];

    for (final m in messages) {
      translatedTexts.add(m[3]?.trim());
      originalTexts.add(m[4].trim());

      sounds.add(m[5]?.trim());
      roles.add(m[6] ? "assistant" : "user");
      favorites.add(m[7]);
    }

    return {
      "originalTexts": originalTexts,
      "translatedTexts": translatedTexts,
      "sounds": sounds,
      "roles": roles,
      "favorited": favorites
    };
  }

  Future<List<Map<String, dynamic>>> get_user_favorites(String userID) async {
    return await execute('''
      SELECT * FROM AudioMessage WHERE UserID = $userID AND Favorite = TRUE;
  ''');
  }

  dynamic get_user(userID) async {
    List result =
        await execute("SELECT * FROM AppUser WHERE UserID = '$userID';");
    return result.firstOrNull;
  }

  Future<List<dynamic>> get_message(messageID) async {
    List result = await execute(
        "SELECT * FROM AudioMessage WHERE MessageID = '$messageID';");
    return result.firstOrNull;
  }

  Future<List<dynamic>> get_chat_info(chatID) async {
    List result = await execute("SELECT * FROM Chat WHERE ChatID = '$chatID';");

    return result.firstOrNull;
  }

  favorite_message(messageID) async {
    return await execute(
        'UPDATE AudioMessage SET Favorite = TRUE WHERE MessageID = $messageID;');
  }

  bool isConnected() {
    return conn != null;
  }

  close() async {
    await conn?.close();
    conn = null;
  }
}

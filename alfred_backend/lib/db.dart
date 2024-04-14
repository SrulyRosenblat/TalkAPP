import 'package:alfred_backend/enviroment.dart';
import 'package:postgres/postgres.dart';

class DB {
  Connection? conn = null;
  Future init() async {
    print('connecting..');
    conn = await Connection.open(Endpoint(
      host: '34.170.66.40',
      database: 'simulated2',
      username: 'postgres',
      password: env['postgres'],
    ));
    print('connected');
  }

  execute(query) async {
    // fix
    return await conn!.execute(query);
  }

  add_user(userID, name) async {
    return await execute(
        '''INSERT INTO "User" (UserID, Name, CreatedAt) VALUES ('$userID', '$name', CURRENT_TIMESTAMP);''');
  }

  add_chat(chatID, script, nativeLang, foreignLang, userID, name) async {
    return execute('''
INSERT INTO Chat (ChatID, Script, NativeLang, ForeignLang, UserID, Name)
VALUES
('$chatID', '$script', '$nativeLang', '$foreignLang', '$userID', '$name');
''');
  }

  add_message(messageID, chatID, textNative, textForeign, sound, ai) async {
    return execute('''
INSERT INTO Message (MessageID, ChatID, CreatedAt, TextNative, TextForeign, Sound, AI)
VALUES
('$messageID', '$chatID', CURRENT_TIMESTAMP, '$textNative', '$textForeign', '$sound', $ai);
''');
  }

  getMessages(chatID) async {
    final messages = await execute('''
SELECT * FROM Message Where ChatID ='$chatID'
ORDER BY CreatedAt ASC;
''');
    List<String> originalTexts = [];
    List<String> translatedTexts = [];
    List<String> roles = [];
    List<String> sounds = [];

    for (final m in messages) {
      originalTexts.add(m[3].trim());
      translatedTexts.add(m[4].trim());
      sounds.add(m[5].trim());
      roles.add(m[6] ? "assistant" : "user");
    }

    return {
      "originalTexts": originalTexts,
      "translatedTexts": translatedTexts,
      "sounds": sounds,
      "roles": roles
    };
  }

  bool isConnected() {
    return conn != null;
  }

  close() async {
    await conn?.close();
    conn = null;
  }
}

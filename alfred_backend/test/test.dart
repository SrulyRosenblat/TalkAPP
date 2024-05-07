import 'dart:convert';

import 'package:http/http.dart' as http;

const URL = 'https://backend-for-talk-app-wq6p35r7jq-uc.a.run.app';

///============================================================
/// functions to use directly
///============================================================
Future<int> createChat(
    // create a new chat for a certain user
    String userID,
    String foreignLanguage,
    String? chatName) async {
  var headers = {'Content-Type': 'application/json'};
  var uri = Uri.parse('$URL/createChat');
  var request = http.Request('POST', uri);
  request.body = json.encode({
    "userID": userID,
    "foreignLang": foreignLanguage,
    "chatName": chatName ?? 'untitled $foreignLanguage chat'
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    int chatID = (await response.stream.bytesToString()) as int;
    return chatID;
  } else {
    print(response.reasonPhrase);
    throw Exception(response.reasonPhrase);
  }
}

Stream<Future<Map<String, dynamic>>> chatStream(int chatID) {
  // subscribe to a chats updates
  return Stream.periodic(const Duration(milliseconds: 500)).map((_) async {
    return await getChat(chatID);
  });
}

Stream<Future<Map<String, dynamic>>> chatListStream(String userID) {
  // subscribe to a list of the users chats
  return Stream.periodic(const Duration(milliseconds: 500)).map((_) async {
    return await getChatList(userID);
  });
}

Stream<Future<Map<String, dynamic>>> favoriteStream(String userID) {
  // subscribe to a chats updates
  return Stream.periodic(const Duration(milliseconds: 500)).map((_) async {
    return await getFavorites(userID);
  });
}

Future<int> sendMessage(int chatID, String filePath) async {
  // pass in a chatID and a file path to audio  to send a message in that chat
  String url = await uploadSound(filePath);
  print(url);
  return processMessage(chatID, url);
}

///============================================================
/// functions used in other functions
///============================================================

Future<Map<String, dynamic>> getChat(int chatID) async {
  // get the content of a specific chat
  var request = http.Request('GET', Uri.parse('$URL/getChat/$chatID/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> res =
        json.decode(await response.stream.bytesToString());
    return res;
  } else {
    print(response.reasonPhrase);
    throw Exception(response.reasonPhrase);
  }
}

Future<Map<String, dynamic>> getChatList(String userID) async {
  // get the content of a specific chat
  var request = http.Request('GET', Uri.parse('$URL/getUserChats/$userID/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> res =
        json.decode(await response.stream.bytesToString());
    return res;
  } else {
    print(response.reasonPhrase);
    throw Exception(response.reasonPhrase);
  }
}

Future<Map<String, dynamic>> getFavorites(String userID) async {
  var request =
      http.Request('GET', Uri.parse('$URL/getUserFavorites/$userID/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> res =
        json.decode(await response.stream.bytesToString());
    return res;
  } else {
    print(response.reasonPhrase);
    throw Exception(response.reasonPhrase);
  }
}

Future<int> processMessage(int chatID, String audioURL) async {
  // actually put the uplouded message in db allong with ai stuff
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse('$URL/send_message/$chatID/'));
  request.body = json.encode({"audio_url": audioURL});
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return int.parse(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
    throw Exception(response.reasonPhrase);
  }
}

Future<String> uploadSound(String filePath) async {
  // upload the sound to a cloud bucket
  var url = Uri.parse('$URL/upload');
  var request = http.MultipartRequest('POST', url);

  var multipartFile = await http.MultipartFile.fromPath('file', filePath);
  request.files.add(multipartFile);

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    return responseBody;
  } else {
    throw Exception(response.reasonPhrase);
  }
}

void main(List<String> args) async {
// use something like this to subscribe to a chat

  // createChat('kb53u81EFXZoiMBvnxlDKlasBk12', 'foreignLanguage', '34233');
  chatStream(22).forEach((chat) async {
    Map<String, dynamic> c = await chat;
    print(c);
  });
// use something like this to subscribe to the users favorites
}

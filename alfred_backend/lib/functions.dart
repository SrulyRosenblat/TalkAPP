import 'dart:typed_data';

import 'package:http/http.dart';

Future<Uint8List> download_mp3(String url) async {
  Response response = await get(Uri.parse(url));
  return response.bodyBytes;
}

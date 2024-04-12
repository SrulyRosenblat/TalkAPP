import 'package:alfred_backend/enviroment.dart';

import 'server.dart';

main() async {
  print(env['openai']);
  final server = Server();
  await server.start();
}

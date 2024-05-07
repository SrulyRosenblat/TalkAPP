import 'package:alfred_backend/enviroment.dart';

import 'server.dart';

main() async {
  final server = Server();

  final int envPort = env['port'] as int? ?? 8080;
  print('env $envPort');
  await server.start(envPort);
}

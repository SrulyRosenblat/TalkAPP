import 'package:alfred_backend/enviroment.dart';
import 'package:postgres/postgres.dart';

class DB {
  Connection? conn = null;
  Future init() async {
    print('connecting..');
    conn = await Connection.open(Endpoint(
      host: '34.170.66.40',
      database: 'test',
      username: 'postgres',
      password: env['postgres'],
    ));
    print('connected');
  }

  execute(query) async {
    // fix
    return await conn!.execute(query);
  }

  bool isConnected() {
    return conn != null;
  }

  close() async {
    await conn?.close();
    conn = null;
  }
}

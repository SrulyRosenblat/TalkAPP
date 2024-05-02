import 'dart:io';
// import 'package:alfred/alfred.dart';

import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:http/http.dart' as http;
// import 'package:gcloud/db.dart';
import 'package:gcloud/storage.dart';
import 'package:gcloud/pubsub.dart';
// import 'package:gcloud/service_scope.dart' as ss;
import 'package:gcloud/datastore.dart' as datastore;

class GCP_Storage {
  final bucket_name = "";
  Storage? storage;

  init() async {
    var jsonCredentials =
        new File('Service_account_credentials.json').readAsStringSync();
    var credentials =
        new auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    // Get an HTTP authenticated client using the service account credentials.
    List<String> scopes = []
      ..addAll(datastore.Datastore.Scopes)
      ..addAll(Storage.SCOPES)
      ..addAll(PubSub.SCOPES);
    var client = await auth.clientViaServiceAccount(credentials, scopes);

    // Instantiate objects to access Cloud Datastore, Cloud Storage
    // and Cloud Pub/Sub APIs.
    storage = await new Storage(client, 'talk-app-419322');
    ;
  }

  depositInBucket(Stream stream, String path) async {
    String type = 'audio/mpeg';

    if (storage == null) {
      print("no storage object");
    }
    var bucket = await storage!.bucket('talkapp');
    stream.pipe(bucket.write(path, contentType: type));
  }
}

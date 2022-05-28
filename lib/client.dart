import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:graphql_flutter/graphql_flutter.dart';

Future<GraphQLClient> initClient() async {
  final String host =
  kIsWeb ? 'localhost' : Platform.isAndroid ? '10.0.2.2' : 'localhost';
  await initHiveForFlutter();

  // const clientUri = 'http://$host:4000';
  GraphQLClient getClient({String? subscriptionUri}) {
    Link link = HttpLink(
      'http://$host:4000/',
    );
    if(subscriptionUri != null) {
      final WebSocketLink webSocketLink = WebSocketLink(
        subscriptionUri,
        config:const SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 30),
        ),
      );
      link = link.concat(webSocketLink);
    }
    return GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore()));
  }
  GraphQLClient client = getClient();


  return client;
}
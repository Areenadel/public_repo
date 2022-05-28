import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'client.dart';
import 'app.dart';
import 'package:get_it/get_it.dart';
void main() async {
  final client = await initClient();
  GetIt.I.registerLazySingleton<GraphQLClient>(() => client);
  runApp(MyApp());
}


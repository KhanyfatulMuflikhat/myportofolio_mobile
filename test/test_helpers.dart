import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

/// ApiClient backed by a fake HTTP handler, so tests never touch the network.
ApiClient fakeApiClient([
  Future<http.Response> Function(http.Request)? handler,
]) {
  return ApiClient(
    client: MockClient(handler ?? (_) async => http.Response('[]', 200)),
    baseUrl: 'http://test',
  );
}

/// The real app wired to a fake API client.
Widget testMyApp([ApiClient? client]) =>
    MyApp(apiClient: client ?? fakeApiClient());

/// Wraps [home] with the same providers as the app. Pass [token] to start logged in.
Widget testApp(Widget home, {ApiClient? client, String? token}) {
  final api = client ?? fakeApiClient();
  return MultiProvider(
    providers: [
      Provider.value(value: api),
      ChangeNotifierProvider(
        create: (_) => AuthState(api, initialToken: token),
      ),
    ],
    child: MaterialApp(home: home),
  );
}

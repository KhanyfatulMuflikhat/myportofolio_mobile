import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

import 'test_helpers.dart';

void main() {
  const projectJson = {
    'id': 'abc',
    'title': 'Portfolio',
    'description': 'Mobile app',
    'tech_stack': 'Flutter',
    'project_url': 'https://example.com',
  };

  test('getProjects parses the list and defaults the image to empty', () async {
    final api = fakeApiClient(
      (_) async => http.Response(jsonEncode([projectJson]), 200),
    );
    final projects = await api.getProjects();
    expect(projects.single.title, 'Portfolio');
    expect(projects.single.techStack, 'Flutter');
    expect(projects.single.projectImageUrl, '');
  });

  test('createProject sends the token and omits the id', () async {
    late http.Request sent;
    final api = fakeApiClient((request) async {
      sent = request;
      return http.Response(jsonEncode(projectJson), 201);
    });
    final created = await api.createProject(
      const Project(
        title: 'Portfolio',
        description: 'Mobile app',
        techStack: 'Flutter',
        projectUrl: 'https://example.com',
      ),
      token: 'tok',
    );
    expect(sent.headers['Authorization'], 'Token tok');
    final body = jsonDecode(sent.body) as Map<String, dynamic>;
    expect(body.containsKey('id'), isFalse);
    expect(body['tech_stack'], 'Flutter');
    expect(created.id, 'abc');
  });

  test('obtainToken returns the token', () async {
    final api = fakeApiClient(
      (_) async => http.Response('{"token":"xyz"}', 200),
    );
    expect(await api.obtainToken('u', 'p'), 'xyz');
  });

  test('non-2xx responses throw ApiException', () async {
    final api = fakeApiClient((_) async => http.Response('nope', 401));
    expect(
      api.getProjects(),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 401)),
    );
  });

  group('AuthState', () {
    test('login stores the token and logout clears it', () async {
      final api = fakeApiClient((request) async {
        if (request.url.path.endsWith('/auth/token/')) {
          return http.Response('{"token":"xyz"}', 200);
        }
        return http.Response('', 204);
      });
      final auth = AuthState(api);
      await auth.login('u', 'p');
      expect(auth.isLoggedIn, isTrue);
      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
    });

    test('logout clears the token even when the server rejects it', () async {
      final api = fakeApiClient((_) async => http.Response('invalid', 401));
      final auth = AuthState(api, initialToken: 'stale');
      await auth.logout();
      expect(auth.token, isNull);
    });
  });
}

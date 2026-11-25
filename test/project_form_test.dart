import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('rejects empty required fields', (tester) async {
    await tester.pumpWidget(testApp(const ProjectFormPage(), token: 'tok'));
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    expect(find.text('Title tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Description tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('rejects an invalid project URL', (tester) async {
    await tester.pumpWidget(testApp(const ProjectFormPage(), token: 'tok'));
    await tester.enterText(find.byType(TextFormField).at(3), 'abc');
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    expect(find.text('URL harus diawali http:// atau https://'), findsWidgets);
  });

  testWidgets('asks for login when not logged in', (tester) async {
    await tester.pumpWidget(testApp(const ProjectFormPage()));
    await tester.enterText(find.byType(TextFormField).at(0), 'Portfolio');
    await tester.enterText(find.byType(TextFormField).at(1), 'Mobile app');
    await tester.enterText(find.byType(TextFormField).at(2), 'Flutter');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'https://example.com',
    );
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('valid input posts and shows the confirmation dialog', (
    tester,
  ) async {
    final api = fakeApiClient((request) async {
      expect(request.headers['Authorization'], 'Token tok');
      return http.Response(
        '{"id":"1","title":"Portfolio","description":"Mobile app",'
        '"tech_stack":"Flutter","project_url":"https://example.com",'
        '"project_image_url":""}',
        201,
      );
    });
    await tester.pumpWidget(
      testApp(const ProjectFormPage(), client: api, token: 'tok'),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Portfolio');
    await tester.enterText(find.byType(TextFormField).at(1), 'Mobile app');
    await tester.enterText(find.byType(TextFormField).at(2), 'Flutter');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'https://example.com',
    );
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));

    // Jangan pumpAndSettle: spinner yang berputar bikin timeout.
    await tester.pump(); // mulai submit
    await tester.pump(const Duration(milliseconds: 100)); // response mock selesai
    await tester.pump(const Duration(milliseconds: 500)); // animasi dialog

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul: Portfolio'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

void main() {
  testWidgets('Menu menampilkan identitas dan SnackBar saat kartu ditekan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Khanyfatul Muflikhat'), findsOneWidget);
    expect(find.text('2506589755'), findsOneWidget);
    expect(find.text('PBP A'), findsOneWidget);
    expect(find.text('Lihat Experience'), findsOneWidget);

    await tester.ensureVisible(find.text('Lihat Experience'));
    await tester.tap(find.text('Lihat Experience'));
    await tester.pump();

    expect(
      find.text('Kamu telah menekan tombol Lihat Experience!'),
      findsOneWidget,
    );
  });

  testWidgets('Logout meminta konfirmasi sebelum menampilkan SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Yakin ingin keluar dari akun?'), findsOneWidget);
    expect(find.text('Kamu telah menekan tombol Logout!'), findsNothing);

    await tester.tap(find.text('Ya'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
  });
  testWidgets('Tambah Proyek membuka halaman form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.text('Add Project Form'), findsOneWidget);
  });

  testWidgets('Form menolak nama dan deskripsi kosong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
  });

  testWidgets('Form valid menampilkan dialog berisi data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));

    await tester.enterText(find.byType(TextFormField).at(0), 'Portfolio App');
    await tester.enterText(find.byType(TextFormField).at(1), 'Aplikasi mobile');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: Portfolio App'), findsOneWidget);
  });
}

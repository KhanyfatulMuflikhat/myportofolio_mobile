import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Menu menampilkan identitas dan SnackBar saat kartu ditekan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testMyApp());

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
    await tester.pumpWidget(testMyApp());

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

  testWidgets('Tambah Proyek meminta login bila belum login', (tester) async {
    await tester.pumpWidget(testMyApp());
    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Tambah Experience membuka form', (WidgetTester tester) async {
    await tester.pumpWidget(testMyApp());
    await tester.ensureVisible(find.text('Tambah Experience'));
    await tester.tap(find.text('Tambah Experience'));
    await tester.pumpAndSettle();
    expect(find.text('Add Experience Form'), findsOneWidget);
  });

  testWidgets('Form Experience menolak isian kosong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(const ExperienceFormPage(), token: 'x'));
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal mulai tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Form Experience valid menampilkan dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(const ExperienceFormPage(), token: 'x'));

    await tester.enterText(find.byType(TextFormField).at(0), 'Asisten Dosen');
    await tester.enterText(find.byType(TextFormField).at(1), 'Membantu kelas');

    // Aktifkan "Masih berlangsung" supaya tanggal selesai tidak wajib.
    await tester.ensureVisible(find.text('Masih berlangsung'));
    await tester.tap(find.text('Masih berlangsung'));
    await tester.pump();

    // Pilih tanggal mulai lewat date picker.
    final startField = find.widgetWithText(TextFormField, 'Tanggal Mulai');
    await tester.ensureVisible(startField);
    await tester.pumpAndSettle();
    await tester.tap(startField);
    await tester.pumpAndSettle();

    // Date picker terbuka; konfirmasi tanggal default (hari ini).
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(DatePickerDialog),
        matching: find.byType(TextButton).last,
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Experience berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Judul: Asisten Dosen'), findsOneWidget);
  });

  testWidgets('Tambah Achievement membuka form', (WidgetTester tester) async {
    await tester.pumpWidget(testMyApp());
    await tester.ensureVisible(find.text('Tambah Achievement'));
    await tester.tap(find.text('Tambah Achievement'));
    await tester.pumpAndSettle();
    expect(find.text('Add Achievement Form'), findsOneWidget);
  });

  testWidgets('Form Achievement menolak isian kosong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp(const AchievementFormPage(), token: 'x'));
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pump();
    expect(find.text('Judul tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Penyelenggara tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tanggal pencapaian tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
}

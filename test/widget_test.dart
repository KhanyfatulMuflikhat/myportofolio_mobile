import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

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
}

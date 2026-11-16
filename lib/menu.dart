import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

/// Halaman menu utama: identitas pemilik portofolio dan grid tombol aksi.
///
/// Stateless karena seluruh datanya tetap selama aplikasi berjalan.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506589755";
  final String nama = "Khanyfatul Muflikhat";
  final String kelas = "PBP A";

  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Experience", Icons.work, Colors.indigo),
    ItemHomepage("Tambah Experience", Icons.add_circle, Colors.teal),
    ItemHomepage(
      "Lihat Achievement",
      Icons.emoji_events,
      Colors.orange.shade800,
    ),
    ItemHomepage("Tambah Achievement", Icons.military_tech, Colors.purple),
    ItemHomepage("Lihat Projects", Icons.folder, Colors.blue.shade700),
    ItemHomepage(
      "Logout",
      Icons.logout,
      Colors.red.shade600,
      confirmMessage: "Yakin ingin keluar dari akun?",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // SingleChildScrollView mencegah overflow di layar kecil / jendela sempit.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InfoCard(title: 'NPM', content: npm, icon: Icons.badge),
                  ),
                  Expanded(
                    child: InfoCard(title: 'Name', content: nama, icon: Icons.person),
                  ),
                  Expanded(
                    child: InfoCard(title: 'Class', content: kelas, icon: Icons.school),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Selamat datang di MyPortfolio Mobile!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  // 6 kolom di layar lebar (Chrome/tablet), 3 kolom di HP.
                  final columns = constraints.maxWidth >= 900 ? 6 : 3;
                  return GridView.count(
                    // Scroll diurus SingleChildScrollView, bukan GridView.
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    children: items.map((item) => ItemCard(item)).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
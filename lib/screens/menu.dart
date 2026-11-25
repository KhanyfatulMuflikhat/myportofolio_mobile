import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/achievement_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/welcome_header.dart';
import 'package:provider/provider.dart';


/// Halaman menu utama: identitas pemilik portofolio dan grid tombol aksi.
///
/// Stateless karena seluruh datanya tetap selama aplikasi berjalan.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506589755";
  final String nama = "Khanyfatul Muflikhat";
  final String kelas = "PBP A";

  final List<ItemHomepage> items = [
    ItemHomepage(
      "Lihat Experience",
      Icons.work,
      Colors.indigo,
      description: "Lihat daftar pengalaman",
    ),
    ItemHomepage(
      "Tambah Experience",
      Icons.add_circle,
      Colors.teal,
      description: "Tambah pengalaman baru",
      destination: (context) => const ExperienceFormPage(),
    ),
    ItemHomepage(
      "Lihat Achievement",
      Icons.emoji_events,
      Colors.orange.shade800,
      description: "Lihat daftar pencapaian",
    ),
    ItemHomepage(
      "Tambah Achievement",
      Icons.military_tech,
      Colors.purple,
      description: "Tambah pencapaian baru",
      destination: (context) => const AchievementFormPage(),
    ),
    ItemHomepage(
      "Lihat Projects",
      Icons.folder,
      Colors.blue.shade700,
      description: "Lihat daftar proyek",
      destination: (context) => const ProjectListScreen(),
    ),
    ItemHomepage(
      "Tambah Proyek",
      Icons.create_new_folder,
      Colors.blueGrey.shade700,
      description: "Isi formulir proyek baru",
      destination: (context) => const ProjectFormPage(),
      requiresAuth: true,
    ),
    ItemHomepage(
      "Logout",
      Icons.logout,
      Colors.red.shade600,
      description: "Keluar dari akun",
      confirmMessage: "Yakin ingin keluar dari akun?",
      action: (context) => context.read<AuthState>().logout(),
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
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
                    child: InfoCard(
                      title: 'NPM',
                      content: npm,
                      icon: Icons.badge,
                    ),
                  ),
                  Expanded(
                    child: InfoCard(
                      title: 'Name',
                      content: nama,
                      icon: Icons.person,
                    ),
                  ),
                  Expanded(
                    child: InfoCard(
                      title: 'Class',
                      content: kelas,
                      icon: Icons.school,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              WelcomeHeader(name: nama),
              LayoutBuilder(
                builder: (context, constraints) {
                  // 7 kolom di layar lebar (Chrome/tablet), 3 kolom di HP.
                  final columns = constraints.maxWidth >= 900 ? 7 : 3;
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

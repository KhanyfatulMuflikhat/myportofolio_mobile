import 'package:flutter/material.dart';

/// Kartu informasi ringkas: ikon, judul, dan isi.
///
/// Lebar kartu ditentukan induknya (mis. [Expanded] di dalam [Row]) sehingga tetap proporsional di layar sempit maupun lebar.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4.0),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

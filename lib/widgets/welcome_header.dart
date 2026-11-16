import 'package:flutter/material.dart';

/// Kartu sambutan berisi avatar inisial dan sapaan untuk pemilik portofolio.
///
/// Inisial dan nama panggilan diturunkan dari [name], sehingga tidak ada
/// data yang ditulis ulang (hardcode) di tempat lain.
class WelcomeHeader extends StatelessWidget {
  final String name;

  const WelcomeHeader({super.key, required this.name});

  List<String> get _words =>
      name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

  /// Huruf pertama kata pertama dan terakhir, mis. "Khanyfatul Muflikhat" -> "KM".
  String get _initials {
    final words = _words;
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  /// Kata pertama nama, dipakai pada sapaan.
  String get _firstName => _words.isEmpty ? '' : _words.first;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang, $_firstName!',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text('Selamat datang di MyPortfolio Mobile!'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

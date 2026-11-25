import 'package:flutter/material.dart';

/// Model data satu tombol aksi pada halaman menu portofolio.
class ItemHomepage {
  /// Nama tombol; juga dipakai pada pesan SnackBar.
  final String name;

  /// Ikon yang ditampilkan di atas nama tombol.
  final IconData icon;

  /// Warna latar kartu, sehingga pewarnaan tidak perlu percabangan if-else.
  final Color color;

  /// Penjelasan singkat tombol; tampil sebagai tooltip saat hover/tekan lama.
  /// Jika null, nama tombol yang dipakai.
  final String? description;

  /// Jika tidak null, kartu menampilkan dialog konfirmasi dengan teks ini sebelum aksi dijalankan (dipakai untuk aksi sensitif seperti Logout).
  final String? confirmMessage;

  /// Pembuat halaman tujuan. Jika tidak null, halaman dibuka dengan
  /// Navigator.push setelah tombol ditekan; null berarti tetap di menu.
  final WidgetBuilder? destination;

  /// Jika true, pengguna harus login dulu (lewat LoginScreen) sebelum aksi jalan.
  final bool requiresAuth;

  /// Aksi tambahan yang dijalankan setelah konfirmasi dan login (jika ada),
  /// mis. logout. Dijalankan sebelum SnackBar tampil.
  final Future<void> Function(BuildContext context)? action;

  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.description,
    this.confirmMessage,
    this.destination,
    this.requiresAuth = false,
    this.action,
  });
}

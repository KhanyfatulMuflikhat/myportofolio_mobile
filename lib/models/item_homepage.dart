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

  const ItemHomepage(
    this.name,
    this.icon,
    this.color, {
    this.description,
    this.confirmMessage,
  });
}
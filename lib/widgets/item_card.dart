import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';

/// Kartu tombol aksi berwarna dengan efek sentuh dan SnackBar.
///
/// Warna dan ikon berasal dari [ItemHomepage]. Jika item punya
/// `confirmMessage`, dialog konfirmasi tampil lebih dulu dan SnackBar
/// hanya muncul bila pengguna memilih "Ya".
///
/// Tooltip memakai [ItemHomepage.description]; Semantics menandainya sebagai tombol.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  /// Menampilkan dialog konfirmasi; mengembalikan true jika disetujui.
  Future<bool> _confirm(BuildContext context, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(item.name),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Menampilkan SnackBar sesuai nama tombol yang ditekan.
  ///
  /// Warnanya mengikuti warna kartu agar pengguna langsung tahu
  /// tombol mana yang baru ditekan.
  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: item.color,
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Kamu telah menekan tombol ${item.name}!",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  Future<void> _handleTap(BuildContext context) async {
    final message = item.confirmMessage;
    if (message != null && !await _confirm(context, message)) return;
    if (!context.mounted) return;
    _showSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: Tooltip(
        message: item.description ?? item.name,
        child: Semantics(
          button: true,
          label: item.name,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleTap(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                // FittedBox mengecilkan isi bila kartu terlalu sempit,
                // sehingga tidak terjadi overflow.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: Colors.white, size: 30.0),
                      const Padding(padding: EdgeInsets.all(3)),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 80),
                        child: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

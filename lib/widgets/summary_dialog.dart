import 'package:flutter/material.dart';

/// Dialog ringkasan isian formulir yang ditampilkan setelah validasi lolos.
///
/// Setiap entri [rows] tampil sebagai baris "Label: nilai". [onClose]
/// dipanggil setelah dialog ditutup (mis. untuk mereset form).
Future<void> showSummaryDialog({
  required BuildContext context,
  required String title,
  required Map<String, String> rows,
  required VoidCallback onClose,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in rows.entries)
              Text('${entry.key}: ${entry.value}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(dialogContext);
            onClose();
          },
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';

/// Dekorasi seragam untuk semua field formulir.
InputDecoration formDecoration(String label, {String? hint}) {
  return InputDecoration(
    labelText: label,
    hintText: hint ?? label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

/// Memberi jarak seragam di sekeliling satu field formulir.
Widget paddedField(Widget child) {
  return Padding(padding: const EdgeInsets.all(8.0), child: child);
}

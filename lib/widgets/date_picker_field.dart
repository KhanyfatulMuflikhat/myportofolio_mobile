import 'package:flutter/material.dart';

/// Field tanggal read-only yang membuka `showDatePicker` saat disentuh.
///
/// Teks tampil lewat [controller]; tanggal terpilih dikirim ke [onPicked].
class DatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final DateTime? lastDate;

  const DatePickerField({
    super.key,
    required this.label,
    required this.controller,
    required this.value,
    required this.onPicked,
    this.validator,
    this.enabled = true,
    this.lastDate,
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'YYYY-MM-DD',
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      onTap: () => _pick(context),
      validator: validator,
    );
  }
}

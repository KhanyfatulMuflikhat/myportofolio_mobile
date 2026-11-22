/// Kumpulan fungsi validasi dan format untuk formulir.
///
/// Semua fungsi murni (tanpa state/UI), sehingga mudah diuji.
class FormValidators {
  FormValidators._();

  /// Wajib diisi (spasi saja ditolak) dan opsional dibatasi panjangnya.
  static String? requiredText(
    String? value, {
    required String label,
    int? maxLength,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label tidak boleh kosong!';
    if (maxLength != null && text.length > maxLength) {
      return '$label maksimal $maxLength karakter!';
    }
    return null;
  }

  /// URL opsional: kosong lolos; jika diisi harus http/https dengan host.
  static String? optionalUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : 'URL harus diawali http:// atau https://';
  }

  /// Tanggal selesai: wajib kecuali [ongoing], dan tidak boleh sebelum [start].
  static String? endDate({
    required DateTime? start,
    required DateTime? end,
    required bool ongoing,
  }) {
    if (ongoing) return null;
    if (end == null) {
      return 'Isi tanggal selesai atau aktifkan "Masih berlangsung"!';
    }
    if (start != null && end.isBefore(start)) {
      return 'Tanggal selesai tidak boleh sebelum tanggal mulai!';
    }
    return null;
  }

  /// Format ISO `yyyy-MM-dd`, sama dengan format DateField Django.
  static String formatDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}

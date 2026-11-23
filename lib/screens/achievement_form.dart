import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/date_picker_field.dart';
import 'package:myportofolio_mobile/widgets/form_styles.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Formulir tambah Achievement, mengikuti model Achievement di backend Django:
/// title, issuer, description, level, date_achieved, dan certificate_url.
class AchievementFormPage extends StatefulWidget {
  const AchievementFormPage({super.key});

  @override
  State<AchievementFormPage> createState() => _AchievementFormPageState();
}

class _AchievementFormPageState extends State<AchievementFormPage> {
  static const int _titleMaxLength = 100; // samakan dengan models.py
  static const int _issuerMaxLength = 100; // samakan dengan models.py

  // Samakan isinya dengan pilihan level di models.py
  static const List<String> _levels = [
    'Local',
    'National',
    'International',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _issuerController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _certificateController = TextEditingController();
  final _dateController = TextEditingController();

  String _level = _levels.first;
  DateTime? _dateAchieved;

  @override
  void dispose() {
    _titleController.dispose();
    _issuerController.dispose();
    _descriptionController.dispose();
    _certificateController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  /// Kembalikan form dan semua state ke kondisi awal.
  void _resetForm() {
    _formKey.currentState!.reset();
    _dateController.clear();
    setState(() {
      _level = _levels.first;
      _dateAchieved = null;
    });
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final certificate = _certificateController.text.trim();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Achievement berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: ${_titleController.text.trim()}'),
              Text('Penyelenggara: ${_issuerController.text.trim()}'),
              Text('Deskripsi: ${_descriptionController.text.trim()}'),
              Text('Level: $_level'),
              Text('Tanggal: ${FormValidators.formatDate(_dateAchieved!)}'),
              Text('Sertifikat: ${certificate.isEmpty ? '-' : certificate}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(dialogContext);
              _resetForm();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Achievement Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                paddedField(
                  TextFormField(
                    controller: _titleController,
                    maxLength: _titleMaxLength,
                    decoration: formDecoration('Judul Pencapaian'),
                    validator: (v) => FormValidators.requiredText(
                      v,
                      label: 'Judul',
                      maxLength: _titleMaxLength,
                    ),
                  ),
                ),
                paddedField(
                  TextFormField(
                    controller: _issuerController,
                    maxLength: _issuerMaxLength,
                    decoration: formDecoration('Penyelenggara'),
                    validator: (v) => FormValidators.requiredText(
                      v,
                      label: 'Penyelenggara',
                      maxLength: _issuerMaxLength,
                    ),
                  ),
                ),
                paddedField(
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: formDecoration('Deskripsi'),
                    validator: (v) =>
                        FormValidators.requiredText(v, label: 'Deskripsi'),
                  ),
                ),
                paddedField(
                  DropdownButtonFormField<String>(
                    decoration: formDecoration('Level'),
                    initialValue: _level,
                    items: _levels
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) => setState(() => _level = v!),
                  ),
                ),
                paddedField(
                  DatePickerField(
                    label: 'Tanggal Pencapaian',
                    controller: _dateController,
                    value: _dateAchieved,
                    lastDate: DateTime.now(),
                    onPicked: (date) {
                      setState(() => _dateAchieved = date);
                      _dateController.text = FormValidators.formatDate(date);
                    },
                    validator: (_) =>
                        FormValidators.pastOrTodayDate(_dateAchieved),
                  ),
                ),
                paddedField(
                  TextFormField(
                    controller: _certificateController,
                    keyboardType: TextInputType.url,
                    decoration: formDecoration(
                      'URL Sertifikat',
                      hint: 'https://... (opsional)',
                    ),
                    validator: FormValidators.optionalUrl,
                  ),
                ),
                paddedField(
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _onSave,
                      child: const Text('Simpan'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

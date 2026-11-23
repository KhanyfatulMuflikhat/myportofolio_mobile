import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/date_picker_field.dart';
import 'package:myportofolio_mobile/widgets/form_page_scaffold.dart';
import 'package:myportofolio_mobile/widgets/form_styles.dart';
import 'package:myportofolio_mobile/widgets/summary_dialog.dart';

/// Formulir tambah Experience, mengikuti model Experience di backend Django:
/// title, description, category, thumbnail (URL), started_at, ended_at,
/// dan is_ongoing.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  static const int _titleMaxLength = 100; // samakan dengan models.py

  // Samakan isinya dengan pilihan category di models.py
  static const List<String> _categories = [
    'Work',
    'Organization',
    'Committee',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _startedController = TextEditingController();
  final _endedController = TextEditingController();

  String _category = _categories.first;
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isOngoing = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _startedController.dispose();
    _endedController.dispose();
    super.dispose();
  }

  /// Kembalikan form dan semua state ke kondisi awal.
  void _resetForm() {
    _formKey.currentState!.reset();
    _startedController.clear();
    _endedController.clear();
    setState(() {
      _category = _categories.first;
      _startedAt = null;
      _endedAt = null;
      _isOngoing = false;
    });
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final thumbnail = _thumbnailController.text.trim();
    showSummaryDialog(
      context: context,
      title: 'Experience berhasil ditambahkan!',
      rows: {
        'Judul': _titleController.text.trim(),
        'Deskripsi': _descriptionController.text.trim(),
        'Kategori': _category,
        'Mulai': FormValidators.formatDate(_startedAt!),
        'Selesai': _isOngoing
            ? 'Masih berlangsung'
            : FormValidators.formatDate(_endedAt!),
        'Thumbnail': thumbnail.isEmpty ? '-' : thumbnail,
      },
      onClose: _resetForm,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormPageScaffold(
      title: 'Add Experience Form',
      formKey: _formKey,
      onSave: _onSave,
      children: [
        paddedField(
          TextFormField(
            controller: _titleController,
            maxLength: _titleMaxLength,
            decoration: formDecoration('Judul Experience'),
            validator: (v) => FormValidators.requiredText(
              v,
              label: 'Judul',
              maxLength: _titleMaxLength,
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
            decoration: formDecoration('Kategori'),
            initialValue: _category,
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
        ),
        paddedField(
          DatePickerField(
            label: 'Tanggal Mulai',
            controller: _startedController,
            value: _startedAt,
            onPicked: (date) {
              setState(() => _startedAt = date);
              _startedController.text = FormValidators.formatDate(date);
            },
            validator: (_) =>
                _startedAt == null ? 'Tanggal mulai tidak boleh kosong!' : null,
          ),
        ),
        paddedField(
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Masih berlangsung'),
            value: _isOngoing,
            onChanged: (v) {
              setState(() {
                _isOngoing = v;
                if (v) {
                  _endedAt = null;
                  _endedController.clear();
                }
              });
            },
          ),
        ),
        paddedField(
          DatePickerField(
            label: 'Tanggal Selesai',
            controller: _endedController,
            value: _endedAt,
            enabled: !_isOngoing,
            onPicked: (date) {
              setState(() => _endedAt = date);
              _endedController.text = FormValidators.formatDate(date);
            },
            validator: (_) => FormValidators.endDate(
              start: _startedAt,
              end: _endedAt,
              ongoing: _isOngoing,
            ),
          ),
        ),
        paddedField(
          TextFormField(
            controller: _thumbnailController,
            keyboardType: TextInputType.url,
            decoration: formDecoration(
              'URL Thumbnail',
              hint: 'https://... (opsional)',
            ),
            validator: FormValidators.optionalUrl,
          ),
        ),
      ],
    );
  }
}

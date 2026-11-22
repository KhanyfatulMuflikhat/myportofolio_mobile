import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/date_picker_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

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

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  Widget _padded(Widget child) =>
      Padding(padding: const EdgeInsets.all(8.0), child: child);

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
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Experience berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: ${_titleController.text.trim()}'),
              Text('Deskripsi: ${_descriptionController.text.trim()}'),
              Text('Kategori: $_category'),
              Text('Mulai: ${FormValidators.formatDate(_startedAt!)}'),
              Text(
                _isOngoing
                    ? 'Selesai: Masih berlangsung'
                    : 'Selesai: ${FormValidators.formatDate(_endedAt!)}',
              ),
              Text(
                'Thumbnail: ${_thumbnailController.text.trim().isEmpty ? '-' : _thumbnailController.text.trim()}',
              ),
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
        title: const Text('Add Experience Form'),
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
                _padded(
                  TextFormField(
                    controller: _titleController,
                    maxLength: _titleMaxLength,
                    decoration: _decoration('Judul Experience'),
                    validator: (v) => FormValidators.requiredText(
                      v,
                      label: 'Judul',
                      maxLength: _titleMaxLength,
                    ),
                  ),
                ),
                _padded(
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: _decoration('Deskripsi'),
                    validator: (v) =>
                        FormValidators.requiredText(v, label: 'Deskripsi'),
                  ),
                ),
                _padded(
                  DropdownButtonFormField<String>(
                    decoration: _decoration('Kategori'),
                    initialValue: _category,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                ),
                _padded(
                  DatePickerField(
                    label: 'Tanggal Mulai',
                    controller: _startedController,
                    value: _startedAt,
                    onPicked: (date) {
                      setState(() => _startedAt = date);
                      _startedController.text = FormValidators.formatDate(date);
                    },
                    validator: (_) => _startedAt == null
                        ? 'Tanggal mulai tidak boleh kosong!'
                        : null,
                  ),
                ),
                _padded(
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
                _padded(
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
                _padded(
                  TextFormField(
                    controller: _thumbnailController,
                    keyboardType: TextInputType.url,
                    decoration: _decoration(
                      'URL Thumbnail',
                      hint: 'https://... (opsional)',
                    ),
                    validator: FormValidators.optionalUrl,
                  ),
                ),
                _padded(
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

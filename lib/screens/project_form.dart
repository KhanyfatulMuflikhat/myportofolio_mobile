import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/form_styles.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

/// Form to create a project through the authenticated API.
///
/// Fields mirror the backend ProjectSerializer.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const int _titleMaxLength = 100;
  static const int _techMaxLength = 200;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techController.dispose();
    _urlController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    for (final c in [
      _titleController,
      _descriptionController,
      _techController,
      _urlController,
      _imageController,
    ]) {
      c.clear();
    }
  }

  Future<void> _showCreated(Project project) {
    final image = project.projectImageUrl;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul: ${project.title}'),
              Text('Deskripsi: ${project.description}'),
              Text('Tech stack: ${project.techStack}'),
              Text('URL: ${project.projectUrl}'),
              Text('Gambar: ${image.isEmpty ? '-' : image}'),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final newProject = Project(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      techStack: _techController.text.trim(),
      projectUrl: _urlController.text.trim(),
      projectImageUrl: _imageController.text.trim(),
    );

    setState(() => _isSubmitting = true);
    try {
      final created = await api.createProject(newProject, token: auth.token!);
      if (!mounted) return;
      await _showCreated(created);
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await auth.logout();
        if (!mounted) return;
        _showMessage('Session expired. Please log in again.');
        await ensureLoggedIn(context);
      } else if (e.statusCode == 403) {
        _showMessage('Only a superuser can add projects.');
      } else {
        _showMessage('Failed to save the project (${e.statusCode}).');
      }
    } on Exception {
      if (!mounted) return;
      _showMessage('Cannot reach the server. Is the backend running?');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
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
                    decoration: formDecoration('Title'),
                    validator: (v) => FormValidators.requiredText(
                      v,
                      label: 'Title',
                      maxLength: _titleMaxLength,
                    ),
                  ),
                ),
                paddedField(
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: formDecoration('Description'),
                    validator: (v) =>
                        FormValidators.requiredText(v, label: 'Description'),
                  ),
                ),
                paddedField(
                  TextFormField(
                    controller: _techController,
                    maxLength: _techMaxLength,
                    decoration: formDecoration(
                      'Tech Stack',
                      hint: 'e.g. Flutter, Django, Figma',
                    ),
                    validator: (v) => FormValidators.requiredText(
                      v,
                      label: 'Tech stack',
                      maxLength: _techMaxLength,
                    ),
                  ),
                ),
                paddedField(
                  TextFormField(
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    decoration: formDecoration(
                      'Project URL',
                      hint: 'https://...',
                    ),
                    validator: (v) =>
                        FormValidators.requiredText(v, label: 'Project URL') ??
                        FormValidators.optionalUrl(v),
                  ),
                ),
                paddedField(
                  TextFormField(
                    controller: _imageController,
                    keyboardType: TextInputType.url,
                    decoration: formDecoration(
                      'Project Image URL (Optional)',
                      hint: 'https://... (optional)',
                    ),
                    validator: FormValidators.optionalUrl,
                  ),
                ),
                paddedField(
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Simpan'),
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

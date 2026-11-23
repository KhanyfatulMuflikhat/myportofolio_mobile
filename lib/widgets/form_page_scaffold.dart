import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/form_styles.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Kerangka halaman formulir: AppBar bertema, drawer, area aman, scroll,
/// validasi otomatis saat interaksi, dan tombol Simpan di bagian bawah.
class FormPageScaffold extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final VoidCallback onSave;

  const FormPageScaffold({
    super.key,
    required this.title,
    required this.formKey,
    required this.children,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...children,
                paddedField(
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onSave,
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

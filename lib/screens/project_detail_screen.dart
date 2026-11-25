import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Shows every attribute of one [Project]; the image only appears if a URL exists.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (project.projectImageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    project.projectImageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(
                      height: 120,
                      child: Center(child: Icon(Icons.broken_image, size: 40)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(project.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Tech stack', style: theme.textTheme.labelLarge),
              Text(project.techStack),
              const SizedBox(height: 16),
              Text('Description', style: theme.textTheme.labelLarge),
              Text(project.description),
              const SizedBox(height: 16),
              Text('Project URL', style: theme.textTheme.labelLarge),
              SelectableText(project.projectUrl),
            ],
          ),
        ),
      ),
    );
  }
}

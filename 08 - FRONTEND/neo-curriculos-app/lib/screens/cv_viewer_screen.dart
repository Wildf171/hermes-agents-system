import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CvViewerScreen extends StatelessWidget {
  final String cvUrl;
  final String cvTitle;

  const CvViewerScreen({
    Key? key,
    required this.cvUrl,
    required this.cvTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cvTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(cvUrl))) {
                await launchUrl(Uri.parse(cvUrl));
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 80, color: Theme.of(context).primaryColor),
            SizedBox(height: 24),
            Text(
              'Visualizador PDF',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
              'PDF Preview não está disponível no modo mobile.\nClique no botão acima para abrir em outra aplicação.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(cvUrl))) {
                  await launchUrl(Uri.parse(cvUrl));
                }
              },
              icon: Icon(Icons.open_in_new),
              label: Text('Abrir em outro app'),
            ),
          ],
        ),
      ),
    );
  }
}

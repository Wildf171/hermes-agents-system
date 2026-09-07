import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../config/routes.dart';
import '../providers/curriculo_provider.dart';
import '../utils/constants.dart';

class UploadCvScreen extends StatefulWidget {
  const UploadCvScreen({Key? key}) : super(key: key);

  @override
  State<UploadCvScreen> createState() => _UploadCvScreenState();
}

class _UploadCvScreenState extends State<UploadCvScreen> {
  String? _selectedFilePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enviar Currículo')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24),
            Icon(
              Icons.cloud_upload,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 24),
            Text(
              'Envie seu Currículo',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Formato: ${AppConstants.fileFormat}\nTamanho máximo: ${AppConstants.fileMaxSize}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Consumer<CurriculoProvider>(
              builder: (context, curriculoProvider, _) {
                return Column(
                  children: [
                    if (_selectedFilePath != null)
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(Icons.description),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedFilePath!.split('/').last,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Pronto para enviar',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() => _selectedFilePath = null);
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );
                          if (result != null) {
                            setState(() {
                              _selectedFilePath = result.files.single.path;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).primaryColor.withOpacity(0.05),
                          ),
                          padding: EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(height: 12),
                              Text(
                                AppConstants.buttonChooseFile,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _selectedFilePath != null && !curriculoProvider.isUploading
                          ? () async {
                              final success = await curriculoProvider.uploadCurriculo(_selectedFilePath!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? AppConstants.successUploadTitle
                                          : AppConstants.errorGeneric,
                                    ),
                                  ),
                                );
                                if (success) {
                                  AppRoutes.back(context);
                                }
                              }
                            }
                          : null,
                      child: curriculoProvider.isUploading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(AppConstants.buttonUpload.toUpperCase()),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

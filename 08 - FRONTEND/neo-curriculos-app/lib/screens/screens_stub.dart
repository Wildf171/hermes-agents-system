// Stub file containing remaining screens

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/curriculo_provider.dart';
import '../utils/constants.dart';

// 31 - HOME_SCREEN (already in home_screen.dart)

// 32 - PROFILE SCREEN
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    _nameController = TextEditingController(text: userProvider.user?.nome);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: Consumer2<AuthProvider, UserProvider>(
        builder: (context, authProvider, userProvider, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                        SizedBox(height: 16),
                        Text(
                          authProvider.userName ?? 'Usuário',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 8),
                        Text(
                          authProvider.userEmail ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text('Editar Perfil', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await userProvider.updateProfile(
                      nome: _nameController.text,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Perfil atualizado')),
                      );
                    }
                  },
                  child: Text('Salvar Alterações'),
                ),
                SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      await AppRoutes.toLogin(context);
                    }
                  },
                  child: Text(AppConstants.buttonLogout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 33 - UPLOAD_CV_SCREEN
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
              'Formato: PDF\nTamanho máximo: ${AppConstants.fileMaxSize}',
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
                                    Text(_selectedFilePath!.split('/').last),
                                    Text(
                                      'Pronto para enviar',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
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
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(12),
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
                                'Clique para selecionar arquivo',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _selectedFilePath != null && !curriculoProvider.isUploading
                          ? () async {
                              await curriculoProvider.uploadCurriculo(_selectedFilePath!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(AppConstants.successUploadTitle)),
                                );
                                AppRoutes.back(context);
                              }
                            }
                          : null,
                      child: curriculoProvider.isUploading
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(AppConstants.buttonUpload),
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

// 34 - CV_HISTORY_SCREEN
class CvHistoryScreen extends StatelessWidget {
  const CvHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Currículos')),
      body: Consumer<CurriculoProvider>(
        builder: (context, curriculoProvider, _) {
          if (curriculoProvider.curriculos.isEmpty) {
            return Center(child: Text('Nenhum currículo'));
          }
          return ListView.builder(
            itemCount: curriculoProvider.curriculos.length,
            itemBuilder: (context, index) {
              final cv = curriculoProvider.curriculos[index];
              return ListTile(
                leading: Icon(Icons.description),
                title: Text('Currículo v${cv.versao}'),
                subtitle: Text(cv.criadoEm.toString()),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Visualizar'),
                      onTap: () {
                        AppRoutes.toCvViewer(context, cvUrl: cv.arquivoUrl, cvTitle: 'CV v${cv.versao}');
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Deletar'),
                      onTap: () {
                        curriculoProvider.deleteCurriculo(cv.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 35 - CV_VIEWER_SCREEN
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
      appBar: AppBar(title: Text(cvTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 80),
            SizedBox(height: 16),
            Text('Visualizador PDF'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Open PDF in external app
              },
              child: Text('Abrir em outro app'),
            ),
          ],
        ),
      ),
    );
  }
}

// 36 - LGPD_CONSENT_SCREEN
class LgpdConsentScreen extends StatefulWidget {
  const LgpdConsentScreen({Key? key}) : super(key: key);

  @override
  State<LgpdConsentScreen> createState() => _LgpdConsentScreenState();
}

class _LgpdConsentScreenState extends State<LgpdConsentScreen> {
  bool _consent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.lgpdTitle)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 24),
            Icon(Icons.privacy_tip, size: 80, color: Theme.of(context).primaryColor),
            SizedBox(height: 24),
            Text(
              AppConstants.lgpdTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              AppConstants.lgpdMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            CheckboxListTile(
              value: _consent,
              onChanged: (value) => setState(() => _consent = value ?? false),
              title: Text('Concordo com os termos'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _consent ? () => AppRoutes.toLogin(context) : null,
              child: Text(AppConstants.buttonAgree),
            ),
          ],
        ),
      ),
    );
  }
}

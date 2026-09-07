import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../providers/curriculo_provider.dart';

class CvHistoryScreen extends StatelessWidget {
  const CvHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Currículos')),
      body: Consumer<CurriculoProvider>(
        builder: (context, curriculoProvider, _) {
          if (curriculoProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (curriculoProvider.curriculos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_present, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum currículo'),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: curriculoProvider.curriculos.length,
            itemBuilder: (context, index) {
              final cv = curriculoProvider.curriculos[index];
              return ListTile(
                leading: Icon(Icons.description),
                title: Text('Currículo v${cv.versao}'),
                subtitle: Text(cv.criadoEm.toString().split('.').first),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 20),
                          SizedBox(width: 8),
                          Text('Visualizar'),
                        ],
                      ),
                      onTap: () {
                        AppRoutes.toCvViewer(
                          context,
                          cvUrl: cv.arquivoUrl,
                          cvTitle: 'Currículo v${cv.versao}',
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Deletar', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Deletar Currículo?'),
                            content: Text('Esta ação não pode ser desfeita'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  curriculoProvider.deleteCurriculo(cv.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Deletar', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
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

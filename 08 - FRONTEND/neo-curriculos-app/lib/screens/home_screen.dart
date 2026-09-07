import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/curriculo_provider.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CurriculoProvider>().fetchCurriculos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => AppRoutes.toProfile(context),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Settings
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, CurriculoProvider>(
        builder: (context, authProvider, curriculoProvider, _) {
          return RefreshIndicator(
            onRefresh: () => curriculoProvider.fetchCurriculos(),
            child: ListView(
              children: [
                // Welcome card
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo, ${authProvider.userName}!',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Gerencie seus currículos aqui',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                // Stats
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Currículos',
                          value: curriculoProvider.count.toString(),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Ativo',
                          value: curriculoProvider.activeCurriculo != null
                              ? 'Sim'
                              : 'Não',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // CVs list
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Seus Currículos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 12),

                if (curriculoProvider.isLoading)
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  )
                else if (curriculoProvider.curriculos.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.file_present,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppConstants.emptyNoCurricula,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppConstants.emptyNoCurriculaMessage,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: curriculoProvider.curriculos.length,
                    itemBuilder: (context, index) {
                      final cv = curriculoProvider.curriculos[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.description),
                          title: Text('Currículo v${cv.versao}'),
                          subtitle: Text(cv.criadoEm.toString()),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () => AppRoutes.toCvViewer(
                            context,
                            cvUrl: cv.arquivoUrl,
                            cvTitle: 'Currículo v${cv.versao}',
                          ),
                        ),
                      );
                    },
                  ),

                SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppRoutes.toUploadCv(context),
        tooltip: AppConstants.buttonUpload,
        child: Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

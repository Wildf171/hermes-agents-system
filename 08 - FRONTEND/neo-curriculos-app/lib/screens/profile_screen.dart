import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

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
    _nameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.user != null) {
        _nameController.text = userProvider.user!.nome;
      }
    });
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
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.person, size: 40, color: Colors.white),
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
                Text(
                  'Editar Perfil',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppConstants.labelName,
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: userProvider.isLoading
                      ? null
                      : () async {
                          final success = await userProvider.updateProfile(
                            nome: _nameController.text,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? AppConstants.successProfileUpdate
                                      : AppConstants.errorGeneric,
                                ),
                              ),
                            );
                          }
                        },
                  child: userProvider.isLoading
                      ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(AppConstants.buttonSave),
                ),
                SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppConstants.dialogConfirmLogout),
                        content: Text('Você será desconectado'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(AppConstants.buttonCancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(AppConstants.buttonLogout),
                          ),
                        ],
                      ),
                    );
                    if (confirmed ?? false) {
                      await authProvider.logout();
                      if (context.mounted) {
                        await AppRoutes.toLogin(context);
                      }
                    }
                  },
                  icon: Icon(Icons.logout),
                  label: Text(AppConstants.buttonLogout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

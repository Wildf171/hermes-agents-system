import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../utils/constants.dart';

class LgpdConsentScreen extends StatefulWidget {
  const LgpdConsentScreen({Key? key}) : super(key: key);

  @override
  State<LgpdConsentScreen> createState() => _LgpdConsentScreenState();
}

class _LgpdConsentScreenState extends State<LgpdConsentScreen> {
  bool _consent = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.lgpdTitle),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 24),
              Icon(
                Icons.privacy_tip,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 24),
              Text(
                AppConstants.lgpdTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppConstants.lgpdMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 24),
              CheckboxListTile(
                value: _consent,
                onChanged: (value) => setState(() => _consent = value ?? false),
                title: Text('Concordo com os termos'),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _consent
                      ? () => AppRoutes.toLogin(context)
                      : null,
                  child: Text(AppConstants.buttonAgree.toUpperCase()),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Exit app or show alternatives
                  },
                  child: Text(AppConstants.buttonDisagree.toUpperCase()),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:template_app/services/i18n/locale_key.g.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKey.featuresSettingsPageTitle).tr(),
      ),
      body: const Text(LocaleKey.featuresSettingsPageTitle).tr(),
    );
  }
}

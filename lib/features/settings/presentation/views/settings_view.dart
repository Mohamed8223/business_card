import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).SettingsView_Settings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SettingsItem(
              text: S.of(context).SettingsView_Change_Password,
              icon: changePasswordIcon,
              onTap: () {
                context.push(const ChangePasswordView());
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SettingsItem(
              text: S.of(context).SettingsView_Change_Language,
              icon: changeLanguageIcon,
              onTap: () {},
            ),
            const SizedBox(
              height: 20,
            ),
            SettingsItem(
              text: S.of(context).SettingsView_Delete_My_Account,
              icon: deleteAccountIcon,
              iconWidth: 20,
              iconWPadding: 12,
              onTap: () {},
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

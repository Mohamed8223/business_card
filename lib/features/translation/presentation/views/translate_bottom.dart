import 'package:clinigram_app/features/translation/data/l10n/l10n.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LanguageSelectionWidget extends ConsumerWidget {
  const LanguageSelectionWidget({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: non_constant_identifier_names
    final LanguageProvider = ref.read(appLanguageProvider.notifier);

    const availableLocales = L10n.all;
    const availableLanguage = L10n.language;

    return Container(
        height: 410, // Adjust the height as needed
        width: 300,
        child: ListView.builder(
          itemCount: availableLocales.length,
          itemBuilder: (context, index) {
            final locale = availableLocales[index];
            return ListTile(
              title: Text(availableLanguage[index]),
              onTap: () {
                // Use the localeProvider to set the selected locale
                LanguageProvider.changeLanguage(locale);
                // Close the language selection dialog
                Navigator.of(context).pop();
              },
            );
          },
        ));
  }
}

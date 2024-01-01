import 'package:flutter/material.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AboutUsView_who_are_we),
      ),
    );
  }
}

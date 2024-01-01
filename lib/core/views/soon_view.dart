import 'package:flutter/material.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class SoonView extends StatelessWidget {
  const SoonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(soonBackgroundImage),
            const SizedBox(
              height: 50,
            ),
            Text(
              S.of(context).SoonView_welcome_message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

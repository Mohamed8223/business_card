import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../consultations.dart';

class ConsultationView extends ConsumerWidget {
  const ConsultationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultations = ref.watch(consultationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ConsultationView_title),
      ),
      body: consultations.isEmpty
          ? Center(
              child: Text(S.of(context).ConsultationView_noActiveConsultations),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              itemCount: consultations.length,
              itemBuilder: (context, index) =>
                  ConsultationCard(consultation: consultations[index]),
            ),
    );
  }
}

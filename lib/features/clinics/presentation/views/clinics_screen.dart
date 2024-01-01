import 'package:clinigram_app/features/clinics/presentation/views/clinics_layout.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClinicsScreen extends ConsumerWidget {
  const ClinicsScreen(
      {this.isEditable = true, super.key, required this.doctorId});

  final bool isEditable;
  final String doctorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('العيادات'), //Todo to localization
      ),
      body: ClinicsLayout(
        isEditable: isEditable,
        isForDoctor: true,
        doctorId: doctorId,
      ),
    );
  }
}

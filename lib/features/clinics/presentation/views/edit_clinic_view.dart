import 'package:clinigram_app/core/core.dart';

import 'package:clinigram_app/features/clinics/presentation/widgets/edit_clinic_form.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:image_picker/image_picker.dart';

import '../../data/models/clinic_model.dart';

showEditClinicScreen(BuildContext context,
    {ClinicModel? clinicModel, XFile? localImage}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditClinicScreen(
                clinicModel: clinicModel,
                localImage: localImage,
              )));
}

class EditClinicScreen extends HookConsumerWidget with ValidationMixin {
  EditClinicScreen({this.clinicModel, this.localImage, super.key});

  final ClinicModel? clinicModel;
  final XFile? localImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(clinicModel == null
              ? 'Add Clinic'
              : 'Edit Clinic'), // Customize the title as needed
          leading: const BackButton(), // Adds a back button in AppBar
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: EditClinicForm(
                    clinicModel: clinicModel, localImage: localImage))));
  }
}

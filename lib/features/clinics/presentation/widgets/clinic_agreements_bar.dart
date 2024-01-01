import 'dart:io';

import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class ClinicAgreementsBar extends ConsumerStatefulWidget {
  final ClinicModel clinicModel;

  const ClinicAgreementsBar({Key? key, required this.clinicModel})
      : super(key: key);

  @override
  ConsumerState<ClinicAgreementsBar> createState() =>
      _ClinicAgreementsBarState();
}

class _ClinicAgreementsBarState extends ConsumerState<ClinicAgreementsBar> {
  @override
  Widget build(BuildContext context) {
    final hospitals = widget.clinicModel.doctorAgreement;
    final insurance = widget.clinicModel.agreementsWithInsurance;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: 80, // Adjusted height for the container
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: hospitals.length + insurance.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: 8), // Spacing between items
          itemBuilder: (context, index) {
            String agreement = index < hospitals.length
                ? hospitals[index]
                : insurance[index - hospitals.length];
            return _buildAgreementItem(agreement);
          },
        ),
      ),
    );
  }

  Widget _buildAgreementItem(String agreement) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 3,
        ),
      ),
      width: 80, // Set a fixed width for each item
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                getAgreementPath(agreement),
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.home_work_outlined,
                  color: primaryColor,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

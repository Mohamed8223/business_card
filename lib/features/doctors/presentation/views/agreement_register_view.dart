import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/constants_strings.dart';
import '../../../../core/core.dart';
import '../../../translation/data/generated/l10n.dart';

class AgreementRegister extends HookConsumerWidget {
  const AgreementRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicJob = ref.watch(registerClinicProvider).clinicJob;
    final typeHasAgreements = clinicJob == ClinicJob.dentist ||
        clinicJob == ClinicJob.dentistAndBeauty;

    var selectedAgreementsWithInsurance = ref
        .watch(registerClinicProvider.notifier)
        .state
        .agreementsWithInsurance;

    var selectedAgreements =
        ref.watch(registerClinicProvider.notifier).state.doctorAgreement;

    GestureDetector _buildAgreementItem(String agreement, bool withInsurance) {
      bool selected = withInsurance
          ? selectedAgreementsWithInsurance.contains(agreement)
          : selectedAgreements.contains(agreement);
      return GestureDetector(
        onTap: () {
          selected = !selected;
          if (selected) {
            if (withInsurance) {
              ref.read(registerClinicProvider.notifier).update((state) => state
                      .copyWith(agreementsWithInsurance: [
                    ...selectedAgreementsWithInsurance,
                    agreement
                  ]));
            } else {
              ref.read(registerClinicProvider.notifier).update((state) => state
                  .copyWith(
                      doctorAgreement: [...selectedAgreements, agreement]));
            }
          } else {
            if (withInsurance) {
              ref.read(registerClinicProvider.notifier).update((state) {
                List<String> selectedList =
                    List.from(selectedAgreementsWithInsurance);
                selectedList.remove(agreement);
                return state.copyWith(agreementsWithInsurance: selectedList);
              });
            } else {
              ref.read(registerClinicProvider.notifier).update((state) {
                List<String> selectedList = List.from(selectedAgreements);
                selectedList.remove(agreement);
                return state.copyWith(doctorAgreement: selectedList);
              });
            }
          }
          // });
        },
        child: DottedBorder(
          radius: const Radius.circular(19),
          borderType: BorderType.RRect,
          dashPattern: selected ? [1, 0] : [15, 5],
          color: selected ? primaryColor : Colors.grey.withOpacity(0.7),
          strokeWidth: 3,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: selected ? primaryColor : Colors.white,
                    border: Border(
                        top: BorderSide(
                      width: 2,
                      color: selected
                          ? primaryColor
                          : Colors.grey.withOpacity(0.7),
                    )),
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16))),
                width: double.maxFinite,
                child: Text(
                  agreement,
                  style:
                      TextStyle(color: selected ? Colors.white : primaryColor),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            S.of(context).DoctorAgreementsView_Agreements,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 4 / 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (typeHasAgreements) ...[
                  ...agreementsConstants
                      .map((e) => _buildAgreementItem(e, false))
                      .toList(),
                ],
                if (!typeHasAgreements)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      S
                          .of(context)
                          .DoctorAgreementsView_No_agreements_available_for_this_type,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).CurrentUserProfileView_Agreements_with_insurance,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 4 / 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (typeHasAgreements) ...[
                  ...agreementsWithInsuranceConstants
                      .map((e) => _buildAgreementItem(e, true))
                      .toList(),
                ],
                if (!typeHasAgreements)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      S
                          .of(context)
                          .DoctorAgreementsView_No_agreements_available_for_this_type,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

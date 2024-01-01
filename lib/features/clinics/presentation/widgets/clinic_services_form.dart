import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/doctors/doctors.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// To be used in register clinic view
class ClinicServicesForm extends HookConsumerWidget with ValidationMixin {
  final GlobalKey formKey;

  ClinicServicesForm({required this.formKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);

    ClinicModel clinicModel = ref.read(registerClinicProvider);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (clinicModel.clinicJob != null) {
          ref
              .read(filteredClinicSpecialistsProvider.notifier)
              .initStateForClinic(clinicModel.clinicJob!);
        }

        ref
            .read(clinicSpecialistProvider.notifier)
            .initSateIfNotInitialized(clinicModel.specialists);
      });
      return null; // Return null for no cleanup action
    }, const []);

    var clinicJob = clinicModel.clinicJob;

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(
                      'في هذه الصفحة, يمكنك اختيار نوع العيادة والخدمات التي تقدمها في عيادتك',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ),
                DropdownButtonFormField<ClinicJob>(
                  value: clinicJob,
                  icon: const Icon(Icons.arrow_downward),
                  iconEnabledColor: primaryColor,
                  elevation: 16,
                  style: const TextStyle(color: primaryColor),
                  validator: (value) {
                    if (value == null) {
                      return "من فضلك اختر نوع العيادة";
                    }
                    return null;
                  },
                  hint: Text("نوع العيادة"),
                  onChanged: (ClinicJob? value) {
                    ref.read(registerClinicProvider.notifier).update(
                          (state) => state.copyWith(clinicJob: value),
                        );

                    ref
                        .read(filteredClinicSpecialistsProvider.notifier)
                        .initStateForClinic(value!);

                    ref.read(clinicSpecialistProvider.notifier).initSate([]);

                    clinicJob = value!;

                    ref
                        .read(
                            registerClinicAgreementPageVisibleProvider.notifier)
                        .update((state) =>
                            clinicJob == ClinicJob.dentist ||
                            clinicJob == ClinicJob.dentistAndBeauty);
                  },
                  items: ClinicJob.values
                      .map<DropdownMenuItem<ClinicJob>>((ClinicJob value) {
                    return DropdownMenuItem<ClinicJob>(
                      value: value,
                      child: Text(value == ClinicJob.dentist
                          ? S.of(context).ClinicJobView_Dentist
                          : (value == ClinicJob.beauty)
                              ? S.of(context).ClinicJobView_Cosmetic_Surgeon
                              : S
                                  .of(context)
                                  .ClinicJobView_Cosmetic_Surgeon_and_Dentist),
                    );
                  }).toList(),
                ),
                if (clinicJob != null) ...[
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                        'اختر الخدمات المتوفرة في العيادة من القائمة ادناه',
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[600])),
                  ),
                  const Divider(),
                  DoctorSpecialitiesAndServicesView(
                      specialistProvider: clinicSpecialistProvider,
                      filteredSpecialistProvider:
                          filteredClinicSpecialistsProvider,
                      categoryType: CategoryType.service)
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ));
  }
}

import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/doctors/presentation/views/doctor_specialities_and_services_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../translation/data/generated/l10n.dart';
import '../../providers/doctor_specialist_notifier.dart';

class CareerRegister extends HookConsumerWidget {
  CareerRegister({required this.formKey, super.key});

  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State to track if the user is a doctor
    final isDoctor = ref.watch(isDoctorInEditViewProvider);

    final doctorData = ref.watch(registerUserProvider);
    final years =
        useTextEditingController(text: doctorData.yearsOfExperience.toString());
    final aboutMe =
        useTextEditingController(text: doctorData.aboutMe.toString());
    DoctorJob? doctorJob = doctorData.doctorJob;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DoctorJob? doctorJob = doctorData.doctorJob;
        if (doctorJob != null) {
          updateServicesBySelection(ref, doctorJob);
        }

        ref
            .read(doctorsSpecialistProvider.notifier)
            .initSateIfNotInitialized(doctorData.specialists);
      });
      return null; // Return null for no cleanup action
    }, const []);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  S
                      .of(context)
                      .This_page_is_for_doctors_only_Please_fill_in_your_professional_details_on_this_page,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              ListTile(
                title: Text(S.of(context).Are_you_a_doctor),
                trailing: Switch(
                  value: isDoctor,
                  onChanged: (value) {
                    ref
                        .read(isDoctorInEditViewProvider.notifier)
                        .update((state) => value);
                  },
                ),
              ),
              if (isDoctor) ...[
                const SizedBox(height: 8),
                const Divider(), // Line separator
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: DropdownButtonFormField<DoctorJob>(
                      value: doctorJob,
                      icon: const Icon(Icons.arrow_downward),
                      iconEnabledColor: primaryColor,
                      elevation: 16,
                      style: const TextStyle(color: primaryColor),
                      hint: Text(S.of(context).DoctorJobView_Profession),
                      validator: (value) {
                        if (isDoctor && value == null) {
                          return "الرجاء اختيار المهنة";
                        }
                        return null;
                      },
                      onChanged: (DoctorJob? value) {
                        ref.read(registerUserProvider.notifier).update(
                              (state) => state.copyWith(doctorJob: value),
                            );

                        // Reset the selection
                        updateServicesBySelection(ref, value);
                        ref
                            .read(doctorsSpecialistProvider.notifier)
                            .initSate([]);

                        doctorJob = value!;
                      },
                      items: DoctorJob.values
                          .map<DropdownMenuItem<DoctorJob>>((DoctorJob value) {
                        return DropdownMenuItem<DoctorJob>(
                          value: value,
                          child: Text(value == DoctorJob.dentist
                              ? S.of(context).DoctorJobView_Dentist
                              : (value == DoctorJob.beauty)
                                  ? S.of(context).DoctorJobView_Cosmetic_Surgeon
                                  : S
                                      .of(context)
                                      .DoctorJobView_Cosmetic_Surgeon_and_Dentist),
                        );
                      }).toList(),
                    )),
                    const SizedBox(width: 16),
                    Expanded(
                        child: ClinigramTextField(
                      hintText: S
                          .of(context)
                          .CurrentUserProfileView_Years_of_Experience,
                      textInputType: TextInputType.number,
                      controller: years,
                      validator: (years) {
                        if (!isDoctor) return null;
                        if (years == null || years.trim().isEmpty) {
                          return null; // optional. no error message will be shown
                        }
                        if (int.tryParse(years.trim()) == null) {
                          return "الرجاء ادخال رقم صحيح";
                        }
                        return null;
                      },
                      onComplete: (value) {
                        if (years.text.trim().isNotEmpty &&
                            int.tryParse(years.text.trim()) != null) {
                          ref.read(registerUserProvider.notifier).update(
                                (state) => state.copyWith(
                                    yearsOfExperience:
                                        int.parse(years.text.trim())),
                              );
                        } else if (years.text.trim().isNotEmpty &&
                            int.tryParse(years.text.trim()) == null) {
                          return;
                        }
                      },
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                ClinigramTextField(
                  hintText: S.of(context).CurrentUserProfileView_about_me,
                  textInputType: TextInputType.multiline,
                  controller: aboutMe,
                  onComplete: (value) {
                    ref
                        .read(registerUserProvider.notifier)
                        .update((state) => state.copyWith(aboutMe: value));
                  },
                ),
                const SizedBox(height: 16),
                // You must initialize the following providers before using it: filteredSpecialistsProvider and doctorsSpecialistProvider. see useEffect above.
                DoctorSpecialitiesAndServicesView(
                    specialistProvider: doctorsSpecialistProvider,
                    filteredSpecialistProvider:
                        filteredDoctorSpecialistsProvider,
                    categoryType: CategoryType.specialist)
              ],
            ],
          ),
        ),
      ),
    );
  }

  void updateServicesBySelection(WidgetRef ref, DoctorJob? value) {
    if (value != null) {
      ref.read(filteredDoctorSpecialistsProvider.notifier).initState(value);
    }
  }
}

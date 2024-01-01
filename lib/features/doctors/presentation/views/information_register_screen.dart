import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/auth/auth.dart';
import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_staff_model.dart';
import 'package:clinigram_app/features/clinics/presentation/views/clinic_details.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/add_clinic_basic_form.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_services_form.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_staff_form.dart';
import 'package:clinigram_app/features/clinics/providers/doctor_clinics_provider.dart';
import 'package:clinigram_app/features/doctors/doctors.dart';
import 'package:clinigram_app/features/doctors/presentation/views/step.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:clinigram_app/features/main/main.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../admin_manage/admin_manage.dart';
import '../../../profile/profile.dart';

import '../../../translation/data/generated/l10n.dart';
import 'agreement_register_view.dart';
import 'carrer_register_view.dart';
import 'personal_register_view.dart';

class InformationRegisterScreen extends HookConsumerWidget {
  final c_agreementIndex = 5;

  InformationRegisterScreen(
      {this.isFirst = false,
      this.isEditPreregister,
      this.isAddPreregister,
      this.isEditClinic,
      this.isEditMyUser,
      this.onClinicSave,
      this.onUserSave,
      super.key});

  final personalKey = GlobalKey<FormState>();
  final bool isFirst;
  final bool? isEditPreregister;
  final bool? isAddPreregister;
  final bool? isEditClinic;
  final bool? isEditMyUser;
  final Function(ClinicModel)? onClinicSave;
  final Function(UserModel)? onUserSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
// enablement of pages depends on selectoins
    final agreementPageEnabled =
        ref.watch(registerClinicAgreementPageVisibleProvider);

    AccontType accontType = ref.read(accountTypeProvider) ?? AccontType.user;

    var isPreregister =
        (isAddPreregister ?? false) || (isEditPreregister ?? false);

    if (isPreregister || isEditClinic == true) {
      accontType = AccontType.doctor;
    }

    UserModel userModel = ref.read(currentUserProfileProvider);
    userModel = userModel.copyWith(accontType: accontType);

    UserModel doctorData = ref.read(registerUserProvider);
    final currentRegistrationUser = isPreregister ? doctorData : userModel;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (accontType == AccontType.doctor && isEditMyUser != true) {
          ref
              .read(registerClinicAgreementPageVisibleProvider.notifier)
              .update((state) => true);
        }
      });
    }, const []);

    final activeStep = useState<int>(0);
    final controller = usePageController();

    final icClinicOwner = ref.watch(isClinicOwnerInEditViewProvider);

    final List<EasyStepExtended> infoStepsUser = [
      EasyStepExtended(
        widget: PersonalRegister(
            formKey: personalKey,
            isPreRegister:
                (isAddPreregister ?? false) || (isEditPreregister ?? false)),
        step: EasyStep(
          icon: const Icon(Icons.person, size: 26),
          title: activeStep.value == 0 ? 'بيانات شخصية' : '',
        ),
      ),
      if (isFirst) ...[
        EasyStepExtended(
          widget: FinishRegister(
            isEditClinic: isEditClinic == true,
            isEditMyUser: isEditMyUser == true,
            isFirst: isFirst,
            isEditPreregister: isEditPreregister,
            isAddPreregister: isAddPreregister,
            accountType: accontType,
            onUserSave: onUserSave,
            onClinicSave: onClinicSave,
          ),
          step: EasyStep(
            icon: const Icon(
              Icons.check_circle,
              size: 26,
            ),
            title: activeStep.value == 1 ? 'انتهينا' : '',
          ),
        )
      ]
    ];

    final runnigIndex = isEditClinic == true ? 0 : 2;

    final List<EasyStepExtended> infoStepsClinic = [
      if ((isFirst || isPreregister || isEditClinic == true) &&
          (isEditMyUser != true)) ...[
        //
        // Clinic basic info
        //
        EasyStepExtended(
          widget: AddClinicBasicForm(formKey: personalKey),
          step: EasyStep(
            icon: const Icon(
              Icons.local_hospital_rounded,
              size: 26,
            ),
            title: activeStep.value == runnigIndex ? 'العيادة' : '',
          ),
        ),

        if (icClinicOwner) ...[
          //
          // Clinic services
          //
          EasyStepExtended(
            widget: ClinicServicesForm(formKey: personalKey),
            step: EasyStep(
              icon: const Icon(
                Icons.medical_services_rounded,
                size: 26,
              ),
              title: activeStep.value == runnigIndex + 1 ? 'الخدمات' : '',
            ),
          ),

          //
          // Staff
          //
          EasyStepExtended(
            widget: ClinicStaffForm(
                formKey: personalKey,
                currentRegistrationUser: currentRegistrationUser),
            step: EasyStep(
              icon: const Icon(
                Icons.people_alt_rounded,
                size: 26,
              ),
              title: activeStep.value == runnigIndex + 2 ? 'الطاقم' : '',
            ),
          ),

          //
          // Agreement page
          //
          if (agreementPageEnabled) ...[
            EasyStepExtended(
              widget: const AgreementRegister(),
              step: EasyStep(
                icon: const Icon(
                  Icons.monetization_on,
                  size: 26,
                ),
                title:
                    activeStep.value == runnigIndex + 3 ? 'بيانات قانونية' : '',
              ),
            ),
          ],
        ],

        //
        // Final page
        //
        EasyStepExtended(
          widget: FinishRegister(
            isEditClinic: isEditClinic == true,
            isEditMyUser: isEditMyUser == true,
            isFirst: isFirst,
            isEditPreregister: isEditPreregister,
            accountType: accontType,
            onUserSave: onUserSave,
            onClinicSave: onClinicSave,
          ),
          step: EasyStep(
            icon: const Icon(
              Icons.check_circle,
              size: 26,
            ),
            title: activeStep.value == (icClinicOwner ? 6 : 3) ? 'انتهينا' : '',
          ),
        )
      ]
    ];

    final List<EasyStepExtended> infoStepsDoctor = [
      EasyStepExtended(
        widget: PersonalRegister(
            formKey: personalKey,
            isPreRegister:
                (isAddPreregister ?? false) || (isEditPreregister ?? false)),
        step: EasyStep(
          icon: const Icon(Icons.person, size: 26),
          title: activeStep.value == 0 ? 'بيانات شخصية' : '',
        ),
      ),
      EasyStepExtended(
        widget: CareerRegister(formKey: personalKey),
        step: EasyStep(
          icon: const Icon(Icons.document_scanner_rounded, size: 26),
          title: activeStep.value == 1 ? 'بيانات مهنية' : '',
        ),
      ),
      ...infoStepsClinic,
    ];

    final steps = isEditClinic == true
        ? infoStepsClinic
        : (accontType == AccontType.doctor ? infoStepsDoctor : infoStepsUser);

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isFirst)
            TextButton(
                onPressed: () {
                  _saveData(
                      ref: ref,
                      isEditClinic: isEditClinic == true,
                      isEditMyUser: isEditMyUser == true,
                      isFirst: isFirst,
                      isEditPreregister: isEditPreregister,
                      onUserSave: onUserSave,
                      onClinicSave: onClinicSave);

                  successHandler(context, isFirst || (isEditMyUser == true),
                      isEditClinic == true, isEditMyUser == true);
                },
                child: Text(S.of(context).UpdateProfileView_Save))
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          EasyStepper(
              activeStep: activeStep.value,
              activeStepTextColor: primaryColor,
              finishedStepBackgroundColor: primaryColor,
              internalPadding: 0,
              showLoadingAnimation: true,
              stepRadius: 26,
              showStepBorder: true,
              steppingEnabled: (!isFirst && isEditPreregister == null) ||
                  (isEditPreregister != null && isEditPreregister!),
              finishedStepIconColor: Colors.white,
              steps: steps.map((e) => e.step).toList(),
              onStepReached: (index) {
                stepReachedHocks(
                    index, ref, c_agreementIndex - (2 - runnigIndex));
                activeStep.value = index;
                controller.animateToPage(
                  index,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
              }),
          Expanded(
            child: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: steps.map((e) => e.widget).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (activeStep.value > 0)
                  TextButton(
                      onPressed: () {
                        activeStep.value--;
                        controller.animateToPage(activeStep.value,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn);
                      },
                      child: const Text('<<< السابق')),
                const Expanded(child: SizedBox()),
                if (activeStep.value < steps.length - 1) ...[
                  TextButton(
                      onPressed: () {
                        if (personalKey.currentState == null ||
                            personalKey.currentState!.validate()) {
                          activeStep.value++;
                          controller.animateToPage(activeStep.value,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn);
                        }
                      },
                      child: const Text('التالى >>>')),
                ] else ...[
                  TextButton(
                      onPressed: () async {
                        await _saveData(
                            ref: ref,
                            isEditClinic: isEditClinic == true,
                            isEditMyUser: isEditMyUser == true,
                            isFirst: isFirst,
                            isEditPreregister: isEditPreregister,
                            onUserSave: onUserSave,
                            onClinicSave: onClinicSave);

                        successHandler(
                            context,
                            isFirst || (isEditMyUser == true),
                            isEditClinic == true,
                            isEditMyUser == true);
                      },
                      child: Text(S.of(context).UpdateProfileView_Save))
                ]
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  void stepReachedHocks(int index, WidgetRef ref, int agreementIndex) {
    // hide agreement page if not needed
    if (index != agreementIndex) {
      final clinicJob = ref.watch(registerClinicProvider).clinicJob;
      final typeHasAgreements = clinicJob == ClinicJob.dentist ||
          clinicJob == ClinicJob.dentistAndBeauty;

      ref
          .read(registerClinicAgreementPageVisibleProvider.notifier)
          .update((state) => typeHasAgreements);
    }
  }
}

class FinishRegister extends HookConsumerWidget {
  const FinishRegister(
      {this.isFirst = false,
      this.isEditPreregister,
      this.isAddPreregister,
      required this.accountType,
      required this.isEditClinic,
      required this.isEditMyUser,
      this.onClinicSave,
      this.onUserSave,
      super.key});

  final bool isFirst;
  final bool? isAddPreregister;
  final bool? isEditPreregister;
  final AccontType accountType;
  final bool isEditClinic;
  final bool isEditMyUser;
  final Function(ClinicModel)? onClinicSave;
  final Function(UserModel)? onUserSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
            child: SingleChildScrollView(
                child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(doneImage, width: 200),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClinigramButton(
                onPressed: () async {
                  await _saveData(
                      ref: ref,
                      isEditClinic: isEditClinic,
                      isEditMyUser: isEditMyUser,
                      isFirst: isFirst,
                      isEditPreregister: isEditPreregister,
                      onUserSave: onUserSave,
                      onClinicSave: onClinicSave);

                  var isPreregister = (isAddPreregister ?? false) ||
                      (isEditPreregister ?? false);

                  successHandler(
                      context,
                      !isPreregister || (isEditMyUser == true),
                      isEditClinic,
                      isEditMyUser);
                },
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
                child: Text(
                  S.of(context).Lets_start,
                  style: context.textTheme.titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ))));
  }
}

_saveData({
  required WidgetRef ref,
  required bool isEditClinic,
  required bool isEditMyUser,
  bool isFirst = false,
  bool? isEditPreregister,
  Function(ClinicModel)? onClinicSave,
  Function(UserModel)? onUserSave,
}) async {
  UserModel? owner;

  if (!isEditClinic) {
    owner = await _saveDataForUser(ref, isEditPreregister, isFirst, owner);
    if (owner != null && onUserSave != null) onUserSave(owner);
  } else {
    var currUser = ref.read(currentUserProfileProvider);
    owner = currUser;
  }

  if (isEditMyUser) {
    // nex section is for updating the user clinic
    return;
  }

  // Add the clinic
  ClinicModel newClinic = ref.read(registerClinicProvider);
  XFile? newClinicImage = ref.read(registerClinicImageProvider);

  var clinicSpecialists = ref.read(clinicSpecialistProvider);

  final clinicTypeHasAgreements = newClinic.clinicJob == ClinicJob.dentist ||
      newClinic.clinicJob == ClinicJob.dentistAndBeauty;

  // smart merge the new owners with the old ones that removes duplicates
  final ownerIds = (owner != null && !newClinic.ownerIds.contains(owner.id))
      ? [...newClinic.ownerIds, owner.id]
      : newClinic.ownerIds;

  final staffIds = (owner != null && !newClinic.staffIds.contains(owner.id))
      ? [...newClinic.staffIds, owner.id]
      : newClinic.staffIds;

  final staffList = (owner != null && !newClinic.staffIds.contains(owner.id))
      ? [
          ...newClinic.staff,
          ClinicStaffModel(
            doctorId: owner.id,
            doctorApproved: true,
          )
        ]
      : newClinic.staff;

  newClinic = newClinic.copyWith(
      ownerIds: ownerIds,
      staffIds: staffIds,
      staff: staffList,
      specialists: clinicSpecialists,
      phone: newClinic.phone.isEmpty ? (owner?.phone ?? "") : newClinic.phone,
      email: newClinic.email.isEmpty ? (owner?.email ?? "") : newClinic.email,
      doctorAgreement: clinicTypeHasAgreements ? newClinic.doctorAgreement : [],
      agreementsWithInsurance:
          clinicTypeHasAgreements ? newClinic.agreementsWithInsurance : [],
      isActive: true);

  if (newClinic.id.isEmpty) {
    ref
        .read(doctorClinicsProvider.notifier)
        .addClinic(newClinic, newClinicImage);
  } else {
    ref
        .read(doctorClinicsProvider.notifier)
        .updateClinic(newClinic, newClinicImage);

    ref
        .read(clinicDetailsViewModelProvider.notifier)
        .update((state) => newClinic);
  }

  if (onClinicSave != null) onClinicSave(newClinic);
}

Future<UserModel?> _saveDataForUser(WidgetRef ref, bool? isEditPreregister,
    bool isFirst, UserModel? owner) async {
  UserModel doctorData = ref.read(registerUserProvider);

  final doctorJob = doctorData.doctorJob;
  final doctorJobHasAgreements =
      doctorJob == DoctorJob.dentist || doctorJob == DoctorJob.dentistAndBeauty;

  // add Doctor and ClinicOwner to roles list if needed
  final isDoctor = ref.read(isDoctorInEditViewProvider);
  final isClinicOwner = ref.read(isClinicOwnerInEditViewProvider);
  var roles = <String>[];
  if (isDoctor) {
    roles.add('Doctor');
  } else {
    roles.remove('Doctor');
  }

  if (isClinicOwner) {
    roles.add('ClinicOwner');
  } else {
    roles.remove('ClinicOwner');
  }

  var doctorId =
      isEditPreregister != null && isEditPreregister ? doctorData.id : '';

  doctorData = doctorData.copyWith(
      id: doctorId,
      accontType: ref.read(accountTypeProvider),
      specialists: ref.read(doctorsSpecialistProvider),
      doctorAgreement: doctorJobHasAgreements ? doctorData.doctorAgreement : [],
      agreementsWithInsurance:
          doctorJobHasAgreements ? doctorData.agreementsWithInsurance : [],
      roles: roles);

  if (isEditPreregister == null) {
    UserModel currUser = ref.read(currentUserProfileProvider);
    doctorData = doctorData.copyWith(phone: currUser.phone, id: currUser.id);
    if (isFirst) {
      await ref.read(authProvider.notifier).registerUser(doctorData);
    } else {
      ref
          .read(currentUserProfileProvider.notifier)
          .updateUserProfile(doctorData);
    }

    // Read the current user again to get the updated data with the updated id after inserting it in the database
    currUser = ref.read(currentUserProfileProvider);
    owner = currUser;
  } else if (isEditPreregister) {
    var updatedDoctor = await ref
        .read(preRegDoctorsManageProvider.notifier)
        .editPreRegisterDoctor(doctorData);
    owner = updatedDoctor;
  } else {
    var registeredDoc = await ref
        .read(preRegDoctorsManageProvider.notifier)
        .preRegisterDoctor(doctorData);
    owner = registeredDoc;
  }
  return owner;
}

successHandler(BuildContext context, bool goToMainLayout, bool isEditClinic,
    bool isEditMyUser) {
  context.showSnackbarSuccess(S.of(context).UpdateProfileView_Updated_message);

  if (isEditMyUser) {
    // do nothing. the user will be redirected to the profile page
    return;
  }

  if (isEditClinic) {
    context.pop();
    return;
  }

  if (goToMainLayout) {
    context.pushAndRemoveOthers(const MainLayout());
    return;
  }

  context.pop();
}

import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_staff_model.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_staff_member_card.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_staff_member_modal.dart';
import 'package:clinigram_app/features/doctors/presentation/views/doctor_specialities_and_services_view.dart';
import 'package:clinigram_app/features/doctors/providers/doctor_specialist_notifier.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart'; // For clinic job model
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class ClinicStaffForm extends HookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final UserModel currentRegistrationUser;

  const ClinicStaffForm(
      {required this.formKey,
      super.key,
      required this.currentRegistrationUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ClinicModel clinicModel = ref.watch(registerClinicProvider);

    void openStaffMemberModal(ClinicStaffModel? staffMember) {
      if (clinicModel.clinicJob != null) {
        ref
            .read(filteredClinicSpecialistsProvider.notifier)
            .initStateForClinic(clinicModel.clinicJob!);
      }

      if (staffMember != null) {
        ref
            .read(staffMemberSpecialistProvider.notifier)
            .initSate(staffMember!.specialities);
      }

      showModalBottomSheet(
        context: context,
        builder: (context) {
          double screenHeight = MediaQuery.of(context).size.height;
          return Container(
              height: screenHeight * 0.9,
              child: StaffMemberModal(
                staffMember: staffMember,
                onSave: (updatedStaffMember) {
                  if (staffMember == null) {
                    addStaffMember(ref, updatedStaffMember);
                  } else {
                    updateStaffMember(ref, staffMember, updatedStaffMember);
                  }
                },
              ));
        },
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Text(
                  'هل يوجد اطباء اخرين في العيادة؟ يمكنك اضافتهم في هذه الصفحة',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () => openStaffMemberModal(null),
              child: Text("إضافة طبيب جديد"),
            ),
            const SizedBox(height: 16),
            for (var staff in clinicModel.staff)
              StaffMemberCard(
                staffMember: staff,
                onEdit: () => openStaffMemberModal(staff),
                onDelete: () => deleteStaffMember(ref, staff),
                isClinicOwner: staff.doctorId.isNotEmpty &&
                    clinicModel.ownerIds.contains(staff.doctorId),
                isCurrentRegistationUser: staff.doctorId.isNotEmpty &&
                    staff.doctorId == currentRegistrationUser.id,
                currentRegistationUser: currentRegistrationUser,
              ),
          ],
        ),
      ),
    );
  }

  ClinicModel deleteStaffMember(WidgetRef ref, ClinicStaffModel staff) {
    return ref.read(registerClinicProvider.notifier).update((state) {
      List<ClinicStaffModel> updatedStaff = List.from(state.staff);
      updatedStaff.remove(staff);
      return state.copyWith(staff: updatedStaff);
    });
  }

  void addStaffMember(WidgetRef ref, ClinicStaffModel newStaffMember) {
    ref.read(registerClinicProvider.notifier).update((state) => state.copyWith(
          staff: [...state.staff, newStaffMember],
        ));
  }

  void updateStaffMember(WidgetRef ref, ClinicStaffModel oldStaffMember,
      ClinicStaffModel updatedStaffMember) {
    ref.read(registerClinicProvider.notifier).update((state) {
      List<ClinicStaffModel> updatedStaff = List.from(state.staff);
      int index = updatedStaff.indexOf(oldStaffMember);
      if (index != -1) {
        updatedStaff[index] = updatedStaffMember;
      }
      return state.copyWith(staff: updatedStaff);
    });
  }
}

import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_staff_model.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StaffMemberCard extends HookConsumerWidget {
  final ClinicStaffModel staffMember;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isClinicOwner;
  final bool isCurrentRegistationUser;
  final UserModel currentRegistationUser;

  const StaffMemberCard({
    required this.staffMember,
    required this.onEdit,
    required this.onDelete,
    required this.isClinicOwner,
    required this.isCurrentRegistationUser,
    required this.currentRegistationUser,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var specialitiesString = isCurrentRegistationUser
        ? getSpecialitiesString(currentRegistationUser.specialists, ref)
        : getSpecialitiesString(staffMember.specialities, ref);

    var memberName = isCurrentRegistationUser
        ? currentRegistationUser.getLocalizedFullName(ref) + " (أنت)"
        : staffMember.personalName;

    var allowEdit = !isCurrentRegistationUser && staffMember.doctorId.isEmpty;

    return Card(
      child: ListTile(
        title: Text(memberName),
        subtitle: Text(specialitiesString),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (allowEdit) // Disable edit for current user
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
              ),
            if (!isClinicOwner) // Disable delete for clinic owner
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
      ),
    );
  }

  String getSpecialitiesString(
      List<CategoryModel> specialities, WidgetRef ref) {
    // go over all specialities and get their sub-categories, and join the sub-category types.
    return specialities
        .map((e) =>
            e.subCategories.map((e) => e.getLocalizedName(ref)).join(', '))
        .join(', ');
  }
}

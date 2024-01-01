import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_staff_model.dart';
import 'package:clinigram_app/features/doctors/presentation/views/doctor_specialities_and_services_view.dart';
import 'package:clinigram_app/features/doctors/providers/doctor_specialist_notifier.dart';
import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';

final staffMemberSpecialistProvider =
    StateNotifierProvider<DoctorSpecialistNotifier, List<CategoryModel>>((ref) {
  return DoctorSpecialistNotifier();
});

class StaffMemberModal extends ConsumerStatefulWidget {
  final ClinicStaffModel? staffMember;
  final Function(ClinicStaffModel) onSave;

  const StaffMemberModal({this.staffMember, required this.onSave, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffMemberModalState();
}

class _StaffMemberModalState extends ConsumerState<StaffMemberModal> {
  late TextEditingController nameController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.staffMember?.personalName ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Text('أدخل تفاصيل الطبيب الذي تريد إضافته إلى عيادتك',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ),
              ClinigramTextField(
                controller: nameController,
                hintText: S.of(context).UpdateProfileView_Name,
                validator: (value) => value == null || value.isEmpty
                    ? S.of(context).ValidationMixin_This_field_is_required
                    : null,
              ),
              const SizedBox(height: 16),
              DoctorSpecialitiesAndServicesView(
                specialistProvider: staffMemberSpecialistProvider,
                filteredSpecialistProvider: filteredClinicSpecialistsProvider,
                categoryType: CategoryType.specialist,
              ),
              ClinigramButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final staffMemberSpecialities =
                        ref.read(staffMemberSpecialistProvider);
                    widget.onSave(ClinicStaffModel(
                      personalName: nameController.text.trim(),
                      specialities: staffMemberSpecialities,
                    ));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).UpdateProfileView_Save,
                        style: context.textTheme.titleMedium!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Icon(
                      Icons.save,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

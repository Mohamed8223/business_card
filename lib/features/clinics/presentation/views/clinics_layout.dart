import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/core/utils/alert_dialog.dart';
import 'package:clinigram_app/features/auth/providers/account_type_provider.dart';
import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/presentation/views/clinic_details.dart';
import 'package:clinigram_app/features/clinics/presentation/views/edit_clinic_view.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/cover_image_picker.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/edit_clinic_form.dart';
import 'package:clinigram_app/features/clinics/providers/doctor_clinics_provider.dart';
import 'package:clinigram_app/features/doctors/presentation/views/information_register_screen.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/search/providers/custom_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class ClinicsLayout extends HookConsumerWidget {
  const ClinicsLayout(
      {this.isEditable = false,
      this.isForDoctor = false,
      super.key,
      required this.doctorId});

  final bool isEditable, isForDoctor;
  final String doctorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicsAsync = ref.watch(doctorClinicsProvider);
    final searchClinicsAsync = ref.watch(customSearchProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.watch(doctorClinicsProvider.notifier).getClinics(doctorId);
      });
      return null; // Return null for no cleanup action
    }, const []);

    if (isForDoctor) {
      return clinicsAsync.when(
          data: (state) {
            return _Body(isEditable: isEditable, state: state);
          },
          error: (_, __) => CustomErrorWidget(onTap: () {}),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              ));
    } else {
      return searchClinicsAsync.when(
          data: (state) {
            return _Body(isEditable: false, state: state.clinics);
          },
          error: (_, __) => CustomErrorWidget(onTap: () {}),
          loading: () => const Center(
                child: CircularProgressIndicator(),
              ));
    }
  }
}

class _Body extends HookConsumerWidget {
  const _Body({required this.isEditable, required this.state, super.key});

  final bool isEditable;
  final List<ClinicModel> state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (isEditable)
            ClinigramButton(
                onPressed: () {
                  ref.invalidate(registerUserProvider);

                  ref
                      .read(accountTypeProvider.notifier)
                      .update((state) => AccontType.doctor);

                  ref
                      .read(registerClinicProvider.notifier)
                      .update((state) => ClinicModel.init());

                  context.push(InformationRegisterScreen(
                    isEditPreregister: false,
                    isFirst: false,
                    isEditClinic: true,
                  ));
                },
                child: Text(S.of(context).ClicnkInfoView_Add_Clinic)),
          const SizedBox(height: 16),
          Expanded(
            child: state.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    itemBuilder: (context, index) => ClinicItem(
                      clinicModel: state[index],
                      isEditable: isEditable,
                    ),
                    itemCount: state.length,
                  )
                : Center(
                    child: Text(S
                        .of(context)
                        .CustomSearchResultsView_No_matching_search_results)),
          )
        ],
      ),
    );
  }
}

class ClinicItem extends HookConsumerWidget {
  const ClinicItem(
      {required this.clinicModel, this.isEditable = false, super.key});

  final bool isEditable;
  final ClinicModel clinicModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref
            .read(clinicDetailsViewModelProvider.notifier)
            .update((state) => clinicModel);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClinicDetails(),
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Adjusted to match CSS
            ),
            child: Column(
              children: [
                Expanded(
                  child: CoverImagePicker(
                    currentImage: clinicModel.imageUrl,
                    onImagePicked: (_) {},
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    canEdit: false,
                    isClinicImage: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    clinicModel.getLocalizedFullName(ref),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF113C67),
                    ),
                  ),
                ),
                if (clinicModel.cityModel != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          clinicModel.cityModel?.nameAr ??
                              "", // Replace with actual city name
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF113C67),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
          if (clinicModel.ownerIds
                  .contains(ref.read(currentUserProfileProvider).id) &&
              isEditable)
            Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.2),
                child: IconButton(
                  onPressed: () async {
                    bool? result = await showMyAlertDialog(
                      context: context,
                      title: 'هل أنت واثق من حذف العيادة ؟!',
                      description:
                          'هذا الاجراء سوف يقوم بحذف جميع محتويات العيادة نهائياَ .',
                    );
                    if (result == true) {
                      ref
                          .read(doctorClinicsProvider.notifier)
                          .deleteClinic(clinicModel);
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

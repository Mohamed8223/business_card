import 'package:clinigram_app/features/auth/auth.dart';
import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/repositries/clinics_repo.dart';
import 'package:clinigram_app/features/doctors/presentation/views/information_register_screen.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:clinigram_app/features/profile/data/models/models.dart';
import 'package:clinigram_app/features/profile/presentation/views/other_user_profile_view.dart';

import '../../admin_manage.dart';
import 'package:flutter/material.dart';
import '../../../doctors/doctors.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class DoctorsManageView extends ConsumerStatefulWidget {
  const DoctorsManageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DoctorsManageViewState();
}

class _DoctorsManageViewState extends ConsumerState<DoctorsManageView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(preRegDoctorsManageProvider.notifier).getAllPreRegDoctors();
      ref.read(doctorsProvider.notifier).getDoctorsList(
          activeOlny: false); // Adjust this line if the provider is different
    });
  }

  @override
  Widget build(BuildContext context) {
    final preRegisteredDoctorsAsync = ref.watch(preRegDoctorsManageProvider);
    final allDoctors = ref.watch(doctorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).DoctorsManageView_doctorsTitle),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // add textbox that shows the summary of number of doctors and pre-registered doctors here. we should wait for the data to be loaded first
          SliverToBoxAdapter(
            child: preRegisteredDoctorsAsync.when(
              data: (doctors) => Text(
                  "هناك ${doctors.length} طبيب مسجل مسبقا و ${allDoctors.length} طبيب سجلوا من تلقاء انفسهم."),
              error: (_, __) => CustomErrorWidget(onTap: () {
                ref.invalidate(preRegDoctorsManageProvider);
              }),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          SliverToBoxAdapter(
            child: preRegisteredDoctorsAsync.when(
              data: (doctors) => _buildDoctorListSection(
                  doctors,
                  context,
                  DoctorManagementOptions(
                      allowDelete: true, allowEdit: true, allowExplore: false),
                  S.of(context).DoctorsListSelector_PreRegisterdDoctors),
              error: (_, __) => CustomErrorWidget(onTap: () {
                ref.invalidate(preRegDoctorsManageProvider);
              }),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildDoctorListSection(
                allDoctors,
                context,
                DoctorManagementOptions(
                    allowDelete: false, allowEdit: false, allowExplore: true),
                S.of(context).DoctorsListSelector_Doctors),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.invalidate(registerUserProvider);
          ref
              .read(accountTypeProvider.notifier)
              .update((state) => AccontType.doctor);
          context.push(InformationRegisterScreen(
            isEditPreregister: false,
            isFirst: false,
            isAddPreregister: true,
          ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDoctorListSection(List<UserModel> doctors, BuildContext context,
      DoctorManagementOptions options, String sectionTitle) {
    if (doctors.isNotEmpty) {
      // add doctors count to the section title
      sectionTitle += ' (${doctors.length})';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(sectionTitle, style: Theme.of(context).textTheme.titleLarge),
        ),
        ListView.separated(
          physics:
              const NeverScrollableScrollPhysics(), // to disable ListView's scrolling
          shrinkWrap:
              true, // You need this to tell ListView to size itself to the children
          itemBuilder: (context, index) =>
              _buildDoctorTile(doctors[index], context, options),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: doctors.length,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDoctorTile(
      UserModel doctor, BuildContext context, DoctorManagementOptions options) {
    return ListTile(
        onTap: () {
          if (options.allowExplore) {
            context.push(OtherUserProfileView(userId: doctor.id));
          } else if (options.allowEdit) {
            populateRegisteredDoctorDetailsIntoRelevantProviders(ref, doctor);

            context.push(InformationRegisterScreen(
              isFirst: false,
              isEditPreregister: true,
              isAddPreregister: false,
            ));
          }
        },
        leading: CircleAvatar(
          radius: 27,
          backgroundImage: doctor.imageUrl.isEmpty
              ? const AssetImage(doctorProfileImage) as ImageProvider
              : CachedNetworkImageProvider(doctor.imageUrl),
        ),
        title: Text(
          doctor.getLocalizedFullName(ref),
        ),
        subtitle: Text(doctor.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            options.allowDelete
                ? IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text(
                              S.of(context).DoctorsManageView_ask_to_delete),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              onPressed: () {
                                context.pop();
                                ref
                                    .read(preRegDoctorsManageProvider.notifier)
                                    .deletePreRegisterDoctor(doctor);
                              },
                              child: Text(S.of(context).DoctorsManageView_yes),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text(S.of(context).DoctorsManageView_no),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox.shrink(),
            options.allowEdit
                ? IconButton(
                    onPressed: () {
                      populateRegisteredDoctorDetailsIntoRelevantProviders(
                          ref, doctor);

                      context.push(InformationRegisterScreen(
                          isFirst: false,
                          isEditPreregister: true,
                          isAddPreregister: false));
                    },
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: Colors.black,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        )
        // Or simply use a sized box to take no space when `allowDelete` is false
        );
  }

  void populateRegisteredDoctorDetailsIntoRelevantProviders(
      WidgetRef ref, UserModel userData) async {
    ref.read(registerUserProvider.notifier).update((state) => userData);

    // get the doctor's clinic (if exists)
    final doctorClinic =
        await ref.read(clinicsRepoProvider).getClinicsOwnedByUser(userData.id);

    // if the doctorClinic is not empty and not null
    if (doctorClinic.isNotEmpty) {
      // load the clinic data into the register user provider
      ref
          .read(registerClinicProvider.notifier)
          .update((state) => doctorClinic.last);
    } else {
      ref.read(registerClinicProvider.notifier).update((state) =>
          ClinicModel.init().copyWith(cityModel: userData.cityModel));
    }
  }
}

class DoctorManagementOptions {
  bool allowDelete;
  bool allowEdit;
  bool allowExplore;

  // constructor that initializes the class
  DoctorManagementOptions(
      {this.allowDelete = false,
      this.allowEdit = false,
      this.allowExplore = false});
}

import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/data/models/utils.dart';
import 'package:clinigram_app/features/auth/providers/account_type_provider.dart';
import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_staff_model.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_agreements_bar.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_commands_bar.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/clinic_ratingbar.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/cover_image_picker.dart';
import 'package:clinigram_app/features/doctors/presentation/views/information_register_screen.dart';
import 'package:clinigram_app/features/doctors/providers/doctors_provider.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:clinigram_app/features/main/main.dart';
import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:clinigram_app/features/profile/data/repositries/profile_repo.dart';
import 'package:clinigram_app/features/profile/presentation/widgets/doctor_card.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/profile/providers/rate_provider.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:flutter/material.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

final clinicDetailsViewModelProvider = StateProvider<ClinicModel>((ref) {
  return ClinicModel.init();
});

class ClinicDetails extends ConsumerStatefulWidget {
  ClinicDetails({super.key});

  @override
  ConsumerState<ClinicDetails> createState() => _ClinicDetailsState();
}

class _ClinicDetailsState extends ConsumerState<ClinicDetails> {
  late final _scrollController = ScrollController();

  final horizontalPadding = 20.0;
  double calculateAverageRate(List<RatingModel> ratings) {
    if (ratings.isEmpty) {
      return 0.0;
    }

    double totalRating = 0.0;

    for (var rating in ratings) {
      totalRating += rating.rating;
    }

    return totalRating / ratings.length;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  bool isRated(String userID, List<RatingModel> state) {
    RatingModel rate;
    for (rate in state) {
      if (rate.userId == userID) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final clinicModel = ref.watch(clinicDetailsViewModelProvider);
    String a=clinicModel.getLocalizedFullName(ref);
    clinicModel.ratings;
    double b=0;
   final String userId;
    List<String> mainSpec = [], subSpec = [];
    for (var element in clinicModel.specialists) {
      mainSpec.add(element.nameAr);
      for (var element in element.subCategories) {
        subSpec.add(element.nameAr);
      }
    }
final rateProvider = ref.watch(rateProviderProvider(clinicModel.id));
    return Scaffold(
        body: ListView(
      children: [
        ...clinicHeaderImageAndContent(clinicModel),
        const SizedBox(
          height: 10,
        ),
        const ClinicCommandsBar(),
       Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: rateProvider.isNotEmpty
                          ? calculateAverageRate(rateProvider)
                          : 0,
                      itemSize: 20,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        // The onRatingUpdate callback is not used when ignoreGestures is true.
                      },
                      ignoreGestures: true, // Disable user interaction
                    ),
                    const SizedBox(width: 10),
                    Text(
                        '(${rateProvider.isNotEmpty ? rateProvider.length : 0})'),
                  ],
                ),
        // const ClinicRatingBar(),
        
        if (clinicModel.id.isEmpty) ...[
            const Text(
              "لا يوجد اتفاقيات",
              style: TextStyle(color: Colors.black),
            ),
          ],
          const SizedBox(
            height: 20,
          ),

          if (rateProvider.isNotEmpty) ...[
            RatingsAndCommentsWidget(
              userId: clinicModel.id,
              IsmyProfile: clinicModel.certificationsVerified,
            ),
          ],
          if (rateProvider.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).AddRate_ratings,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff113c67),
                    ),
                  ),
                  if (!isRated(clinicModel.id, rateProvider) ) ...[
                    GestureDetector(
                      onTap: () async {
                        showRatingDialog(context, clinicModel.id);
                      },
                      child: Center(
                          child: Text(
                        S.of(context).AddRate_add_rate,
                        style: const TextStyle(color: Colors.blue),
                      )),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "لا يوجد تقيمات",
              style: TextStyle(color: Colors.black),
            ),
          ],
        const SizedBox(
          height: 20,
        ),
        ...editMyClinicButtonForOwnersOnly(clinicModel),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0),
          child: Text(
            clinicModel.getLocalizedFullName(ref),
            style: const TextStyle(
              fontSize: 20,
              color: secondryColor,
            ),
          ),
        ),
        if (clinicModel.clinicJob != null) ...[
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 0),
            child: Text(
              getClinicTypeString(clinicModel.clinicJob),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ],
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...clinicPageBody(clinicModel),
            ],
          ),
        )
      ],
    ));
  }

  List<Widget> sectionTitle(String title) {
    return [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xff113c67),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  Widget sectionPadding() {
    return const SizedBox(
      height: 10,
    );
  }

  List<Widget> sectionText(String text,
      {bool alwaysLTR = false, bool subText = false, double padding = 8.0}) {
    final textStyle = TextStyle(
        color: subText ? Colors.black : Colors.grey[700],
        fontSize: subText ? 10 : 14,
        fontStyle: subText ? FontStyle.italic : FontStyle.normal);

    if (!alwaysLTR) {
      return [
        Padding(
          padding: EdgeInsets.only(bottom: padding),
          child: Text(
            text,
            style: textStyle,
          ),
        )
      ];
    } else {
      return [
        Padding(
          padding: EdgeInsets.only(bottom: padding),
          child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                text,
                style: textStyle,
              )),
        )
      ];
    }
  }

  List<Widget> clinicHeaderImageAndContent(ClinicModel clinicModel) {
    return [
      SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.35,
          width: double.maxFinite,
          child: Stack(
            children: [
              Positioned.fill(
                child: CoverImagePicker(
                  currentImage: clinicModel.imageUrl,
                  onImagePicked: (img) {
                    debugPrint('image picked ' + (img?.name ?? ""));
                  },
                  canEdit: false,
                  isClinicImage: true,
                ),
              ),
              Positioned(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 30),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          )),
      const Divider(
          height: 1, thickness: 1, color: Colors.black, endIndent: 0, indent: 0)
    ];
  }

  List<Widget> clinicPageBody(ClinicModel clinicModel) {
    final services = calcServicesAsStringArray(clinicModel);

    return [
      ...sectionTitle(S.of(context).DoctorAgreementsView_Agreements),
      ClinicAgreementsBar(
        clinicModel: clinicModel,
      ),
      sectionPadding(),
      //
      if (clinicModel.description.isNotEmpty) ...[
        ...sectionTitle(S.of(context).CurrentUserProfileView_about_me),
        ...sectionText(clinicModel.description),
        sectionPadding(),
      ],
      //
      if (clinicModel.address.isNotEmpty) ...[
        ...sectionTitle('العنوان'),
        ...sectionText(clinicModel.address),
        if (clinicModel.phone.isNotEmpty) ...[
          ...sectionText(clinicModel.phone, alwaysLTR: true),
        ],
        sectionPadding(),
      ],
      //
      staffSection(clinicModel),
      //
      specialitiesSection(clinicModel),
      //
      if (services.isNotEmpty) ...[
        ...sectionTitle(S.of(context).CurrentUserProfileView_Services),
        for (var serviceElement in services) ...[
          ...sectionText(serviceElement)
        ],
        sectionPadding(),
      ],
    ];
  }

  Future<List<String>> calcSpecialitiesAsStringArray(
      ClinicModel clinicModel) async {
    final specialities = <String>[];
    for (var member in clinicModel.staff) {
      if (member.doctorId.isNotEmpty) {
        final userData =
            await ref.read(profileRepoProvider).getUserById(member.doctorId);

        if (userData != null) {
          for (var cat in userData.specialists) {
            for (var subCat in cat.subCategories) {
              if (subCat.categoryType == CategoryType.specialist) {
                specialities.add(subCat.getLocalizedName(ref));
              }
            }
          }
        }
      } else {
        for (var cat in member.specialities) {
          for (var subCat in cat.subCategories) {
            if (subCat.categoryType == CategoryType.specialist) {
              specialities.add(subCat.getLocalizedName(ref));
            }
          }
        }
      }
    }

    return specialities;
  }

  Future<List<ClinicStaffModel>> calcStaffArray(ClinicModel clinicModel) async {
    final staff = <ClinicStaffModel>[];
    for (var member in clinicModel.staff) {
      if (member.doctorId.isNotEmpty) {
        final userData =
            await ref.read(profileRepoProvider).getUserById(member.doctorId);

        if (userData != null) {
          staff.add(member.copyWith(
              personalName: userData.getLocalizedFullName(ref),
              specialities: userData.specialists));
        }
      } else {
        staff.add(member);
      }
    }

    return staff;
  }

  List<String> calcServicesAsStringArray(ClinicModel clinicModel) {
    final services = <String>[];
    for (var cat in clinicModel.specialists) {
      for (var subCat in cat.subCategories) {
        if (subCat.categoryType == CategoryType.service) {
          services.add(subCat.getLocalizedName(ref));
        }
      }
    }
    return services;
  }

  String getClinicTypeString(ClinicJob? clinicJob) {
    switch (clinicJob) {
      case ClinicJob.dentist:
        return S.of(context).ClinicJobView_Dentist;
      case ClinicJob.beauty:
        return S.of(context).ClinicJobView_Cosmetic_Surgeon;
      case ClinicJob.dentistAndBeauty:
        return S.of(context).ClinicJobView_Cosmetic_Surgeon_and_Dentist;
      default:
        return '';
    }
  }

  specialitiesSection(ClinicModel clinicModel) {
    return FutureBuilder<List<String>>(
      future: calcSpecialitiesAsStringArray(clinicModel), // Your async function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return nothing
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          // return
          return const SizedBox.shrink();
        }

        if (snapshot.data == null) {
          return const SizedBox.shrink();
        }

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...sectionTitle(S.of(context).DoctorSpecialistView_Specializations),
          for (var serviceElement in snapshot.data!) ...[
            ...sectionText(serviceElement)
          ],
          sectionPadding(),
        ]);
      },
    );
  }

  staffSection(ClinicModel clinicModel) {
    return FutureBuilder<List<ClinicStaffModel>>(
      future: calcStaffArray(clinicModel), // Your async function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return nothing
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          // return
          return const SizedBox.shrink();
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final staff = snapshot.data!;

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...sectionTitle('طاقم العيادة'),
          for (var member in staff) ...[
            ...sectionText(member.personalName, padding: 2.0),
            for (var cat in member.specialities) ...[
              for (var subCat in cat.subCategories) ...[
                if (subCat.categoryType == CategoryType.specialist) ...[
                  ...sectionText(subCat.getLocalizedName(ref),
                      alwaysLTR: true, subText: true, padding: 2.0)
                ]
              ]
            ],
            const SizedBox(
              height: 5,
            )
          ],
          const SizedBox(
            height: 5,
          )
        ]);
      },
    );
  }

  List<Widget> editMyClinicButtonForOwnersOnly(ClinicModel clinicModel) {
    final user = ref.watch(currentUserProfileProvider);

    if (clinicModel.ownerIds.contains(user.id) == false) {
      return [const SizedBox.shrink()];
    }

    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: ElevatedButton(
          onPressed: () {
            ref.invalidate(registerUserProvider);

            ref
                .read(accountTypeProvider.notifier)
                .update((state) => user.accontType);

            ref
                .read(registerClinicProvider.notifier)
                .update((state) => clinicModel);

            context.push(InformationRegisterScreen(
                isEditPreregister: false,
                isFirst: false,
                isEditClinic: true,
                isEditMyUser: false,
                onClinicSave: (clinic) {
                  clinicModel = clinic;
                }));
          },
          child: Text("تعديل العيادة"),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ];
  }
}

import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/doctors/presentation/views/information_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/features/profile/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:clinigram_app/features/profile/providers/rate_provider.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:clinigram_app/features/profile/presentation/widgets/rate_card.dart';
import 'package:clinigram_app/features/profile/presentation/widgets/rating_widget.dart';
import 'package:clinigram_app/features/profile/providers/other_user_profile_provider.dart';
import 'package:clinigram_app/features/profile/providers/current_user_profile_provider.dart';
import 'package:clinigram_app/features/profile/providers/followers_followings_provider.dart';
import 'package:clinigram_app/features/profile/presentation/views/followings_followers_list_view.dart';

// ignore_for_file: no_logic_in_create_state

// ignore_for_file: non_constant_identifier_names

// ignore_for_file: public_member_api_docs, sort_constructors_first

class DoctorCard extends ConsumerStatefulWidget {
  final bool IsmyProfile;
  final String userId;
  const DoctorCard(this.userId, {required this.IsmyProfile, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DoctorCardState();
}

String _docotorJobName(DoctorJob? doctorJob) {
  switch (doctorJob) {
    case DoctorJob.dentist:
      return S.current.DoctorJobView_Dentist;
    case DoctorJob.beauty:
      return S.current.DoctorJobView_Cosmetic_Surgeon;
    case DoctorJob.dentistAndBeauty:
      return S.current.DoctorJobView_Cosmetic_Surgeon_and_Dentist;
    default:
      return '';
  }
}

void showRatingDialog(BuildContext context, String userId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
            width: 300,
            height: MediaQuery.of(context).size.height * .45,
            child: AddRate(
              userId: userId,
            )),
      );
    },
  );
}

class _DoctorCardState extends ConsumerState<DoctorCard> {
  List<RatingModel>? ratings;

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
  Widget build(BuildContext context) {
    print(ref.read(currentUserProfileProvider).id);
    final user;
    final currentUser = ref.watch(currentUserProfileProvider);
    final userState = ref.watch(otherUserProfileProvider(widget.userId));

    widget.IsmyProfile
        ? user = currentUser
        : user = userState.user; //swatch to profile provider
    final followersFollowings = ref.watch(followersFollowingsProvider);
    final isFollowed =
        ref.read(followersFollowingsProvider.notifier).isFollowed();
    final rateProvider = ref.watch(rateProviderProvider(widget.userId));

    return Column(
      children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color.fromARGB(255, 175, 204, 233),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: 330,
            height: user.accontType == AccontType.doctor ? 390 : 300,
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: getDefaultProfilePicForUser(user),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user.getLocalizedFullName(ref),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff113c67),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user.doctorJob == null ? '' : _docotorJobName(user.doctorJob),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff113c67),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (user.accontType == AccontType.doctor) ...[
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
                const SizedBox(
                  height: 10,
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (user.accontType == AccontType.doctor) ...[
                    Container(
                      width: 150,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xffcceefe),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const ImageIcon(
                            AssetImage(jobIcon),
                            color: Color(0xff113c67),
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S
                                    .of(context)
                                    .CurrentUserProfileView_Years_of_Experience,
                                style: const TextStyle(
                                  fontSize: 11.3,
                                  color: Color(0xff113c67),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.yearsOfExperience.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff113c67),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (user.accontType != AccontType.doctor) ...[
                    GestureDetector(
                      onTap: () {
                        if (widget.IsmyProfile == false) {
                          // Do not show the followings list if it is not my profile
                          return;
                        }

                        context.push(FollowingsFollowersListView(
                            tap: FollowingsFollowersTaps.followings,
                            title: user.getLocalizedFullName(ref),
                            isCurrentUser: widget.IsmyProfile));
                      },
                      child: Center(
                        child: Container(
                          width: 150,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xffcceefe),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                              bottom: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.add_circle_outline,
                                color: Color(0xff113c67),
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .CurrentUserProfileView_followings,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff113c67),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    followersFollowings.followings.length
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff113c67),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.IsmyProfile == false) {
                        // Do not show the followings list if it is not my profile
                        return;
                      }

                      context.push(FollowingsFollowersListView(
                          tap: FollowingsFollowersTaps.followers,
                          title: user.getLocalizedFullName(ref),
                          isCurrentUser: widget.IsmyProfile));
                    },
                    child: Container(
                      width: 150,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xffcceefe),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          const ImageIcon(
                            AssetImage(followersIcon),
                            color: Color(0xff113c67),
                            size: 30,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).CurrentUserProfileView_followers,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff113c67),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                followersFollowings.followers.length.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff113c67),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (user.accontType == AccontType.doctor) ...[
                widget.IsmyProfile
                    ? GestureDetector(
                        onTap: () {
                          if (widget.IsmyProfile == false) {
                            // Do not show the followings list if it is not my profile
                            return;
                          }

                          context.push(FollowingsFollowersListView(
                              tap: FollowingsFollowersTaps.followings,
                              title: user.getLocalizedFullName(ref),
                              isCurrentUser: widget.IsmyProfile));
                        },
                        child: Center(
                          child: Container(
                            width: 150,
                            height: 70,
                            decoration: const BoxDecoration(
                              color: Color(0xffcceefe),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                                bottom: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.add_circle_outline,
                                  color: Color(0xff113c67),
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S
                                          .of(context)
                                          .CurrentUserProfileView_followings,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff113c67),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      followersFollowings.followings.length
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff113c67),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (isFollowed) {
                            ref
                                .read(followersFollowingsProvider.notifier)
                                .unFollow(user);
                          } else {
                            ref
                                .read(followersFollowingsProvider.notifier)
                                .follow(user);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: isFollowed ? 180 : 160,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 25),
                          decoration: BoxDecoration(
                            color: isFollowed
                                ? const Color.fromARGB(255, 225, 229, 232)
                                : const Color(0xff113c67),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            isFollowed
                                ? S.of(context).OtherUserProfileView_Unfollow
                                : S.of(context).OtherUserProfileView_Follow,
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isFollowed
                                  ? const Color.fromARGB(255, 244, 89, 78)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
              ]
            ]),
          ),
          if (widget.IsmyProfile) ...[
            TextButton(
                onPressed: () {
                  ref
                      .read(registerUserProvider.notifier)
                      .update((state) => user);
                  context.push(InformationRegisterScreen(
                      isFirst: false, isEditMyUser: true));
                  // if (user.accontType == AccontType.user) {
                  //   context.push(const UpdateProfileView());
                  // } else {
                  //
                  //   context.push(const DoctorInfoStepper(
                  //     isUpdateProfile: true,
                  //   ));
                  // }
                },
                //getLocalizedText
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 30,
                ))
          ],
        ]),
      ],
    );
  }
}

class InfoColumn extends ConsumerStatefulWidget {
  final bool IsmyProfile;
  final String userId;
  const InfoColumn(this.userId, {required this.IsmyProfile, Key? key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InfoColumnState();
}

class _InfoColumnState extends ConsumerState<InfoColumn> {
  String displayONcurrentLanguage(BuildContext context, String agreement) {
    // Define a map that maps Arabic numerals to their English equivalents
    Map<String, String> wordMap = {
      'Migdal':
          S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Migdal,
      'Clal': S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Clal,
      'Phoenix':
          S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Phoenix,
      'Menora':
          S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Menora,
      'Harel': S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Harel,
      'Dikla': S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Dikla,
      'Ayalon':
          S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Ayalon,
      'IDI': S
          .of(context)
          .DoctorAgreementsWithInsuranceView_Agreements_IDI_Insurance,
      'Eliahu':
          S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Eliahu,
      'Shirbit':
          S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Shirbit,
      'Ilanot':
          S.of(context).DoctorAgreementsWithInsuranceView_Agreements_Ilanot,
      'Clalit': S.of(context).DoctorAgreementsView_Clalit,
      'Meuhedit': S.of(context).DoctorAgreementsView_Meuhedit,
      'Leumit': S.of(context).DoctorAgreementsView_Leumit,
      'Maccabi': S.of(context).DoctorAgreementsView_Maccabi
    };

    // Convert each Arabic numeral to its English equivalent and join them
    List<String> words = agreement.split(' ');
    String englishAgreement = words.map((word) {
      return wordMap[word] ?? word;
    }).join(' ');

    return englishAgreement;
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
    final user;
    final currentUser = ref.watch(currentUserProfileProvider);

    final userState = ref.watch(otherUserProfileProvider(widget.userId));
    widget.IsmyProfile ? user = currentUser : user = userState.user;
    final specialistsList = user?.getSpecialistsByLanguage(
        user.specialists, ref, CategoryType.specialist);

    final servicesList = user?.getSpecialistsByLanguage(
        user.specialists, ref, CategoryType.service);

    final proffession = user?.getProffessionName(user.specialists, ref) ?? '';
    final rateProvider = ref.watch(rateProviderProvider(widget.userId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (user.accontType == AccontType.doctor) ...[
          // Show About Me if it is not empty or if it is my profile
          if (widget.IsmyProfile ||
              (user!.aboutMe != '' && user!.aboutMe != null)) ...[
            Text(
              S.of(context).CurrentUserProfileView_about_me,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff113c67),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              user!.aboutMe,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
          if (proffession != '') ...[
            Text(
              S.of(context).ClicnkInfoView_Clinic_type,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff113c67),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              proffession,
              style: const TextStyle(color: Colors.black),
            ),
          ],
          const SizedBox(
            height: 20,
          ),
          Text(
            S.of(context).CurrentUserProfileView_Services,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff113c67),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (servicesList!.isNotEmpty) ...[
            for (var agreement in servicesList)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(agreement,
                    style: const TextStyle(color: Colors.black)),
              ),
          ],
          if (servicesList.isEmpty) ...[
            const Text(
              "لا يوجد خدمات",
              style: TextStyle(color: Colors.black),
            ),
          ],
          const SizedBox(
            height: 20,
          ),
          Text(
            S.of(context).CurrentUserProfileView_Specialties,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff113c67),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (specialistsList!.isNotEmpty) ...[
            for (var speciality in specialistsList)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(speciality,
                    style: const TextStyle(color: Colors.black)),
              ),
          ],
          if (specialistsList.isEmpty) ...[
            const Text(
              "لا يوجد تخصصات",
              style: TextStyle(color: Colors.black),
            ),
          ],
          const SizedBox(
            height: 20,
          ),
          Text(
            S.of(context).CurrentUserProfileView_Agreements_with_health,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff113c67),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (user.doctorAgreement.isNotEmpty) ...[
            for (var agreement in user.doctorAgreement)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(displayONcurrentLanguage(context, agreement),
                    style: const TextStyle(color: Colors.black)),
              ),
          ],
          if (user.doctorAgreement.isEmpty) ...[
            const Text(
              "لا يوجد اتفاقيات",
              style: TextStyle(color: Colors.black),
            ),
          ],
          const SizedBox(
            height: 20,
          ),
          Text(
            S.of(context).CurrentUserProfileView_Agreements_with_insurance,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff113c67),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (user.agreementsWithInsurance.isNotEmpty) ...[
            for (var agreement in user.agreementsWithInsurance)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(displayONcurrentLanguage(context, agreement),
                    style: const TextStyle(color: Colors.black)),
              ),
          ],
          if (user.agreementsWithInsurance.isEmpty) ...[
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
              userId: widget.userId,
              IsmyProfile: widget.IsmyProfile,
            ),
          ],
          if (rateProvider.isEmpty) ...[
            Row(
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
                if (!isRated(currentUser.id, rateProvider) &&
                    !widget.IsmyProfile) ...[
                  GestureDetector(
                    onTap: () async {
                      showRatingDialog(context, widget.userId);
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
          Text(
            S.of(context).CustomSearchResultsView_Posts,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff113c67),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ], ////////////////////
      ]),
    );
  }
}

class RatingsAndCommentsWidget extends ConsumerStatefulWidget {
  final String userId;
  final bool IsmyProfile;

  // numOfRating = ratings!.length;

  RatingsAndCommentsWidget(
      {Key? key, required this.userId, required this.IsmyProfile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RatingsAndCommentsWidgetState();
}

class _RatingsAndCommentsWidgetState
    extends ConsumerState<RatingsAndCommentsWidget> {
  bool showAll = false;
  bool isRate = false;
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
    final rateProvider = ref.watch(rateProviderProvider(widget.userId));
    final currentUser = ref.watch(currentUserProfileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (!isRated(currentUser.id, rateProvider) &&
                !widget.IsmyProfile) ...[
              GestureDetector(
                onTap: () async {
                  showRatingDialog(context, widget.userId);
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
        const SizedBox(
          height: 20,
        ),
        for (int i = 0;
            i < (showAll || rateProvider.length == 1 ? rateProvider.length : 2);
            i++)
          Column(
            children: [
              RateCard(rateProvider[i].userId, rateProvider[i].rating,
                  rateProvider[i].comment),
              const Divider(),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (!showAll && rateProvider.length > 2)
              TextButton(
                onPressed: () {
                  setState(() {
                    showAll = true;
                  });
                },
                child: Text(
                  S.of(context).AddRate_show_all,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
          ],
        )
      ],
    );
  }
}

import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/repositries/clinics_repo.dart';
import 'package:clinigram_app/features/clinics/presentation/views/clinics_layout.dart';

import '../../../clinics/presentation/views/clinics_screen.dart';
import '../../../clinics/providers/doctor_clinics_provider.dart';
import '../../profile.dart';
import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/features/chats/chats.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/profile/presentation/widgets/doctor_card.dart';
import 'package:clinigram_app/features/profile/providers/other_user_profile_provider.dart';

class OtherUserProfileView extends ConsumerStatefulWidget {
  const OtherUserProfileView({super.key, required this.userId});
  final String userId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtherUserProfileViewState();
}

class _OtherUserProfileViewState extends ConsumerState<OtherUserProfileView> {
  late final _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void showContactInfoDialog(
      BuildContext context, String phoneNumber, String email, Uri call) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: MediaQuery.of(context).size.height * .3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  S.of(context).OtherUserProfileView_user_contacts,
                  style: const TextStyle(
                      color: Color(0xff113c67),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(
                  flex: 2,
                ),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    const Icon(
                      Icons.phone,
                      color: Color(0xff113c67),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        callNumber(call);
                      },
                      child: Text(
                        "0$phoneNumber",
                        locale: const Locale('en'),
                      ),
                    )
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // callNumber(emailUrl);
                      },
                      child: const Icon(
                        Icons.email,
                        color: Color(0xff113c67),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      email,
                      locale: const Locale('en'),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  callNumber(Uri call) async {
    await launchUrl(call);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(otherUserProfileProvider(widget.userId));
    ref.read(doctorClinicsProvider.notifier).getClinics(widget.userId);
    //final followersFollowings = ref.watch(followersFollowingsProvider);

    // add country code to phone number if not exists
    final phone = userState.user?.phone;
    var normalizedPhoneNumber = phone;
    if (normalizedPhoneNumber != null &&
        normalizedPhoneNumber.isNotEmpty &&
        !normalizedPhoneNumber.startsWith('+')) {
      normalizedPhoneNumber = '+972 $normalizedPhoneNumber';
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(S.of(context).OtherUserProfileView_Profile),
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              Uri phoneNum = Uri.parse(
                  'tel:${normalizedPhoneNumber?.replaceAll(' ', '')}');
              // Uri emailUrl = Uri(scheme: 'mailto', path: userState.user!.email);
              showContactInfoDialog(context, userState.user!.phone,
                  userState.user!.email, phoneNum);
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: ImageIcon(
                AssetImage(phoneProfileIcon),
                color: Color(0xff113c67),
                size: 26,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              final currentUser = ref.read(currentUserProfileProvider);
              final chatId = generateChatId(currentUser.id, widget.userId);
              context.push(ChatView(
                chatModel: ChatModel(
                  id: chatId,
                  lastMessage: null,
                  members: [
                    currentUser.toChatMemeber(),
                    userState.user!.toChatMemeber()
                  ],
                ),
              ));
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: ImageIcon(
                AssetImage(profileChatIcon),
                color: Color(0xff113c67),
                size: 26,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: () {
        if (userState.isLoading) {
          return const InlineLoadingWidget();
        } else if (userState.hasError) {
          return CustomErrorWidget(
            onTap: () {
              ref.invalidate(otherUserProfileProvider);
            },
          );
        } else {
          final isFollowed =
              ref.read(followersFollowingsProvider.notifier).isFollowed();
          final userModel = userState.user;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                      child: DoctorCard(widget.userId, IsmyProfile: false)),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                ...clinicsList(userModel!),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                SliverToBoxAdapter(
                    child: InfoColumn(widget.userId, IsmyProfile: false)),
                if (userModel!.accontType != AccontType.user)
                  ProfilePostsList(
                    userId: userModel.id,
                    scrollController: _scrollController,
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                  ),
                )
              ],
            ),
          );
        }
      }.call(),
    );
  }

  List<Widget> clinicsList(UserModel userModel) {
    if (userModel.cityModel == null || userModel.cityModel?.id == null) {
      return [];
    }

    return [
      SliverToBoxAdapter(
          child: FutureBuilder<List<ClinicModel>>(
              future: getClinicsInForDoctor(userModel),
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

                final clinicModels = snapshot.data ?? [];

                int clinicsPerRow = calculateCrossAxisCount(context);

                // Calculate the height based on the number of items and the aspect ratio
                double gridHeight =
                    (clinicModels.length / clinicsPerRow).ceil() *
                        (280); // Adjust 300.0 based on your item height

                if (clinicModels.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'عيادات الطبيب',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff113c67),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height:
                            gridHeight, // Set a fixed height for the GridView
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 280,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8),
                          itemBuilder: (context, index) => ClinicItem(
                            clinicModel: clinicModels[index],
                            isEditable: false,
                          ),
                          itemCount: clinicModels.length,
                        )),
                  ],
                );
              }))
    ];
  }

  int calculateCrossAxisCount(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the number of items that can fit in a row
    int itemCount =
        (screenWidth / (255 + 8)).floor(); // 255 is item width, 8 is spacing

    return itemCount;
  }

  Future<List<ClinicModel>> getClinicsInForDoctor(UserModel userModel) async {
    return ref
        .watch(clinicsRepoProvider)
        .getClinicsWhereUserIsStaff(userModel.id!);
  }
}

import 'package:clinigram_app/core/widgets/search_textbox.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/repositries/clinics_repo.dart';
import 'package:clinigram_app/features/clinics/presentation/views/clinics_layout.dart';
import 'package:clinigram_app/features/main/constants.dart';
import 'package:clinigram_app/features/main/main_layout.dart';
import 'package:clinigram_app/features/profile/utils.dart';

import '../../home.dart';
import '../../../posts/posts.dart';
import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import '../../../profile/profile.dart';
import '../../../consultations/consultations.dart';
import '../../../notifications/notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(homePostsProvider.notifier).getHomePosts();
    });
  }
@override
void dispose() {
   _scrollController.dispose();
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    final userModel = ref.read(currentUserProfileProvider);
    
 print('mosayed');
    return Container(
        padding: const EdgeInsets.only(top: 15),
        child: Scaffold(
            backgroundColor: appBackgroundColor,
            appBar: AppBar(
              title: Text(
                S.of(context).HomeView_appBarTitle,
              ),
              centerTitle: false,
              leadingWidth: 70,
              leading: Row(children: [
                // const SizedBox(width: 15),
                InkWell(
                    onTap: () {
                      ref
                          .read(userLayoutCurrentIndexProvider.notifier)
                          .update((state) => profilePageIndex);
                    },
                    child: Container(
                      width: 60, // Desired width
                      height: 80, // Desired height
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: primaryColor,
                            width: 1,
                          ),
                          image: DecorationImage(
                              image: getDefaultProfilePicForUser(userModel),
                              fit: BoxFit.fitWidth)),
                    ))
              ]),
              actions: [
                const SizedBox(width: 15),
                if (userModel.accontType != AccontType.user)
                  IconButton(
                    onPressed: () {
                      context.push(const ConsultationView());
                    },
                    icon: Image.asset(
                      consultationIcon,
                      width: 48,
                      color: Colors.black,
                    ),
                  ),
                IconButton(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const NotificationsView();
                    }));
                  },
                  icon: Image.asset(
                    notificationIcon,
                    width: 48,
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
            body: ListView(
              controller: _scrollController,
              children: [
                const SizedBox(height: 10),
                const SearchBox(),
                const SizedBox(height: 10),
                const SizedBox(height: 190, child: CategoriesHomeList()),
                const Divider(color: separatorGray),
                ...clinicsList(userModel),
                Text(
                  "منشورات قد تنال إعجابك",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                const PostsList(PostsHost.home)
              ],
            )));
  }

  List<Widget> clinicsList(UserModel userModel) {
    if (userModel.cityModel == null || userModel.cityModel?.id == null) {
      return [];
    }

    return [
      FutureBuilder<List<ClinicModel>>(
          future: getClinicsInCurrentUserCity(userModel),
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
            double gridHeight = (clinicModels.length / clinicsPerRow).ceil() *
                (280); // Adjust 300.0 based on your item height

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "عيادات في بلدك",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: gridHeight, // Set a fixed height for the GridView
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
                const Divider(color: separatorGray),
              ],
            );
          })
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

  Future<List<ClinicModel>> getClinicsInCurrentUserCity(
      UserModel userModel) async {
    return ref
        .watch(clinicsRepoProvider)
        .getClinicsInTheCity(userModel.cityModel?.nameEn ?? "");
  }
}

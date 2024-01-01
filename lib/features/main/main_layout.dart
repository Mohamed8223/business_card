import 'package:clinigram_app/features/auth/auth.dart';
import 'package:clinigram_app/features/main/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/core.dart';
import '../admin_manage/admin_manage.dart';
import '../chats/chats.dart';
import '../consultations/consultations.dart';
import '../home/home.dart';
import '../posts/posts.dart';
import '../profile/profile.dart';
import '../search/presentation/views/views.dart';

class MainLayout extends ConsumerStatefulWidget {
  static int profilePageIndex = 4;

  const MainLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  late List<Widget> _mainLayoutViews;
  late List<String> _mainLayoutBottomBarIcons;
  late AccontType? userType;

  void _listen(WidgetRef ref) {
    ref.listen(userLayoutCurrentIndexProvider, (previous, next) {
      // Invalidate homePostsProvider if user changes tab to profile or home
      // homePostsProvider is automatically invalidated when navigate to any
      // tab that is not using it
      //
      // Invalidate its repo too
      if (previous != next && (next == 4 || next == 0)) {
        ref.invalidate(homePostsProvider);
        ref.invalidate(postsRepoProvider);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userType = ref.read(accountTypeProvider);

    var secondTab =
        userType == AccontType.admin || userType == AccontType.marketer
            ? const AdminManageView()
            : (userType == AccontType.user
                ? const AddConsultationView()
                : const ConsultationView());

    _mainLayoutViews = [
      const HomeView(),
      const ChatsListView(),
      const SizedBox(),
      secondTab,
      const CurrentUserProfileView(),
    ];

    assert(profilePageIndex == _mainLayoutViews.length - 1,
        'Update profilePageIndex');

    _mainLayoutBottomBarIcons = [
      homeIcon,
      chatsIcon,
      '',
      userType == AccontType.admin || userType == AccontType.marketer
          ? settingsIcon
          : consultationIcon,
      profileIcon,
    ];
  }

  @override
  Widget build(BuildContext context) {
    _listen(ref);
    final currentIndex = ref.watch(userLayoutCurrentIndexProvider);
    final isUser = userType == AccontType.user;
    return Scaffold(
      backgroundColor: appBackgroundColor,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: _mainLayoutViews[currentIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: userType == AccontType.marketer
          ? null
          : FloatingActionButton(
              backgroundColor: context.theme.colorScheme.secondary,
              child: isUser
                  ? Image.asset(
                      searchIcon,
                      width: 25,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.add,
                      size: 35,
                    ),
              onPressed: () {
                isUser
                    ? context.push(const CustomSearchView())
                    : context.push(const NewPostView());
              },
            ),
      bottomNavigationBar: BottomAppBar(
          color: context.theme.colorScheme.primary,
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: 56,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < _mainLayoutViews.length; i++)
                    i == 2
                        ? const SizedBox(width: 40)
                        : Expanded(
                            child: Column(
                              children: [
                                IconButton(
                                    icon: Image.asset(
                                      _mainLayoutBottomBarIcons[i],
                                      width: 25,
                                      color: i == currentIndex
                                          ? context.theme.colorScheme.secondary
                                          : Colors.white,
                                    ),
                                    onPressed: () {
                                      if (i == 4) {
                                        ref
                                            .read(currentUserProfileProvider
                                                .notifier)
                                            .getUserData();
                                      }
                                      ref
                                          .read(userLayoutCurrentIndexProvider
                                              .notifier)
                                          .update((state) => i);
                                    }),
                              ],
                            ),
                          ),
                ]),
          )),
    );
  }
}

final userLayoutCurrentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

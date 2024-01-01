import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../profile.dart';

class FollowingsFollowersListView extends ConsumerStatefulWidget {
  const FollowingsFollowersListView(
      {super.key,
      required this.tap,
      required this.title,
      this.isCurrentUser = false});
  final FollowingsFollowersTaps tap;
  final String title;
  final bool isCurrentUser;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FollowingsFollowersListViewState();
}

class _FollowingsFollowersListViewState
    extends ConsumerState<FollowingsFollowersListView> {
  late List<UserModel> usersList;
  late FollowingsFollowersTaps selectedTap;
  @override
  void initState() {
    super.initState();
    selectedTap = widget.tap;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(currentUserProfileProvider);
    final follwersFollowings = ref.watch(followersFollowingsProvider);
    if (selectedTap == FollowingsFollowersTaps.followers) {
      usersList = follwersFollowings.followers;
    } else {
      usersList = follwersFollowings.followings;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            if (widget.isCurrentUser) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: FollowingsFollowersTapsWidget(
                  initialTap: widget.tap,
                  onToggle: (tap) {
                    selectedTap = tap;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      final isMe = currentUser.id == usersList[index].id;
                      final isFollowed = ref
                          .read(followersFollowingsProvider.notifier)
                          .isFollowed(
                              isMyProfile: widget.isCurrentUser,
                              userToBeChecked: usersList[index]);
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.27),
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(userProfileImage),
                          ),
                          title: Text(
                            isMe
                                ? '${usersList[index].getLocalizedFullName(ref)} (${S.of(context).FollowingsFollowersListView_You})'
                                : usersList[index].getLocalizedFullName(ref),
                            style: context.textTheme.titleMedium,
                          ),
                          trailing: isMe ||
                                  (widget.isCurrentUser &&
                                      selectedTap ==
                                          FollowingsFollowersTaps.followers)
                              ? null
                              : SizedBox(
                                  width: 100,
                                  height: 45,
                                  child: ClinigramButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: context
                                            .theme.colorScheme.secondary),
                                    onPressed: () {
                                      isFollowed
                                          ? ref
                                              .read(followersFollowingsProvider
                                                  .notifier)
                                              .unFollow(usersList[index],
                                                  isMyProfile: true)
                                          : ref
                                              .read(followersFollowingsProvider
                                                  .notifier)
                                              .follow(usersList[index]);
                                    },
                                    child: Text(
                                      isFollowed
                                          ? S
                                              .of(context)
                                              .FollowingsFollowersListView_Unfollow
                                          : S
                                              .of(context)
                                              .FollowingsFollowersListView_Follow,
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                    ),
                                  ),
                                ),
                        ),
                      );
                    }),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class FollowingsFollowersTapsWidget extends StatefulWidget {
  const FollowingsFollowersTapsWidget(
      {super.key, required this.onToggle, required this.initialTap});
  final Function(FollowingsFollowersTaps) onToggle;
  final FollowingsFollowersTaps initialTap;
  @override
  State<FollowingsFollowersTapsWidget> createState() =>
      _FollowingsFollowersTapsWidgetState();
}

class _FollowingsFollowersTapsWidgetState
    extends State<FollowingsFollowersTapsWidget> {
  late FollowingsFollowersTaps selectedTap;
  @override
  void initState() {
    super.initState();
    selectedTap = widget.initialTap;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.theme.colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTap = FollowingsFollowersTaps.followers;
                });
                widget.onToggle(selectedTap);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(5),
                  ),
                  color: selectedTap == FollowingsFollowersTaps.followers
                      ? context.theme.colorScheme.primary
                      : Colors.white,
                ),
                child: Text(
                  S.of(context).FollowingsFollowersListView_Followers,
                  style: context.textTheme.titleMedium!.copyWith(
                    color: selectedTap == FollowingsFollowersTaps.followers
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTap = FollowingsFollowersTaps.followings;
                });
                widget.onToggle(selectedTap);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(5),
                  ),
                  color: selectedTap == FollowingsFollowersTaps.followings
                      ? context.theme.colorScheme.primary
                      : Colors.white,
                ),
                child: Text(
                  S.of(context).FollowingsFollowersListView_Following,
                  style: context.textTheme.titleMedium!.copyWith(
                    color: selectedTap == FollowingsFollowersTaps.followings
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

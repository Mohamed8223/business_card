import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../posts/posts.dart';

class ProfilePostsList extends ConsumerStatefulWidget {
  const ProfilePostsList({
    super.key,
    required this.userId,
    required this.scrollController,
  });
  final String userId;
  final ScrollController scrollController;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfilePostsListState();
}

class _ProfilePostsListState extends ConsumerState<ProfilePostsList> {
  bool hasReachedMax = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref
          .read(profilePostsProvider.notifier)
          .getUserPosts(widget.userId, true /*isInitialLoad*/);
    });
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom && !hasReachedMax && !isLoading) {
      isLoading = true;
      ref
          .read(profilePostsProvider.notifier)
          .getUserPosts(widget.userId, false /*isInitialLoad*/);
    }
  }

  bool get _isBottom {
    if (!widget.scrollController.hasClients) return false;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profilePostsProvider);
    final postsList = state.$1;
    hasReachedMax = state.$2;
    return SliverList.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: hasReachedMax ? postsList.length : postsList.length + 1,
      itemBuilder: (context, index) {
        isLoading = false;
        return Column(
          children: [
            (index >= postsList.length) && !hasReachedMax
                ? const InlineLoadingWidget()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PostWidget(
                      postModel: postsList[index],
                      clickable: false,
                      postsHost: PostsHost.profile,
                    ),
                  ),
          ],
        );
      },
    );
  }
}

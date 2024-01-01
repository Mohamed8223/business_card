import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../posts.dart';

class PostsList extends ConsumerStatefulWidget {
  const PostsList(this.postsHost, {super.key});

  final PostsHost postsHost;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostsListState(postsHost);
}

class _PostsListState extends ConsumerState<PostsList> {
  final _scrollController = ScrollController();

  final PostsHost postsHost;

  bool hasReachedMax = false;
  bool isLoading = true;

  _PostsListState(this.postsHost);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    var relevantPostsProvider =
        postsHost == PostsHost.home ? homePostsProvider : profilePostsProvider;
    if (_isBottom && !hasReachedMax && !isLoading) {
      isLoading = true;
      ref.read(relevantPostsProvider.notifier).getHomePosts(showLoading: false);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    var relevantPostsProvider =
        postsHost == PostsHost.home ? homePostsProvider : profilePostsProvider;
    final state = ref.watch(relevantPostsProvider);
    final postsList = state.$1;
    hasReachedMax = state.$2;

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(), // prevent inner scrolling
      shrinkWrap: true, // allows the list to take as much space as it needs
      separatorBuilder: (context, index) => const Divider(),
      controller: _scrollController,
      itemCount: hasReachedMax ? postsList.length : postsList.length + 1,
      itemBuilder: (context, index) {
        isLoading = false;
        return Column(
          children: [
            (index >= postsList.length) && !hasReachedMax
                ? const InlineLoadingWidget()
                : PostWidget(postModel: postsList[index], postsHost: postsHost),
          ],
        );
      },
    );
  }
}

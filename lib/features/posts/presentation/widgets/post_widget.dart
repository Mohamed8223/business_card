import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/profile/utils.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rich_readmore/rich_readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../posts.dart';

class PostWidget extends ConsumerWidget {
  const PostWidget({
    super.key,
    required this.postModel,
    required this.postsHost,
    this.clickable = true,
  });
  final PostModel postModel;
  final PostsHost postsHost;
  final bool clickable;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(currentUserProfileProvider);
    final isMyPost = postModel.userModel.id == currentUser.id;
    final langCode = ref.watch(appLanguageProvider).languageCode;

    final timeAgoMessages = (langCode == 'ar')
        ? timeago.ArMessages()
        : (langCode == 'en')
            ? timeago.EnMessages()
            : (langCode == 'he')
                ? timeago.HeMessages()
                : (langCode == 'ru')
                    ? timeago.RuMessages()
                    : timeago.EnMessages();
    timeago.setLocaleMessages(langCode, timeAgoMessages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: isMyPost || !clickable
              ? null
              : () {
                  // Do not invalidate the post model because it will be used in the OtherUserProfileView
                  context.push(OtherUserProfileView(
                    userId: postModel.userModel.id,
                  ));
                },
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          horizontalTitleGap: 8,
          leading: CircleAvatar(
              radius: 35,
              backgroundColor: primaryColor,
              child: CircleAvatar(
                backgroundImage: postModel.userModel.imageUrl.isEmpty
                    ? getDefaultProfilePicByAccountType(
                        postModel.userModel.accontType) as ImageProvider
                    : CachedNetworkImageProvider(postModel.userModel.imageUrl),
                radius: 33,
              )),
          title: Text(
            postModel.userModel.getLocalizedFullName(ref),
            style: const TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(timeago.format(postModel.createdAt, locale: langCode)),
        ),
        if (postModel.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: RichReadMoreText.fromString(
              text: postModel.description,
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              settings: LengthModeSettings(
                trimLength: 200,
                trimCollapsedText: S.of(context).PostWidget_viewMore,
                trimExpandedText: S.of(context).PostWidget_viewLess,
                lessStyle: const TextStyle(color: Colors.blue),
                moreStyle: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
        if (postModel.attatchments.isNotEmpty)
          ImageSlideshow(
            indicatorColor: secondryColor,
            indicatorBackgroundColor: inactiveGray,
            height: (kIsWeb
                    ? min(WebWidth, context.screenSize.width)
                    : context.screenSize.width) *
                0.9,
            children: [
              for (int i = 0; i < postModel.attatchments.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CachedNetworkImage(
                    imageUrl: postModel.attatchments[i],
                    progressIndicatorBuilder: (context, url, progress) =>
                        const CircularProgressIndicator(),
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        PostActionIcons(post: postModel, postsHost: postsHost),
        TextButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              constraints: BoxConstraints(
                maxHeight: context.screenSize.height * 0.8,
              ),
              builder: (context) => CommentsWidget(
                postId: postModel.id!,
                postUser: postModel.userModel,
                postsHost: postsHost,
              ),
            );
          },
          child: Text(
              '${S.of(context).PostWidget_showAllComments} (${postModel.commentsCount})'),
        ),
      ],
    );
  }
}

class PostActionIcons extends ConsumerWidget {
  const PostActionIcons(
      {super.key, required this.post, required this.postsHost});
  final PostModel post;
  final PostsHost postsHost;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relevantPostsProvider = (postsHost == PostsHost.home)
        ? homePostsProvider
        : profilePostsProvider;
    final isLiked =
        ref.read(relevantPostsProvider.notifier).isLiked(post.likes);
    return Row(
      children: [
        IconButton(
          onPressed: () {
            !isLiked
                ? ref.read(relevantPostsProvider.notifier).like(post.id!)
                : ref.read(relevantPostsProvider.notifier).unlike(post.id!);
          },
          icon: Image.asset(
            likeIcon,
            width: 25,
            color: isLiked ? Colors.red : primaryColor,
          ),
        ),
        IconButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              constraints: BoxConstraints(
                maxHeight: context.screenSize.height * 0.8,
              ),
              builder: (context) => CommentsWidget(
                postId: post.id!,
                postUser: post.userModel,
                postsHost: postsHost,
              ),
            );
          },
          icon: Image.asset(
            commentsIcon,
            width: 23,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}

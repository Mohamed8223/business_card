import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/profile/utils.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../profile/profile.dart';
import '../../posts.dart';

class CommentsWidget extends StatefulHookConsumerWidget {
  const CommentsWidget(
      {super.key,
      required this.postId,
      required this.postUser,
      required this.postsHost});
  final String postId;
  final UserModel postUser;
  final PostsHost postsHost;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentsWidgetState(postsHost);
}

class _CommentsWidgetState extends ConsumerState<CommentsWidget> {
  _CommentsWidgetState(this.postsHost);

  final PostsHost postsHost;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(commentsProvider.notifier).getPostComments(widget.postId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.read(currentUserProfileProvider);
    final commentConroller = useTextEditingController();
    final commentsState = ref.watch(commentsProvider);
    return Scaffold(
      body: () {
        if (commentsState.isLoading) {
          return const InlineLoadingWidget();
        } else if (commentsState.hasError) {
          return CustomErrorWidget(
            onTap: () {
              ref.invalidate(commentsProvider);
            },
          );
        } else {
          return Container(
            height: context.screenSize.height * 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    S.of(context).CommentsWidget_commentsTitle,
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: commentsState.comments.isEmpty
                      ? Center(
                          child:
                              Text(S.of(context).CommentsWidget_noCommentsText))
                      : ListView.builder(
                          itemCount: commentsState.comments.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundImage: commentsState
                                        .comments[index].user.imageUrl.isEmpty
                                    ? getDefaultProfilePicByAccountType(
                                        commentsState.comments[index].user
                                            .accontType) as ImageProvider
                                    : CachedNetworkImageProvider(commentsState
                                        .comments[index].user.imageUrl),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    ' ${commentsState.comments[index].user.getLocalizedFullName(ref)}@ - ',
                                    style: context.textTheme.titleSmall,
                                  ),
                                  Text(
                                    timeago.format(
                                      commentsState.comments[index].createdAt,
                                      locale: ref
                                          .watch(appLanguageProvider)
                                          .languageCode,
                                    ),
                                    style: context.textTheme.bodySmall!
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                commentsState.comments[index].commentText,
                                style: context.textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: userModel.imageUrl.isEmpty
                            ? getDefaultProfilePicByAccountType(
                                userModel.accontType) as ImageProvider
                            : CachedNetworkImageProvider(userModel.imageUrl),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            controller: commentConroller,
                            decoration: InputDecoration(
                              hintText:
                                  S.of(context).CommentsWidget_addCommentHint,
                              hintStyle: context.textTheme.bodyMedium,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    if (commentConroller.text
                                        .trim()
                                        .isNotEmpty) {
                                      final commentModel = CommentModel(
                                          commentText: commentConroller.text,
                                          user: userModel,
                                          createdAt: DateTime.now());
                                      commentConroller.clear();
                                      ref
                                          .read(commentsProvider.notifier)
                                          .addComment(
                                              widget.postId,
                                              commentModel,
                                              widget.postUser,
                                              postsHost);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  )),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 15),
                              fillColor: const Color(
                                0XFFD9D9D9,
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: const BorderSide(
                                    color: Color(
                                  0XFFD9D9D9,
                                )),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(
                                  0XFFD9D9D9,
                                )),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(
                                  0XFFD9D9D9,
                                )),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      }.call(),
    );
  }
}

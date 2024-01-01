import 'dart:io';
import 'package:flutter/material.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/features/posts/posts.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

import '../../../search/providers/search_state_providers.dart';

class NewPostView extends StatefulHookConsumerWidget {
  const NewPostView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPostViewState();
}

class _NewPostViewState extends ConsumerState<NewPostView> {
  List<File> postAttachments = [];
  void _listenToRequestResponse(WidgetRef ref) {
    ref.listen(
      requestResponseProvider,
      (_, state) {
        state.whenOrNull(
          sucess: (_, __) {
            context.pop();
            context.showSnackbarSuccess(
                S.of(context).NewPostView_successSnackbarText);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _listenToRequestResponse(ref);
    final userModel = ref.read(currentUserProfileProvider);

    final descriptionController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).NewPostView_appBarTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClinigramButton(
              onPressed: () {
                if (descriptionController.text.trim().isEmpty ||
                    postAttachments.isEmpty ||
                    ref.read(selectedSubCategoryProvider) == null ||
                    ref.read(selectedMainCategoryProvider) == null) {
                  context.showSnackbarError(
                      S.of(context).NewPostView_errorSnackbarText);
                } else {
                  ref.read(createPostProvider.notifier).createNewPost(
                      descriptionController.text, postAttachments, userModel);
                }
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(120, 30)),
              child: Text(
                S.of(context).NewPostView_publishButtonText,
                style: context.textTheme.titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: context.screenSize.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                CategorySection(
                  layoutType: CategorySectionLayout.horizontal,
                  mainCategory: userModel.specialists.isNotEmpty
                      ? userModel.specialists.first
                      : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    pickAttatchment(context);
                  },
                  child: DottedBorder(
                    color: const Color(0xFF6799FF),
                    borderType: BorderType.Rect,
                    dashPattern: const [5, 5],
                    radius: const Radius.circular(20),
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 30),
                      width: context.screenSize.width,
                      color: const Color(0xFF6799FF).withOpacity(0.2),
                      child: Column(
                        children: [
                          Image.asset(
                            uploadIcon,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              S.of(context).NewPostView_loadImageButtonText,
                              style: context.textTheme.titleMedium!
                                  .copyWith(color: const Color(0xFF6799FF)),
                            ),
                          ),
                          Text(
                            postAttachments.length == 3
                                ? S.of(context).NewPostView_loadImageMaxText
                                : S.of(context).NewPostView_loadImageFormatText,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleMedium!
                                .copyWith(color: const Color(0xFF6799FF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    runSpacing: 0,
                    spacing: 10,
                    direction: Axis.horizontal,
                    children: [
                      for (int i = 0; i < postAttachments.length; i++)
                        SizedBox(
                          width: 120,
                          height: 100,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  postAttachments[i],
                                  width: 120,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    postAttachments.remove(postAttachments[i]);
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                ClinigramTextField(
                  hintText: S.of(context).NewPostView_addDescriptionHint,
                  controller: descriptionController,
                  maxLines: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickAttatchment(BuildContext context) async {
    const int maxImageSize = 10;
    FilePickerResult? result;
    if (postAttachments.length != 3) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.media,
      );
    }

    if (result != null) {
      final file = result.files.single;
      final fileSize = file.size / (1024 * 1024);
      if (postAttachments.length != 3) {
        if (fileSize <= maxImageSize) {
          postAttachments.add(File(result.files.single.path!));
          setState(() {});
        } else {
          if (mounted) {
            context
                .showSnackbarError(S.of(context).NewPostView_loadImageSizeText);
          }
        }
      } else {
        if (mounted) {
          context.showSnackbarError(
              S.of(context).NewPostView_imageLimitExceededText);
        }
      }
    }
  }
}

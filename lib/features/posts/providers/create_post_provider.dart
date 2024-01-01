import 'dart:io';

import 'package:clinigram_app/features/search/providers/search_state_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../profile/profile.dart';
import '../posts.dart';

class CreatePostNotifier extends StateNotifier<PostModel?> {
  CreatePostNotifier(this._ref) : super(null);
  final Ref _ref;
  createNewPost(String postDescription, List<File> postAttatchments,
      UserModel userModel) async {
    try {
      PostModel postModel = PostModel(
        id: '',
        userModel: userModel,
        attatchments: [],
        description: postDescription,
        cityId: userModel.cityModel?.id ?? '',
        mainCategory: _ref.read(selectedMainCategoryProvider)!,
        subCategory: _ref.read(selectedSubCategoryProvider)!,
        createdAt: DateTime.now(),
      );
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      if (postAttatchments.isNotEmpty) {
        final attatchments = await uploadImages(postAttatchments);
        postModel = postModel.copyWith(attatchments: attatchments);
      }
      await _ref.read(postsRepoProvider).newPost(postModel);
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }

  Future<List<String>> uploadImages(List<File> images) async {
    var imageUrls = await Future.wait(images
        .map((image) => uploadFileToFirebase(image, postsImagesCollection)));
    return imageUrls;
  }
}

final createPostProvider =
    StateNotifierProvider<CreatePostNotifier, PostModel?>((ref) {
  return CreatePostNotifier(ref);
});

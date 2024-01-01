import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../profile.dart'; // Import your profile-related code here

class RateProvider extends StateNotifier<List<RatingModel>> {
  RateProvider(this._ref, String userId) : super([]) {
    if (userId.isNotEmpty) {
      _getRatingsForProfile(userId);
    }
  }

  final Ref _ref;

  Future<void> _getRatingsForProfile(String userId) async {
    try {
      final ratings =
          await _ref.read(profileRepoProvider).getRatingsForProfile(userId);
      state = ratings;
    } catch (e) {
      //state = [];
      // Handle the error as needed
    }
  }

  Future<void> addRatingAndComment(RatingModel rating, String userID) async {
    try {
      await _ref.read(profileRepoProvider).addRatingAndComment(rating, userID);
      // Optionally, update the local state if needed
    } catch (e) {
      // Handle the error as needed
    }
  }

  Future<int> getRatingsLengthForProfile(String userID) async {
    try {
      final length = await _ref
          .read(profileRepoProvider)
          .getRatingsLengthForProfile(userID);
      return length;
    } catch (e) {
      // Handle the error as needed
      return 0;
    }
  }

  bool isRated(String userID) {
    RatingModel rate;
    for (rate in state) {
      if (rate.userId == userID) {
        return true;
      }
    }
    return false;
  }
}

final rateProviderProvider = StateNotifierProvider.autoDispose
    .family<RateProvider, List<RatingModel>, String>((ref, userId) {
  return RateProvider(ref, userId);
});

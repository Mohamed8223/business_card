import 'package:freezed_annotation/freezed_annotation.dart';

import '../../profile.dart';

part 'followers_followings_model.freezed.dart';
part 'followers_followings_model.g.dart';

@freezed
class FollowersFollowingsModel with _$FollowersFollowingsModel {
  factory FollowersFollowingsModel(
      {@Default([]) List<UserModel> followers,
      @Default([]) List<UserModel> followings}) = _FollowersFollowingsModel;

  factory FollowersFollowingsModel.fromJson(Map<String, dynamic> json) =>
      _$FollowersFollowingsModelFromJson(json);
}

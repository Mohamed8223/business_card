import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/core/constants/fixed_assets.dart';
import 'package:clinigram_app/core/constants/keys_enums.dart';
import 'package:clinigram_app/features/profile/data/models/user_model.dart';
import 'package:clinigram_app/features/profile/providers/current_user_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

AssetImage getDefaultProfilePic(WidgetRef ref) {
  final userData = ref.watch(currentUserProfileProvider);
  return getDefaultProfilePicByAccountType(
      userData.accontType ?? AccontType.user);
}

AssetImage getDefaultProfilePicByAccountType(AccontType? accountType) {
  if (accountType == AccontType.doctor) {
    return const AssetImage(
      doctorProfileImage,
    );
  }

  return const AssetImage(
    userProfileImage,
  );
}

AssetImage getDefaultProfilePicByAccountTypeString(String accountType) {
  if (accountType == "doctor") {
    return const AssetImage(
      doctorProfileImage,
    );
  }

  return const AssetImage(
    userProfileImage,
  );
}

ImageProvider getDefaultProfilePicForUser(UserModel userModel) {
  if (userModel.imageUrl.isNotEmpty) {
    return CachedNetworkImageProvider(userModel.imageUrl);
  }

  if (userModel.accontType == AccontType.doctor) {
    return const AssetImage(
      doctorProfileImage,
    );
  }

  return const AssetImage(
    userProfileImage,
  );
}

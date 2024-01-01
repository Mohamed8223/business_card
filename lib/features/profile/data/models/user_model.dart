import 'package:clinigram_app/features/admin_manage/data/models/category_model.dart';
import 'package:clinigram_app/features/admin_manage/data/models/city_model.dart';
import 'package:clinigram_app/features/chats/chats.dart';
import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();
  const factory UserModel({
    required String id,
    required String fullnameAr,
    @Default('') String fullnameEn,
    @Default('') String fullnameHe,
    required String phone,
    required String email,
    CityModel? cityModel,
    @Default(false) bool isActive,
    @Default(false) bool certificationsVerified,
    @Default('') String imageUrl,
    AccontType? accontType,
    String? fcmToken,
    @Default([]) List<CategoryModel> specialists,
    @Default([]) List<String> doctorAgreement,
    @Default(Gender.male) Gender gender,
    @Default(false) bool profileCompleted,
    DoctorJob? doctorJob,
    String? createdBy,
    @Default([]) List<UserModel> followers,
    @Default([]) List<UserModel> followings,
    @Default('') String aboutMe,
    @Default([]) List<String> agreementsWithInsurance,
    @Default([]) List<String> roles,
    @Default(0) int yearsOfExperience,
    @Default([]) List<RatingModel> ratings,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel.fromJson(data).copyWith(
        id: doc.id, accontType: stringToAccountType(data['accont_type']));
  }
  factory UserModel.init() => const UserModel(
      id: '',
      fullnameAr: '',
      phone: '',
      email: '',
      imageUrl: '',
      isActive: true,
      aboutMe: '',
      yearsOfExperience: 0,
      agreementsWithInsurance: []);

  Map<String, dynamic> toDocument({bool excludeLists = false}) {
    final jsonMap = toJson();

    if (excludeLists) {
      jsonMap.remove('followers');
      jsonMap.remove('followings');
    }

    return jsonMap;
  }

  String getLocalizedFullName(WidgetRef ref) {
    if (ref.watch(appLanguageProvider) == const Locale('ar')) {
      if (fullnameAr != '') return fullnameAr;
    } else if (ref.watch(appLanguageProvider) == const Locale('he')) {
      if (fullnameHe != '') return fullnameHe;
    } else if (ref.watch(appLanguageProvider) == const Locale('en')) {
      if (fullnameEn != '') return fullnameEn;
    }

    // return availalbe
    if (fullnameEn != '') {
      return fullnameEn;
    } else if (fullnameHe != '') {
      return fullnameHe;
    } else if (fullnameAr != '') {
      return fullnameAr;
    } else {
      return '';
    }
  }

  List<String> getSpecialistsByLanguage(List<CategoryModel> categories,
      WidgetRef ref, CategoryType categoryType) {
    List<String> names = [];

    for (var category in categories) {
      for (var subCategory in category.subCategories) {
        if (subCategory.categoryType != categoryType) {
          continue;
        }

        if (ref.watch(appLanguageProvider) == const Locale('ar')) {
          names.add(subCategory.nameAr);
        } else if (ref.watch(appLanguageProvider) == const Locale('he')) {
          names.add(subCategory.nameHe);
        } else if (ref.watch(appLanguageProvider) == const Locale('en')) {
          names.add(subCategory.nameEn);
        }
      }
    }

    return names;
  }

  UserModel addRating(RatingModel rating) {
    final updatedRatings = List<RatingModel>.from(ratings)..add(rating);
    return copyWith(ratings: updatedRatings);
  }

  List<RatingModel> getRatings() {
    return List<RatingModel>.from(ratings);
  }

  String getProffessionName(List<CategoryModel> categories, WidgetRef ref) {
    List<String> names = [];

    for (var category in categories) {
      if (ref.watch(appLanguageProvider) == const Locale('ar')) {
        names.add(category.nameAr);
      } else if (ref.watch(appLanguageProvider) == const Locale('he')) {
        names.add(category.nameHe);
      } else if (ref.watch(appLanguageProvider) == const Locale('en')) {
        names.add(category.nameEn);
      }
    }

    return names.join(', ');
  }

  ChatMemberModel toChatMemeber() => ChatMemberModel(
        id: id,
        accountType: accontType!.name,
        fullnameAr: fullnameAr,
        fullnameEn: fullnameEn,
        fullnameHe: fullnameHe,
        imageUrl: imageUrl,
      );

  // ignore: hash_and_equals
  @override
  bool operator ==(Object other) {
    return (other is UserModel) && other.id == id;
  }
}

@freezed
class UserModelState with _$UserModelState {
  const UserModelState._();
  const factory UserModelState({
    required UserModel? user,
    @Default('') String error,
    @Default(true) bool isLoading,
  }) = _UserModelState;
  factory UserModelState.init() => const UserModelState(user: null);
  bool get hasError => error.isNotEmpty;
  factory UserModelState.fromJson(Map<String, dynamic> json) =>
      _$UserModelStateFromJson(json);
}

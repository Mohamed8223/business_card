import 'package:clinigram_app/features/clinics/data/models/clinic_staff_model.dart';
import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:clinigram_app/features/profile/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/core/constants/keys_enums.dart';

import '../../../../core/models/geo_location_model.dart';
import '../../../admin_manage/data/models/category_model.dart';
import '../../../admin_manage/data/models/city_model.dart';
import '../../../translation/provider/app_language_provider.dart';

part 'clinic_model.freezed.dart';
part 'clinic_model.g.dart';

@freezed
class ClinicModel with _$ClinicModel {
  const ClinicModel._();
  factory ClinicModel({
    @Default('') String id,
    required String nameAr,
    required String nameEn,
    required String nameHe,
    @Default('') String description,
    @Default('') String imageUrl,
    @Default('') String phone,
    @Default('') String email,
    CityModel? cityModel,
    @GeoPointConverter() GeoPoint? location,
    @Default('') String address,
    @Default([]) List<CategoryModel> specialists,
    @Default([]) List<String> ownerIds,
    @Default([]) List<String> staffIds,
    @Default([]) List<ClinicStaffModel> staff,
    @Default([]) List<String> agreementsWithInsurance,
    @Default([]) List<String> doctorAgreement,
    @Default([]) List<String> followers,
    @Default(true) bool isActive,
    @Default(false) bool certificationsVerified,
    @Default([]) List<RatingModel> ratings,
    ClinicJob? clinicJob,
  }) = _ClinicModel;

  factory ClinicModel.fromJson(Map<String, dynamic> json) =>
      _$ClinicModelFromJson(json);

  String getLocalizedFullName(WidgetRef ref) {
    if (ref.watch(appLanguageProvider) == const Locale('ar')) {
      if (nameAr != '') return nameAr;
    } else if (ref.watch(appLanguageProvider) == const Locale('he')) {
      if (nameHe != '') return nameHe;
    } else if (ref.watch(appLanguageProvider) == const Locale('en')) {
      if (nameEn != '') return nameEn;
    }

    // return availalbe
    if (nameEn != '') {
      return nameEn;
    } else if (nameHe != '') {
      return nameHe;
    } else if (nameAr != '') {
      return nameAr;
    } else {
      return '';
    }
  }

  factory ClinicModel.init() => ClinicModel(
      id: '',
      nameAr: '',
      imageUrl: '',
      nameEn: '',
      nameHe: '',
      description: '',
      ownerIds: [],
      staff: [],
      specialists: [],
      cityModel: null,
      location: null);
}

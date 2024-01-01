import 'dart:ui';

import 'package:clinigram_app/features/admin_manage/admin_manage.dart';
import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/category_model.dart';

extension CategoryModelExtension on CategoryModel {
  String getLocalizedName(WidgetRef ref) {
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
}

extension CityModelExtension on CityModel {
  String getLocalizedName(WidgetRef ref) {
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
}

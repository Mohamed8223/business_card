import 'dart:ui';

import 'package:clinigram_app/features/translation/provider/app_language_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/chat_member_model.dart';

extension ChatMemberModelExtension on ChatMemberModel {
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
}

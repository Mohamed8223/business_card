import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/widgets.dart' show BuildContext;

mixin ValidationMixin {
  String? emailValidation(String? val, BuildContext context) {
    if (val == null || val.isEmpty) {
      return S.current.ValidationMixin_This_field_is_required;
    }
    const emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
    if (!RegExp(emailRegExpString, caseSensitive: false).hasMatch(val)) {
      return S.current.ValidationMixin_Invalid_email_address;
    }
    return null;
  }

  String? passwordValidation(String? val, BuildContext context) {
    if (val!.trim().isEmpty) {
      return S.current.ValidationMixin_This_field_is_required;
    }
    if (val.length < 6) {
      return S
          .current.ValidationMixin_Password_must_be_at_least_6_characters_long;
    }
    if (val.length > 18) {
      return S.current.ValidationMixin_Password_must_be_less_than_18_characters;
    }
    return null;
  }

  String? phoneValidation(String? val, BuildContext context) {
    if (val!.trim().isEmpty) {
      return S.current.ValidationMixin_This_field_is_required;
    }
    if (val.length < 9) {
      return S.current.ValidationMixin_the_PhoneNum_9;
    }
    if (val.length == 10 && !val.startsWith('0')) {
      return S.current.ValidationMixin_the_PhoneNum_9;
    }
    if (val.length > 10) {
      return S.current.ValidationMixin_the_PhoneNum_9;
    }
    return null;
  }

  String? fullNameValidation(String? val, BuildContext context) {
    if (val!.length < 4) {
      return S.current.ValidationMixin_Name_must_be_at_least_8_characters_long;
    } else if (val.length > 20) {
      return S.current.ValidationMixin_Name_must_not_exceed_20_characters;
    }
    return null;
  }

  String? usernameValidation(String? val, BuildContext context) {
    if (val!.length < 4) {
      return S.current.ValidationMixin_Name_must_be_at_least_4_characters_long;
    }
    return null;
  }

  String? passwordConValidation(
    String? val,
    String password,
    BuildContext context,
  ) {
    if (val!.trim().isEmpty) {
      return S.current.ValidationMixin_This_field_is_required;
    }
    if (val.length < 6) {
      return S.current
          .ValidationMixin_Password_Confirm_must_be_at_least_6_characters;
    }
    if (val != password) {
      return S.current.ValidationMixin_Password_does_not_match;
    }
    return null;
  }

  String? emptyValidation(
    String? val,
    BuildContext context,
  ) {
    if (val!.trim().isEmpty) {
      return S.current.ValidationMixin_This_field_is_required;
    }

    return null;
  }

  String? locationValidation(String? location) {
    if (location == null) {
      return S.current.ValidationMixin_This_field_is_required;
    } else {
      try {
        String latPattern = r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$';
        RegExp latRegex = RegExp(latPattern);
        String langPattern =
            r'^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$';
        RegExp langRegex = RegExp(langPattern);
        String formateLocation =
            location.replaceAll('(', '').replaceAll(')', '');
        double lat =
            double.parse(formateLocation.split(',').first.replaceAll(' ', ''));
        double lang =
            double.parse(formateLocation.split(',').last.replaceAll(' ', ''));
        return latRegex.hasMatch(lat.toString()) &&
                langRegex.hasMatch(lang.toString())
            ? null
            : S.current.ValidationMixin_Invalid_location_data;
      } catch (e) {
        return S.current.ValidationMixin_Invalid_location_data;
      }
    }
  }
}

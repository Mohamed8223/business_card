import 'package:clinigram_app/features/auth/providers/account_type_provider.dart';
import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/clinics/data/repositries/clinics_repo.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../admin_manage/admin_manage.dart';
import '../../../profile/profile.dart';
import '../../../translation/data/generated/l10n.dart';

class PersonalRegister extends HookConsumerWidget with ValidationMixin {
  final bool isPreRegister;
  final GlobalKey formKey;

  const PersonalRegister(
      {required this.formKey, required this.isPreRegister, super.key});

  String arabicToEnglish(String arabicNumber) {
    // Define a map that maps Arabic numerals to their English equivalents
    Map<String, String> numeralMap = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9'
    };

    // Convert each Arabic numeral to its English equivalent and join them
    String englishNumber = arabicNumber.split('').map((digit) {
      return numeralMap[digit] ?? digit;
    }).join('');

    return englishNumber;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Take the other user data from the register user provider.
    final userData = ref.watch(registerUserProvider);

    final AccontType accontType = isPreRegister
        ? AccontType.doctor
        : ref.read(accountTypeProvider) ?? AccontType.user;

    final nameAr = useTextEditingController(text: userData.fullnameAr);
    final nameEn = useTextEditingController(text: userData.fullnameEn);
    final nameHe = useTextEditingController(text: userData.fullnameHe);

    String purePhoneNumber = userData.phone;

    var readOnlyPhoneNumber = useState(false);

    if (!isPreRegister) {
      // Take the phone number from the verified user model.
      final currUserModel = ref.read(currentUserProfileProvider);

      purePhoneNumber =
          currUserModel.phone.isEmpty ? userData.phone : currUserModel.phone;

      readOnlyPhoneNumber.value = true;
    }

    if (purePhoneNumber.isNotEmpty && purePhoneNumber.startsWith('+')) {
      // remove the country code
      purePhoneNumber = purePhoneNumber.substring(5); // '+972 '
    }

    final phone = useTextEditingController(text: purePhoneNumber);
    final email = useTextEditingController(text: userData.email);
    CityModel? cityModel = userData.cityModel;
    Gender gender = userData.gender;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: ProfileImagePicker(
                      currentImage: userData.imageUrl,
                      onImagePicked: (image) {
                        ref
                            .read(registerUserProvider.notifier)
                            .update((state) => state.copyWith(
                                  imageUrl: image?.path ?? '',
                                ));
                      }),
                ),
                const SizedBox(
                  height: 40,
                ),
                if (accontType == AccontType.doctor) ...[
                  ClinigramTextField(
                      hintText: S.of(context).DoctorPersonalInfo_Arabic_Name,
                      controller: nameAr,
                      validator: (name) => usernameValidation(name, context),
                      onComplete: (_) {
                        ref.read(registerUserProvider.notifier).update(
                              (state) => state.copyWith(
                                  fullnameAr: nameAr.text.trim()),
                            );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ClinigramTextField(
                      hintText: S.of(context).DoctorPersonalInfo_English_Name,
                      controller: nameEn,
                      validator: (nameEn) =>
                          usernameValidation(nameEn, context),
                      onComplete: (_) {
                        ref.read(registerUserProvider.notifier).update(
                              (state) => state.copyWith(
                                  fullnameEn: nameEn.text.trim()),
                            );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ClinigramTextField(
                      hintText: S.of(context).DoctorPersonalInfo_Hebrew_Name,
                      controller: nameHe,
                      validator: (nameHe) =>
                          usernameValidation(nameHe, context),
                      onComplete: (_) {
                        ref.read(registerUserProvider.notifier).update(
                              (state) => state.copyWith(
                                  fullnameHe: nameHe.text.trim()),
                            );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
                if (accontType != AccontType.doctor) ...[
                  ClinigramTextField(
                      hintText: S.of(context).UpdateProfileView_Name,
                      controller: nameEn,
                      validator: (nameEn) =>
                          usernameValidation(nameEn, context),
                      onComplete: (_) {
                        ref.read(registerUserProvider.notifier).update(
                              (state) => state.copyWith(
                                  fullnameEn: nameEn.text.trim()),
                            );
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
                PhoneTextField(
                    readOnly: readOnlyPhoneNumber.value,
                    controller: phone,
                    onCompleted: (value) {
                      ref.read(registerUserProvider.notifier).update(
                            (state) => state.copyWith(phone: value),
                          );
                    }),
                const SizedBox(
                  height: 20,
                ),
                ClinigramTextField(
                  // readOnly: email.text.isNotEmpty,
                  hintText: S.of(context).DoctorPersonalInfo_Email,
                  textInputType: TextInputType.emailAddress,
                  validator: (email) {
                    if (email == null || email.trim().isEmpty) {
                      return null; // optional. no error message will be shown
                    }
                    return emailValidation(email, context);
                  },
                  controller: email,
                  onComplete: (value) =>
                      ref.read(registerUserProvider.notifier).update(
                            (state) => state.copyWith(email: value.trim()),
                          ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CityDropDown(
                    value: cityModel,
                    onChanged: (selectedCity) {
                      cityModel = selectedCity;
                      ref.read(registerUserProvider.notifier).update(
                          (state) => state.copyWith(cityModel: selectedCity));
                    }),
                const SizedBox(
                  height: 20,
                ),
                GenderSelector(
                  currentGender: gender,
                  onChanged: (value) {
                    gender = value;

                    ref
                        .read(registerUserProvider.notifier)
                        .update((state) => state.copyWith(gender: value));
                  },
                ),
              ],
            )),
      ),
    );
  }
}

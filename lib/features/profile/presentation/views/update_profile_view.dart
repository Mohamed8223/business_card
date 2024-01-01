// import 'package:clinigram_app/features/admin_manage/data/models/city_model.dart';
// import 'package:clinigram_app/features/auth/auth.dart';
// import 'package:clinigram_app/features/main/main_layout.dart';
// import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../core/core.dart';
// import '../../profile.dart';
//
// class UpdateProfileView extends HookConsumerWidget with ValidationMixin {
//   const UpdateProfileView({super.key, this.fromOtp = false});
//   final bool fromOtp;
//   String arabicToEnglish(String arabicNumber) {
//     // Define a map that maps Arabic numerals to their English equivalents
//     Map<String, String> numeralMap = {
//       '٠': '0',
//       '١': '1',
//       '٢': '2',
//       '٣': '3',
//       '٤': '4',
//       '٥': '5',
//       '٦': '6',
//       '٧': '7',
//       '٨': '8',
//       '٩': '9'
//     };
//
//     // Convert each Arabic numeral to its English equivalent and join them
//     String englishNumber = arabicNumber.split('').map((digit) {
//       return numeralMap[digit] ?? digit;
//     }).join('');
//
//     return englishNumber;
//   }
//
//   // int storeYearsInRightForm(String userInput) {
//   //   DateTime now = DateTime.now();
//   //   int eYears = int.parse(arabicToEnglish(userInput));
//   //   int currentYear = now.year;
//   //   int storedYears = currentYear - eYears;
//
//   //   return storedYears;
//   // }
//
//   // String displayedYears(int storedYears) {
//   //   DateTime now = DateTime.now();
//   //   return (now.year - storedYears).toString();
//   // }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.listen(requestResponseProvider, (previous, next) {
//       next.whenOrNull(
//         sucess: (message, addtionalData) {
//           if (fromOtp) {
//             context.pushAndRemoveOthers(const MainLayout());
//           } else {
//             context.pop();
//           }
//           context.showSnackbarSuccess(
//               S.of(context).UpdateProfileView_Updated_message);
//         },
//       );
//     });
//     final userModel = ref.read(currentUserProfileProvider);
//     final fullnameController =
//         useTextEditingController(text: userModel.getLocalizedFullName(ref));
//
//     final phone = userModel.phone;
//     var purePhoneNumber = phone;
//     if (purePhoneNumber.isNotEmpty && purePhoneNumber.startsWith('+')) {
//       // remove the country code
//       purePhoneNumber = purePhoneNumber.substring(5); // '+972 '
//     }
//
//     final phoneController = useTextEditingController(text: purePhoneNumber);
//     final emailController = useTextEditingController(text: userModel.email);
//     final aboutmeController = useTextEditingController(text: userModel.aboutMe);
//     final yofexperienceController = useTextEditingController();
//
//     Gender userGender = userModel.gender;
//     CityModel? city;
//
//     int yearOfExeperince = userModel.yearsOfExperience;
//
//     useEffect(() {
//       fullnameController.text = userModel.fullnameAr;
//       phoneController.text = purePhoneNumber;
//       emailController.text = userModel.email;
//
//       city = userModel.cityModel;
//       return null;
//     }, [ref, userModel]);
//
//     final formKey = GlobalKey<FormState>();
//     XFile? pickedProfileImage;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(fromOtp
//             ? S.of(context).UpdateProfileView_Complete_Profile
//             : S.of(context).UpdateProfileView_Edit_Profile),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Form(
//             key: formKey,
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 ProfileImagePicker(
//                     currentImage: null,
//                     onImagePicked: (image) {
//                       pickedProfileImage = image;
//                     }),
//                 const SizedBox(
//                   height: 40,
//                 ),
//                 ClinigramTextField(
//                   hintText: S.of(context).UpdateProfileView_Name,
//                   controller: fullnameController,
//                   readOnly: userModel.fullnameAr.isNotEmpty,
//                   validator: (val) => fullNameValidation(val, context),
//                 ),
//                 if (userModel.accontType == AccontType.doctor) ...[
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   TextField(
//                     controller: aboutmeController,
//                     decoration: InputDecoration(
//                       hintText: S.of(context).CurrentUserProfileView_about_me,
//                       labelText: S.of(context).CurrentUserProfileView_about_me,
//                       hintStyle: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 5, horizontal: 10),
//                       fillColor: Colors.white,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                             color: context.theme.colorScheme.primary),
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: context.theme.colorScheme.primary),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: context.theme.colorScheme.primary),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.red),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ],
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 if (userModel.accontType == AccontType.doctor) ...[
//                   TextField(
//                     controller: yofexperienceController,
//                     decoration: InputDecoration(
//                       hintText: S
//                           .of(context)
//                           .CurrentUserProfileView_Years_of_Experience,
//                       labelText: S
//                           .of(context)
//                           .CurrentUserProfileView_Years_of_Experience,
//                       hintStyle: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 5, horizontal: 10),
//                       fillColor: Colors.white,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                             color: context.theme.colorScheme.primary),
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: context.theme.colorScheme.primary),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: context.theme.colorScheme.primary),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.red),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//                 userModel.phone.isEmpty
//                     ? ClinigramTextField(
//                         readOnly: true,
//                         hintText: S.of(context).UpdateProfileView_Email,
//                         controller: emailController,
//                         validator: (val) => emailValidation(val, context),
//                       )
//                     : PhoneTextField(
//                         readOnly: true,
//                         controller: phoneController,
//                       ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 CityDropDown(
//                     value: city,
//                     onChanged: (selectedCity) {
//                       city = selectedCity;
//                     }),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 GenderSelector(
//                   currentGender: userModel.gender,
//                   onChanged: (value) {
//                     userGender = value;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ClinigramButton(
//                     onPressed: () {
//                       if (yofexperienceController.text.isNotEmpty) {
//                         yearOfExeperince = int.parse(
//                             arabicToEnglish(yofexperienceController.text));
//                       }
//                       if (formKey.currentState!.validate()) {
//                         if (city == null) {
//                           context.showSnackbarError(
//                               S.of(context).UpdateProfileView_chose_city);
//                         } else {
//                           final model = userModel.copyWith(
//                               fullnameAr: fullnameController.text,
//                               phone: phoneController.text,
//                               email: emailController.text,
//                               cityModel: city,
//                               imageUrl: pickedProfileImage?.path ?? '',
//                               gender: userGender,
//                               accontType: AccontType.user,
//                               aboutMe: aboutmeController.text,
//                               yearsOfExperience: yearOfExeperince,
//                               profileCompleted: true);
//                           if (fromOtp) {
//                             ref.read(authProvider.notifier).registerUser(model);
//                           } else {
//                             ref
//                                 .read(currentUserProfileProvider.notifier)
//                                 .updateUserProfile(
//                                   model,
//                                 );
//                           }
//                         }
//                       }
//                     },
//                     child: Text(
//                       S.of(context).UpdateProfileView_Save,
//                       style: context.textTheme.titleMedium!
//                           .copyWith(color: Colors.white),
//                     )),
//                 const SizedBox(
//                   height: 50,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

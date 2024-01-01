import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/admin_manage/data/models/city_model.dart';
import 'package:clinigram_app/features/auth/providers/register_user_provider.dart';
import 'package:clinigram_app/features/clinics/data/repositries/clinics_repo.dart';
import 'package:clinigram_app/features/clinics/presentation/widgets/cover_image_picker.dart';
import 'package:clinigram_app/features/doctors/providers/register_clinic_provider.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// For web
import 'package:clinigram_app/core/utils/location_web.dart'
    if (dart.library.io) 'package:clinigram_app/core/utils/location_mobile.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/clinic_model.dart';

// To be used in register clinic view
class AddClinicBasicForm extends HookConsumerWidget with ValidationMixin {
  AddClinicBasicForm({required this.formKey, super.key});

  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    final isClinicOwner = ref.watch(isClinicOwnerInEditViewProvider);

    late final TextEditingController nameEnController,
        locationController,
        addressController;

    final userData = ref.watch(registerUserProvider);
    ClinicModel clinicModel = ref.read(registerClinicProvider);

    CityModel? cityModel = clinicModel.cityModel == null
        ? userData.cityModel
        : clinicModel.cityModel!;

    nameEnController = useTextEditingController(text: clinicModel.nameEn);
    addressController = useTextEditingController(text: clinicModel.address);

    locationController = useTextEditingController(
        text: clinicModel.location != null
            ? '${clinicModel.location!.latitude},${clinicModel.location!.longitude}'
            : '');

    XFile? pickedImage;

    void useCurrentLocation() async {
      getCurrentPositionImpl((lat, lng) {
        locationController.text = '$lat, $lng';

        ref.read(registerClinicProvider.notifier).update(
              (state) => state.copyWith(
                  location: getGeopointFrommText(locationController.text)),
            );
      }, (errorMessage) {
        printDebug('Error getting position: $errorMessage');
      });
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'هذه الصفحة مخصصة لأصحاب العيادات لتسجيل تفاصيل عياداتهم.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            ListTile(
              title: Text(S.of(context).Do_you_own_clinic),
              trailing: Switch(
                value: isClinicOwner,
                onChanged: (value) {
                  ref.read(isClinicOwnerInEditViewProvider.notifier).update(
                        (state) => state = value,
                      );
                },
              ),
            ),
            if (isClinicOwner) ...[
              const SizedBox(height: 8),
              const Divider(), // Line separator
              const SizedBox(height: 8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: CoverImagePicker(
                    currentImage: clinicModel.imageUrl,
                    isClinicImage: true,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(50)),
                    onImagePicked: (image) {
                      pickedImage = image;
                      debugPrint('Picked image: $pickedImage');
                      ref
                          .read(registerClinicImageProvider.notifier)
                          .update((state) => state = pickedImage!);
                    }),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClinigramTextField(
                          hintText: S.of(context).UpdateProfileView_Name,
                          controller: nameEnController,
                          validator: (name) {
                            if (!isClinicOwner) return null;
                            return emptyValidation(name, context);
                          },
                          onComplete: (_) {
                            ref.read(registerClinicProvider.notifier).update(
                                  (state) => state.copyWith(
                                      nameEn: nameEnController.text.trim(),
                                      nameAr: nameEnController.text.trim(),
                                      nameHe: nameEnController.text.trim()),
                                );
                          }),
                      //
                      //
                      const SizedBox(height: 20),
                      //
                      //
                      CityDropDown(
                          value: cityModel,
                          onChanged: (selectedCity) {
                            cityModel = selectedCity;
                            ref.read(registerClinicProvider.notifier).update(
                                  (state) =>
                                      state.copyWith(cityModel: cityModel),
                                );
                          }),
                      //
                      //
                      const SizedBox(height: 20),
                      ClinigramTextField(
                          hintText: "العنوان الكامل",
                          controller: addressController,
                          validator: (address) {
                            if (!isClinicOwner) return null;
                            return emptyValidation(address, context);
                          },
                          onComplete: (_) {
                            ref.read(registerClinicProvider.notifier).update(
                                  (state) => state.copyWith(
                                      address: addressController.text.trim()),
                                );
                          }),
                      const SizedBox(height: 20),
                      //
                      //
                      Row(
                        children: [
                          Expanded(
                            child: ClinigramTextField(
                                hintText: S
                                    .of(context)
                                    .ClicnkInfoView_Location_Coordinates_on_Map,
                                controller: locationController,
                                validator: (location) {
                                  if (!isClinicOwner) return null;
                                  if (location == null ||
                                      location.trim().isEmpty) {
                                    return null; // optional. no error message will be shown
                                  }
                                  return locationValidation(location);
                                },
                                onComplete: (_) {
                                  ref
                                      .read(registerClinicProvider.notifier)
                                      .update(
                                        (state) => state.copyWith(
                                            location: getGeopointFrommText(
                                                locationController.text)),
                                      );
                                }),
                          ),
                          IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: useCurrentLocation,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

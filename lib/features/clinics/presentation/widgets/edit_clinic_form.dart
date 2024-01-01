import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/clinics/data/models/clinic_staff_model.dart';

import 'package:clinigram_app/features/clinics/presentation/widgets/cover_image_picker.dart';
import 'package:clinigram_app/features/clinics/providers/doctor_clinics_provider.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// For web
import 'package:clinigram_app/core/utils/location_web.dart'
    if (dart.library.io) 'package:clinigram_app/core/utils/location_mobile.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/clinic_model.dart';

class EditClinicForm extends HookConsumerWidget with ValidationMixin {
  EditClinicForm({this.clinicModel, this.localImage, super.key});

  final ClinicModel? clinicModel;
  final XFile? localImage;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.sizeOf(context);
    late final TextEditingController nameArController,
        nameEnController,
        nameHeController,
        descriptionController,
        locationController;
    UserModel userModel = ref.read(currentUserProfileProvider);
    GeoPoint? location = clinicModel != null
        ? clinicModel!.location
        : userModel.cityModel?.cityLocation;

    nameArController = useTextEditingController(text: clinicModel?.nameAr);
    nameEnController = useTextEditingController(text: clinicModel?.nameEn);
    nameHeController = useTextEditingController(text: clinicModel?.nameHe);
    descriptionController =
        useTextEditingController(text: clinicModel?.description);
    locationController = useTextEditingController(
        text: location != null
            ? '${location.latitude},${location.latitude}'
            : '');

    XFile? pickedImage;
    void useCurrentLocation() async {
      getCurrentPositionImpl((lat, lng) {
        locationController.text = '$lat, $lng';
        location = GeoPoint(lat, lng);
      }, (errorMessage) {
        printDebug('Error getting position: $errorMessage');
      });
    }

    return Container(
      height: size.height * 0.8,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: size.height * 0.25,
            child: CoverImagePicker(
                currentImage: clinicModel?.imageUrl,
                isClinicImage: true,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50)),
                onImagePicked: (image) {
                  pickedImage = image;
                }),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClinigramTextField(
                          hintText:
                              S.of(context).DoctorPersonalInfo_Arabic_Name,
                          controller: nameArController,
                          validator: (name) => emptyValidation(name, context),
                        ),
                        const SizedBox(height: 20),
                        ClinigramTextField(
                          hintText:
                              S.of(context).DoctorPersonalInfo_English_Name,
                          controller: nameEnController,
                          validator: (name) => emptyValidation(name, context),
                        ),
                        const SizedBox(height: 20),
                        ClinigramTextField(
                          hintText:
                              S.of(context).DoctorPersonalInfo_Hebrew_Name,
                          controller: nameHeController,
                          validator: (name) => emptyValidation(name, context),
                        ),
                        const SizedBox(height: 20),
                        ClinigramTextField(
                          hintText:
                              S.of(context).NewPostView_addDescriptionHint,
                          controller: descriptionController,
                          maxLines: 3,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ClinigramTextField(
                                hintText: S
                                    .of(context)
                                    .ClicnkInfoView_Location_Coordinates_on_Map,
                                controller: locationController,
                                readOnly: true,
                                validator: (location) =>
                                    locationValidation(location),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: useCurrentLocation,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ClinigramButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final ClinicModel newClinic = ClinicModel(
                      id: clinicModel != null ? clinicModel!.id : '',
                      imageUrl:
                          clinicModel != null ? clinicModel!.imageUrl : '',
                      nameAr: nameArController.text.trim(),
                      nameEn: nameEnController.text.trim(),
                      nameHe: nameHeController.text.trim(),
                      description: descriptionController.text.trim().isNotEmpty
                          ? descriptionController.text.trim()
                          : '',
                      location: getGeopointFrommText(locationController.text),
                      ownerIds: [ref.read(currentUserProfileProvider).id],
                      staff: [
                        ClinicStaffModel(
                          doctorId: ref.read(currentUserProfileProvider).id,
                          doctorApproved: true,
                        )
                      ],
                      cityModel: ref.read(currentUserProfileProvider).cityModel,
                      specialists:
                          ref.read(currentUserProfileProvider).specialists,
                    );
                    if (clinicModel != null) {
                      ref
                          .read(doctorClinicsProvider.notifier)
                          .updateClinic(newClinic, pickedImage);
                    } else {
                      ref
                          .read(doctorClinicsProvider.notifier)
                          .addClinic(newClinic, pickedImage);
                    }

                    context.pop();
                  }
                },
                child: Text(clinicModel == null
                    ? S.of(context).ClicnkInfoView_Add
                    : S.of(context).ClicnkInfoView_Save)),
          ),
        ],
      ),
    );
  }
}

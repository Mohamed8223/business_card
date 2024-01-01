import 'dart:io';

import 'package:clinigram_app/features/profile/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class CoverImagePicker extends ConsumerStatefulWidget {
  const CoverImagePicker({
    super.key,
    required this.currentImage,
    required this.onImagePicked,
    this.borderRadius = BorderRadius.zero,
    this.isUserImage = false,
    this.canEdit = true,
    this.isClinicImage = false,
  });

  final String? currentImage;
  final Function(XFile?) onImagePicked;
  final bool isUserImage;
  final bool isClinicImage;
  final bool canEdit;
  final BorderRadius? borderRadius;
  @override
  ConsumerState<CoverImagePicker> createState() => _CoverImagePickerState();
}

class _CoverImagePickerState extends ConsumerState<CoverImagePicker> {
  XFile? pickedImage;
  @override
  void initState() {
    super.initState();
  }

  Future pickImage() async {
    ImagePicker pickerServiceCoverImage = ImagePicker();
    final pickedFile =
        await pickerServiceCoverImage.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        pickedImage = pickedFile;
      });
      widget.onImagePicked(pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            image: DecorationImage(
                image: getCoverPic(ref, widget.isClinicImage),
                fit: BoxFit.cover),
          ),
        ),
        if (widget.canEdit)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Transform.translate(
              offset: const Offset(0, 20),
              child: InkWell(
                onTap: () {
                  pickImage();
                },
                child: CircleAvatar(
                  backgroundColor: context.theme.colorScheme.secondary,
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }

  ImageProvider<Object> getCoverPic(WidgetRef ref, bool isClinicImage) {
    if (pickedImage != null) {
      // For Web, use NetworkImage with a data URL
      if (kIsWeb) {
        return NetworkImage(pickedImage!.path); // This path is a URL in web
      } else {
        return FileImage(File(pickedImage!.path)); // For mobile, use FileImage
      }
    }

    if (widget.currentImage != null && widget.currentImage!.isNotEmpty) {
      return NetworkImage(widget.currentImage!);
    }

    return isClinicImage
        ? const AssetImage(clinicProfileImage)
        : getDefaultProfilePic(ref);
  }
}

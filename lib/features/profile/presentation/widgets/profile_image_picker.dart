import 'dart:io';

import 'package:clinigram_app/features/profile/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({
    super.key,
    required this.currentImage,
    required this.onImagePicked,
    this.isUserImage = false,
    this.canEdit = true,
  });
  final String? currentImage;
  final Function(XFile?) onImagePicked;
  final bool isUserImage;
  final bool canEdit;
  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  XFile? pickedImage;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: getUserProfilePic(ref),
          ),
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
      ),
    );
  }

  ImageProvider<Object> getUserProfilePic(WidgetRef ref) {
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

    return getDefaultProfilePic(ref);
  }
}

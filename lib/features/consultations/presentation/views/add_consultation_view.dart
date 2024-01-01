import 'dart:io';

import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../consultations.dart';

class AddConsultationView extends ConsumerStatefulWidget {
  const AddConsultationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddConsultationViewState();
}

class _AddConsultationViewState extends ConsumerState<AddConsultationView> {
  File? pickedAttatchment;
  AttatchmentType? attatchmentType;
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  var isEnabled = true;

  void _listenToRequestResponse(WidgetRef ref) {
    ref.listen(
      requestResponseProvider,
      (_, state) {
        state.whenOrNull(
          sucess: (_, __) {
            // Disable button to prevent multiple requests
            setState(() {
              isEnabled = false; // enable button and text field
            });
            context
                .showSnackbarSuccess(S.of(context).AddConsultationView_message);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenToRequestResponse(ref);
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).AddConsultationView_consult),
      ),
      body: SizedBox(
        width: context.screenSize.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    S.of(context).AddConsultationView_title,
                    style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.primary),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      S.of(context).AddConsultationView_description,
                      style: context.textTheme.titleSmall!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      S.of(context).AddConsultationView_shortDescription,
                      style: context.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary),
                    ),
                  ),
                  ClinigramTextField(
                    hintText: '',
                    controller: descriptionController,
                    maxLines: 10,
                    // respect isEnabled
                    enabled: isEnabled,
                  ),

                  // respect isEnabled
                  if (isEnabled) buildAttachmentComponents(),
                  Center(
                    child: ClinigramButton(
                      enabled: isEnabled,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ref
                              .read(createConsultationProvider)
                              .createNewConsultation(
                                  descriptionController.text,
                                  pickedAttatchment,
                                  attatchmentType ?? AttatchmentType.none);
                        }
                      },
                      child: Text(
                        S.of(context).AddConsultationView_sendButtonText,
                        style: context.textTheme.titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickAttatchment(BuildContext context) async {
    const int maxImageSize = 20;
    FilePickerResult? result;
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg']);

    if (result != null) {
      final file = result.files.single;
      final fileSize = file.size / (1024 * 1024);

      if (fileSize <= maxImageSize) {
        pickedAttatchment = File(result.files.single.path!);
        attatchmentType = isImage(pickedAttatchment!.path)
            ? AttatchmentType.image
            : AttatchmentType.pdf;
        setState(() {});
      } else {}
    }
  }

  Widget buildAttachmentComponents() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: InkWell(
        onTap: () {
          pickAttatchment(context);
        },
        child: pickedAttatchment != null
            ? attatchmentType == AttatchmentType.image
                ? Image.file(pickedAttatchment!)
                : DottedBorder(
                    color: const Color(0xFF6799FF),
                    borderType: BorderType.Rect,
                    dashPattern: const [5, 5],
                    radius: const Radius.circular(20),
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 30),
                      width: context.screenSize.width,
                      color: const Color(0xFF6799FF).withOpacity(0.2),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            size: 80,
                            color: Color(0xFF6799FF),
                          ),
                          Text(
                            pickedAttatchment!.path.split('/').last,
                            textAlign: TextAlign.center,
                            style: context.textTheme.titleMedium!
                                .copyWith(color: const Color(0xFF6799FF)),
                          ),
                        ],
                      ),
                    ),
                  )
            : DottedBorder(
                color: const Color(0xFF6799FF),
                borderType: BorderType.Rect,
                dashPattern: const [5, 5],
                radius: const Radius.circular(20),
                padding: EdgeInsets.zero,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                  width: context.screenSize.width,
                  color: const Color(0xFF6799FF).withOpacity(0.2),
                  child: Column(
                    children: [
                      Image.asset(
                        uploadIcon,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          S.of(context).AddConsultationView_addImageButtonText,
                          style: context.textTheme.titleMedium!
                              .copyWith(color: const Color(0xFF6799FF)),
                        ),
                      ),
                      Text(
                        S.of(context).AddConsultationView_supportedFormatsText,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium!
                            .copyWith(color: const Color(0xFF6799FF)),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

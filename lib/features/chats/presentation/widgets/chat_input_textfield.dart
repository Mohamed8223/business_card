import 'dart:io';

import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../chats.dart';

const int _maxImageSize = 2;

class ChatInputField extends ConsumerWidget {
  const ChatInputField({
    Key? key,
    required this.onSend,
    required this.onAttatchmentConfirmed,
    required this.messageController,
  }) : super(key: key);
  final Function(String) onSend;
  final Function(File, ChatMessageType) onAttatchmentConfirmed;
  final TextEditingController messageController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(requestResponseProvider) ==
        RequestResponseModel.loading(loadingType: LoadingTypes.inline);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16 / 4),
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: S.of(context).ChatInputField_textFieldHint,
                          hintStyle: context.textTheme.bodyMedium!
                              .copyWith(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () async {
                              FilePickerResult? result;
                              result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'pdf',
                                    'png',
                                    'jpg',
                                    'jpeg'
                                  ]);

                              if (result != null) {
                                final file = result.files.single;
                                final fileSize = file.size / (1024 * 1024);

                                if (fileSize <= _maxImageSize) {
                                  late AttatchmentType attatchmentType;
                                  late File pickedAttatchment;
                                  pickedAttatchment =
                                      File(result.files.single.path!);
                                  attatchmentType =
                                      isImage(pickedAttatchment.path)
                                          ? AttatchmentType.image
                                          : AttatchmentType.pdf;
                                  if (context.mounted) {
                                    context.push(ChatAttatchmentPreview(
                                      attatchment: pickedAttatchment,
                                      attatchmentType: attatchmentType,
                                      onConfirm: () {
                                        final messageType = attatchmentType ==
                                                AttatchmentType.image
                                            ? ChatMessageType.image
                                            : ChatMessageType.pdf;
                                        onAttatchmentConfirmed(
                                            pickedAttatchment, messageType);
                                      },
                                    ));
                                  }
                                } else {
                                  if (context.mounted) {
                                    context.showSnackbarError(S
                                        .of(context)
                                        .ChatInputField_attachmentSizeExceeded);
                                  }
                                }
                              }
                            },
                      child: Icon(
                        Icons.attach_file,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => isLoading ? null : onSend(messageController.text),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.theme.colorScheme.secondary),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 22,
                        )),
            ),
          ],
        ),
      ),
    );
  }
}

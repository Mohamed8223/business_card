import 'package:clinigram_app/features/chats/presentation/widgets/pdf_message.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../chats.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    Widget messageContaint(MessageModel message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.image:
          return ImageMessage(
            message: message,
          );
        case ChatMessageType.pdf:
          return PdfMessage(
            message: message,
          );
        default:
          return const SizedBox();
      }
    }

    return Row(
      mainAxisAlignment:
          message.isMyMessgae ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isMyMessgae) ...[
          const CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage(userProfileImage),
          ),
          const SizedBox(width: 16 / 2),
        ],
        messageContaint(message),
      ],
    );
  }
}

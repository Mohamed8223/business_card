import 'package:clinigram_app/core/core.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../chats.dart';

class PdfMessage extends StatelessWidget {
  const PdfMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          AttatechmentViewerView(
              url: message.content, attatchmentType: AttatchmentType.pdf),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary
              .withOpacity(message.isMyMessgae ? 1 : 0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(10),
        child: DottedBorder(
          color: Colors.white,
          borderType: BorderType.Rect,
          dashPattern: const [5, 5],
          radius: const Radius.circular(20),
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
            width: context.screenSize.width * 0.6,
            color: const Color(0xFFFFFFFF).withOpacity(0.2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  size: 80,
                  color: Color(0xFFFFFFFF),
                ),
                Text(
                  getFileNameFromUrl(message.content) ?? 'document.pdf',
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium!
                      .copyWith(color: const Color(0xFFFFFFFF)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:flutter/material.dart';

import '../../chats.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AttatechmentViewerView(
            url: message.content, attatchmentType: AttatchmentType.image),
      ),
      child: Container(
        width: context.screenSize.width * 0.6,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary
              .withOpacity(message.isMyMessgae ? 1 : 0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: CachedNetworkImage(
          imageUrl: message.content,
        ),
      ),
    );
  }
}

import 'package:clinigram_app/core/core.dart';
import 'package:flutter/material.dart';

import '../../chats.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final MessageModel? message;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary
              .withOpacity(message!.isMyMessgae ? 1 : 0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          message!.content,
          style: context.textTheme.titleMedium!.copyWith(
            fontSize: context.screenSize.width * 0.04,
            color: message!.isMyMessgae ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

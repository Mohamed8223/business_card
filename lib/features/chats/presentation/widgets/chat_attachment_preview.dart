import 'dart:io';

import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';

class ChatAttatchmentPreview extends ConsumerWidget {
  const ChatAttatchmentPreview({
    super.key,
    required this.attatchment,
    required this.attatchmentType,
    required this.onConfirm,
  });
  final File attatchment;
  final AttatchmentType attatchmentType;
  final Function() onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ChatAttatchmentPreview_appBarTitle),
      ),
      body: Center(
        child: Container(
          child: attatchmentType == AttatchmentType.image
              ? Image.file(
                  attatchment,
                  fit: BoxFit.cover,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 80,
                          color: Color(0xFF6799FF),
                        ),
                        Text(
                          attatchment.path.split('/').last,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleMedium!
                              .copyWith(color: const Color(0xFF6799FF)),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pop();
          onConfirm();
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}

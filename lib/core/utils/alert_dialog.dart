import 'package:clinigram_app/core/core.dart';
import 'package:flutter/material.dart';

showMyAlertDialog({
  required BuildContext context,
  String? imgPath,
  String? title,
  String? done,
  String? cancel,
  String? description,
}) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: imgPath != null
                ? Image.asset(imgPath)
                : title != null
                    ? Text(title)
                    : null,
            content: description != null ? Text(description) : null,
            actions: [
              TextButton(
                onPressed: () {
                  context.pop(true);
                },
                child: Text(
                  done ?? 'موافق',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop(false);
                },
                child: Text(
                  cancel ?? 'إلغاء',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceEvenly,
          ));
}

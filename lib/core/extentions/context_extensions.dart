import 'dart:async' show unawaited;

import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core.dart';

extension ContextExtensions<T> on BuildContext {
  // AppLocalizations get locale => AppLocalizations.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  void push(Widget page) async {
    await Future.delayed(Duration.zero);
    await Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void pushAndRemoveOthers(Widget page) async {
    await Future.delayed(Duration.zero);
    await Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false,
    );
  }

  void pushReplacement(Widget page) async {
    await Future.delayed(Duration.zero);
    unawaited(
      Navigator.of(this).pushReplacement(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      ),
    );
  }

  /// Pop the top-most route off the navigator that most tightly encloses the
  ///  given context.
  void pop([T? result]) => Navigator.pop(this, result);

  void showSnackbarError(String? message) {
    ScaffoldMessenger.of(this).showSnackBar(
      _snackbarContent(
        backgroundColor: Colors.red,
        message: message ?? S.current.ContextExtensions_error_message,
        icon: Icons.error,
      ),
    );
  }

  void showSnackbarSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      _snackbarContent(
        backgroundColor: const Color.fromARGB(255, 27, 148, 92),
        message: message,
        icon: Icons.check_circle,
      ),
    );
  }

  SnackBar _snackbarContent({
    required Color backgroundColor,
    required String message,
    required IconData icon,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Expanded(
            flex: 10,
            child: Text(
              message,
              style: theme.textTheme.labelMedium!.copyWith(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
              child: Icon(
            icon,
            color: Colors.white,
          )),
        ],
      ),
    );
  }

  void showLoadingOverlay() async {
    await showDialog(
      context: this,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              padding: const EdgeInsets.all(10),
              child: Lottie.asset(
                loadingAnimation,
              ),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }
}

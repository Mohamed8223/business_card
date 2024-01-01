import 'package:flutter/material.dart';

class ClinigramButton extends StatelessWidget {
  const ClinigramButton({
    Key? key,
    required this.onPressed,
    this.style,
    this.enabled = true,
    required this.child,
  }) : super(key: key);
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Widget child;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: style,
      child: child,
    );
  }
}

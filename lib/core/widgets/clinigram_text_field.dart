import 'package:flutter/material.dart';
import 'package:clinigram_app/core/extentions/context_extensions.dart';

class ClinigramTextField extends StatefulWidget {
  const ClinigramTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.validator,
      this.obscureText = false,
      this.focusNode = null,
      this.readOnly = false,
      this.enabled = true,
      this.maxLines = 1,
      this.icon,
      this.onTap,
      this.onComplete,
      this.textInputType});
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLines;
  final String? icon;
  final bool readOnly;
  final bool enabled;
  final TextInputType? textInputType;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  final Function(String)? onComplete;

  @override
  State<ClinigramTextField> createState() => _ClinigramTextFieldState();
}

class _ClinigramTextFieldState extends State<ClinigramTextField> {
  late bool isObsucerdEnabled;
  @override
  void initState() {
    isObsucerdEnabled = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      onTap: widget.onTap,
      // onEditingComplete: widget.onComplete,
      onChanged: widget.onComplete,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      validator: widget.validator,
      maxLines: widget.maxLines,
      controller: widget.controller,
      obscureText: isObsucerdEnabled,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        hintText: widget.hintText,
        labelText: widget.hintText,
        prefixIcon: widget.icon == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  widget.icon!,
                  width: 17,
                ),
              ),
        prefixIconConstraints: const BoxConstraints(maxWidth: 40),
        suffixIcon: widget.obscureText
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isObsucerdEnabled = !isObsucerdEnabled;
                  });
                },
                child: Icon(
                  isObsucerdEnabled ? Icons.visibility : Icons.visibility_off,
                  color: context.theme.colorScheme.primary,
                ),
              )
            : null,
      ),
    );
  }
}

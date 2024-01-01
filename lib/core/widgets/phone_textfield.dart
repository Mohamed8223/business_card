import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class PhoneTextField extends StatelessWidget with ValidationMixin {
  const PhoneTextField({
    super.key,
    required this.controller,
    this.onCompleted,
    this.onSubmitted,
    this.readOnly = false,
  });
  final TextEditingController controller;
  final bool readOnly;
  final Function(String)? onCompleted;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        onChanged: onCompleted,
        onFieldSubmitted: onSubmitted,
        readOnly: readOnly,
        validator: (value) => phoneValidation(value, context),
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: S.of(context).PhoneTextField_phone_num,
          hintTextDirection: TextDirection.rtl,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0) +
                  const EdgeInsets.only(bottom: 2),
              child: const Text(
                '+972',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              )),
          prefixIconConstraints: const BoxConstraints(maxWidth: 60),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.theme.colorScheme.primary),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

import 'package:clinigram_app/core/constants/fixed_assets.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClinigramSearchTextField extends StatelessWidget {
  const ClinigramSearchTextField(
      {super.key, required this.controller, this.validator});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        hintText: S.of(context).ClinigramSearchTextField_search,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        fillColor: const Color(0XFFE8E8E8),
        filled: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Image.asset(
            searchIcon,
            width: 17,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(maxWidth: 40),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0XFFE8E8E8)),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFE8E8E8)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFE8E8E8)),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0XFFE8E8E8)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

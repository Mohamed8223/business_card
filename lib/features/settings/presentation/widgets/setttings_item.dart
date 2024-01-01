import 'package:clinigram_app/core/core.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.text,
    required this.icon,
    this.iconWidth = 25,
    this.iconWPadding = 10,
    this.onTap,
  });
  final String text;
  final String icon;
  final double iconWidth;
  final double iconWPadding;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(iconWPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.27),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Image.asset(
              icon,
              width: iconWidth,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

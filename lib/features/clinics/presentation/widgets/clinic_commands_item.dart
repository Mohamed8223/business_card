import 'package:flutter/material.dart';

class ClinicCommandsItem extends StatelessWidget {
  const ClinicCommandsItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
    this.isActive = true,
  });
  final String title;
  final String icon;
  final Color? color;
  final VoidCallback onTap;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              icon,
              width: 30,
              color: isActive ? color : Colors.grey[200],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

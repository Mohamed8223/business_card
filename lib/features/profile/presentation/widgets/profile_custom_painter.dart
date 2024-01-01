import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.02649007);
    path_0.lineTo(size.width, size.height * 0.2913907);
    path_0.lineTo(size.width, size.height * 0.4188742);
    path_0.cubicTo(
        size.width,
        size.height * 0.5651755,
        size.width * 0.9044880,
        size.height * 0.6837748,
        size.width * 0.7866667,
        size.height * 0.6837748);
    path_0.lineTo(size.width * 0.1893501, size.height * 0.6837748);
    path_0.cubicTo(size.width * 0.08281920, size.height * 0.6985728, 0,
        size.height * 0.8107881, 0, size.height * 0.9470199);
    path_0.lineTo(0, size.height * 0.6837748);
    path_0.lineTo(0, size.height * 0.6821192);
    path_0.lineTo(0, size.height * 0.5562914);
    path_0.cubicTo(
        0,
        size.height * 0.4099901,
        size.width * 0.09551253,
        size.height * 0.2913901,
        size.width * 0.2133333,
        size.height * 0.2913901);
    path_0.lineTo(size.width * 0.7870880, size.height * 0.2913901);
    path_0.cubicTo(size.width * 0.9047147, size.height * 0.2911079, size.width,
        size.height * 0.1726162, size.width, size.height * 0.02649007);
    path_0.close();

    Paint paint0fill = Paint()..style = PaintingStyle.fill;
    paint0fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.1013333, size.height * 0.07947020),
        Offset(size.width * 0.7240000, size.height), [
      const Color(0xff2185C7).withOpacity(1),
      const Color(0xffA5CFEB).withOpacity(1)
    ], [
      0,
      0.94375
    ]);
    canvas.drawPath(path_0, paint0fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

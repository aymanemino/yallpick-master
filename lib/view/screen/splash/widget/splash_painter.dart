import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';

class SplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Subtle curved background patterns for white background
    var mainPaint = Paint()
      ..color = ColorResources.LIGHT_SKY_BLUE.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    var mainPath = Path();
    mainPath.moveTo(0, size.height * 0.35);
    mainPath.quadraticBezierTo(size.width * 0.25, size.height * 0.25,
        size.width * 0.65, size.height * 0.6);
    mainPath.quadraticBezierTo(size.width * 0.75, size.height * 0.65,
        size.width * 1.0, size.height * 0.60);
    mainPath.lineTo(size.width, size.height);
    mainPath.lineTo(0, size.height);
    mainPath.close();
    canvas.drawPath(mainPath, mainPaint);

    // Secondary subtle pattern
    var secondaryPaint = Paint()
      ..color = ColorResources.YELLOW.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    var secondaryPath = Path();
    secondaryPath.moveTo(0, size.height * 0.45);
    secondaryPath.quadraticBezierTo(size.width * 0.3, size.height * 0.35,
        size.width * 0.7, size.height * 0.7);
    secondaryPath.quadraticBezierTo(size.width * 0.8, size.height * 0.75,
        size.width * 1.0, size.height * 0.70);
    secondaryPath.lineTo(size.width, size.height);
    secondaryPath.lineTo(0, size.height);
    secondaryPath.close();
    canvas.drawPath(secondaryPath, secondaryPaint);

    // Top accent pattern
    var accentPaint = Paint()
      ..color = ColorResources.SELLER_TXT.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    var accentPath = Path();
    accentPath.moveTo(0, size.height * 0.2);
    accentPath.quadraticBezierTo(size.width * 0.5, size.height * 0.1,
        size.width * 1.0, size.height * 0.2);
    accentPath.lineTo(size.width, size.height * 0.3);
    accentPath.quadraticBezierTo(
        size.width * 0.5, size.height * 0.2, 0, size.height * 0.3);
    accentPath.close();
    canvas.drawPath(accentPath, accentPaint);

    // Floating circles with very subtle opacity
    var circlePaint = Paint()
      ..color = ColorResources.LIGHT_SKY_BLUE.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    // Top left circle
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.15),
      size.width * 0.08,
      circlePaint,
    );

    // Top right circle
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.12),
      size.width * 0.06,
      circlePaint,
    );

    // Bottom right circle
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.8),
      size.width * 0.05,
      circlePaint,
    );

    // Additional small decorative circles
    var smallCirclePaint = Paint()
      ..color = ColorResources.YELLOW.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Middle left small circle
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.45),
      size.width * 0.04,
      smallCirclePaint,
    );

    // Middle right small circle
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.35),
      size.width * 0.03,
      smallCirclePaint,
    );

    // Bottom left small circle
    canvas.drawCircle(
      Offset(size.width * 0.12, size.height * 0.82),
      size.width * 0.05,
      smallCirclePaint,
    );

    // Very subtle wave patterns
    var wavePaint = Paint()
      ..color = ColorResources.SELLER_TXT.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Top wave
    var topWavePath = Path();
    topWavePath.moveTo(0, size.height * 0.25);
    for (int i = 0; i <= 10; i++) {
      double x = (size.width / 10) * i;
      double y = size.height * 0.25 + (i % 2 == 0 ? 15 : -15) * (1 - (i / 10));
      if (i == 0) {
        topWavePath.moveTo(x, y);
      } else {
        topWavePath.lineTo(x, y);
      }
    }
    canvas.drawPath(topWavePath, wavePaint);

    // Middle wave
    var middleWavePath = Path();
    middleWavePath.moveTo(0, size.height * 0.65);
    for (int i = 0; i <= 8; i++) {
      double x = (size.width / 8) * i;
      double y = size.height * 0.65 + (i % 2 == 0 ? 10 : -10) * (1 - (i / 8));
      if (i == 0) {
        middleWavePath.moveTo(x, y);
      } else {
        middleWavePath.lineTo(x, y);
      }
    }
    canvas.drawPath(middleWavePath, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

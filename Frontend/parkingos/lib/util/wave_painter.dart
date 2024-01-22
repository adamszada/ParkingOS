import 'dart:math';
import 'package:flutter/material.dart';

class WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A88DB)
      ..style = PaintingStyle.fill;

    final waveHeight = size.height * 7 / 8;
    const waveFrequency = 0.1;
    const waveAmplitude = 100.0;

    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - waveHeight);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(
        i,
        size.height -
            waveHeight -
            waveAmplitude * cos((i * waveFrequency) * (pi / 180.0)),
      );
    }

    path.lineTo(size.width, size.height - waveHeight);
    path.lineTo(size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

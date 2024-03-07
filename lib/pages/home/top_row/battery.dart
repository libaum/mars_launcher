import 'package:flutter/material.dart';

class BatteryIcon extends StatelessWidget {
  final int batteryLevel;
  final Color paintColor;

  const BatteryIcon({required this.batteryLevel, required this.paintColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BatteryPainter(batteryLevel: batteryLevel, paintColor: paintColor),
      size: const Size(18, 10), // Hier kannst du die Größe des Icons anpassen
    );
  }
}

class BatteryPainter extends CustomPainter {
  final int batteryLevel;
  Color paintColor;

  BatteryPainter({required this.batteryLevel, required this.paintColor});


  @override
  void paint(Canvas canvas, Size size) {

    // paintColor = Colors.white54;

    Paint outlinePaint = Paint()
      ..color = paintColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    RRect backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(2),
    );
    canvas.drawRRect(backgroundRect, outlinePaint);

    // Vorsprung zeichnen
    Paint protrusionPaint = Paint()
      ..color = paintColor
      ..style = PaintingStyle.fill;
    RRect protrusionRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width, size.height / 4, 3, size.height / 2),
      Radius.circular(0.5),
    );
    canvas.drawRRect(protrusionRect, protrusionPaint);

    if (batteryLevel > 0) {
      Paint fillPaint = Paint()
        ..color = paintColor// Farbe des gefüllten Bereichs
        ..style = PaintingStyle.fill;

      double margin = 2;
      double fillPercentage = batteryLevel / 100.0;
      double fillWidth = (size.width - 2 * margin) * fillPercentage;

      RRect fillRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(margin, margin, fillWidth, size.height-2*margin),
        Radius.circular(1),
      );

      canvas.drawRRect(fillRect, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
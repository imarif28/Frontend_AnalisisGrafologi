import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/detection_result.dart';

class BoundingBoxPainter extends CustomPainter {
  final ui.Image image;
  final List<Detection> detections;
  final Set<String> visibleClasses;

  BoundingBoxPainter({
    required this.image,
    required this.detections,
    required this.visibleClasses,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image scaled to the canvas size
    final Rect src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Calculate scale factors
    final double scaleX = size.width / image.width;
    final double scaleY = size.height / image.height;

    // Draw image
    canvas.drawImageRect(image, src, dst, Paint());

    // Define colors for bounding boxes
    final colors = [
      const Color(0xFFFFB3B3), // Pastel Red
      const Color(0xFFFFD1A9), // Pastel Orange
      const Color(0xFFFFF5BA), // Pastel Yellow
      const Color(0xFFB5EAD7), // Pastel Green
      const Color(0xFFC7CEEA), // Pastel Blue
      const Color(0xFFE2F0CB), // Pastel Lime
      const Color(0xFFFF9CEE), // Pastel Pink
    ];

    int colorIndex = 0;
    
    // We map each class to a specific color so it stays consistent
    final Map<String, Color> classColors = {};

    for (var detection in detections) {
      if (!visibleClasses.contains(detection.className)) continue;

      if (!classColors.containsKey(detection.className)) {
        classColors[detection.className] = colors[colorIndex % colors.length];
        colorIndex++;
      }

      final color = classColors[detection.className]!;
      
      final paint = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // box: [x_min, y_min, x_max, y_max]
      final rect = Rect.fromLTRB(
        detection.box[0] * scaleX,
        detection.box[1] * scaleY,
        detection.box[2] * scaleX,
        detection.box[3] * scaleY,
      );

      // Draw semi-transparent fill
      canvas.drawRect(rect, paint);
      // Draw solid border
      canvas.drawRect(rect, borderPaint);

      // Optional: Draw label background and text
      final textStyle = TextStyle(
        color: Colors.black87,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        backgroundColor: color.withValues(alpha: 0.8),
      );
      
      final textSpan = TextSpan(
        text: ' ${detection.className} ${(detection.confidence * 100).toStringAsFixed(0)}% ',
        style: textStyle,
      );
      
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - textPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return oldDelegate.visibleClasses != visibleClasses || 
           oldDelegate.detections != detections ||
           oldDelegate.image != image;
  }
}

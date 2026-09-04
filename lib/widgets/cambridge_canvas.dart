import 'dart:math' as math;
import 'package:flutter/material.dart';

enum CambridgeGapDirection {
  up,
  right,
  down,
  left,
}

enum CambridgeConfusionAxis {
  protan, // Red confusion vector
  deutan, // Green confusion vector
  tritan, // Blue/Violet confusion vector
}

class CambridgeCanvas extends StatelessWidget {
  final CambridgeGapDirection gapDirection;
  final CambridgeConfusionAxis axis;
  final double chromaticSaturation; // 0.1 to 1.0 (contrast/difficulty)
  final double size;
  final int seed;

  const CambridgeCanvas({
    super.key,
    required this.gapDirection,
    required this.axis,
    this.chromaticSaturation = 0.65,
    this.size = 320,
    this.seed = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1F2430), // Dark clinical monitor background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _CambridgePainter(
            gapDirection: gapDirection,
            axis: axis,
            saturation: chromaticSaturation,
            seed: seed,
          ),
        ),
      ),
    );
  }
}

class _CCTDot {
  final double x;
  final double y;
  final double r;
  final Color color;

  _CCTDot(this.x, this.y, this.r, this.color);
}

class _CambridgePainter extends CustomPainter {
  final CambridgeGapDirection gapDirection;
  final CambridgeConfusionAxis axis;
  final double saturation;
  final int seed;

  _CambridgePainter({
    required this.gapDirection,
    required this.axis,
    required this.saturation,
    required this.seed,
  });

  @override
  bool shouldRepaint(_CambridgePainter oldDelegate) {
    return oldDelegate.gapDirection != gapDirection ||
        oldDelegate.axis != axis ||
        oldDelegate.saturation != saturation ||
        oldDelegate.seed != seed;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = (size.width / 2) * 0.94;

    final dots = _generateCCTDots(size.width, size.height, center, maxRadius);
    final paint = Paint()..isAntiAlias = true;

    for (final dot in dots) {
      paint.color = dot.color;
      canvas.drawCircle(Offset(dot.x, dot.y), dot.r, paint);
    }
  }

  List<_CCTDot> _generateCCTDots(
    double width,
    double height,
    Offset center,
    double maxRadius,
  ) {
    final random = math.Random(seed * 23 + 13);
    final List<_CCTDot> dots = [];

    // Landolt C ring dimensions
    final outerRadius = width * 0.35;
    final innerRadius = width * 0.19;
    const gapAngleWidth = math.pi / 3.2; // Angle span for the gap opening (~56 degrees)

    // Determine target angle center for the gap
    double targetAngle;
    switch (gapDirection) {
      case CambridgeGapDirection.up:
        targetAngle = -math.pi / 2;
        break;
      case CambridgeGapDirection.right:
        targetAngle = 0.0;
        break;
      case CambridgeGapDirection.down:
        targetAngle = math.pi / 2;
        break;
      case CambridgeGapDirection.left:
        targetAngle = math.pi;
        break;
    }

    // Dot grid step
    const double step = 7.5;
    for (double x = 8; x < width - 8; x += step) {
      for (double y = 8; y < height - 8; y += step) {
        final jx = x + (random.nextDouble() - 0.5) * 4.5;
        final jy = y + (random.nextDouble() - 0.5) * 4.5;

        final dx = jx - center.dx;
        final dy = jy - center.dy;
        final dist = math.sqrt(dx * dx + dy * dy);
        if (dist > maxRadius) continue;

        // Check if inside the Landolt C ring
        bool isInsideC = false;
        if (dist >= innerRadius && dist <= outerRadius) {
          // Check if within the gap opening
          double angle = math.atan2(dy, dx);
          double diff = (angle - targetAngle).abs();
          if (diff > math.pi) diff = 2 * math.pi - diff;

          if (diff >= gapAngleWidth / 2) {
            isInsideC = true; // Part of the C ring!
          }
        }

        final r = 2.0 + random.nextDouble() * 2.8;

        // Base luminance jitter (CCT standard luminance noise)
        final greyLuminance = 110 + random.nextInt(90); // 110-200

        if (isInsideC) {
          // Chromatic target dot with confusion vector tint
          final targetColor = _computeTargetColor(greyLuminance, axis, saturation);
          dots.add(_CCTDot(jx, jy, r, targetColor));
        } else {
          // Neutral grey noise dot
          final greyColor = Color.fromARGB(255, greyLuminance, greyLuminance, greyLuminance);
          dots.add(_CCTDot(jx, jy, r, greyColor));
        }
      }
    }

    return dots;
  }

  Color _computeTargetColor(int baseLum, CambridgeConfusionAxis axis, double sat) {
    // Offset RGB depending on confusion vector
    double r = baseLum.toDouble();
    double g = baseLum.toDouble();
    double b = baseLum.toDouble();

    final delta = 75.0 * sat;

    switch (axis) {
      case CambridgeConfusionAxis.protan: // Red-shifted
        r += delta * 1.1;
        g -= delta * 0.4;
        b -= delta * 0.2;
        break;
      case CambridgeConfusionAxis.deutan: // Green-shifted
        r -= delta * 0.5;
        g += delta * 1.0;
        b -= delta * 0.3;
        break;
      case CambridgeConfusionAxis.tritan: // Blue-violet shifted
        r += delta * 0.3;
        g -= delta * 0.3;
        b += delta * 1.2;
        break;
    }

    return Color.fromARGB(
      255,
      r.clamp(0.0, 255.0).round(),
      g.clamp(0.0, 255.0).round(),
      b.clamp(0.0, 255.0).round(),
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/models/hrr_plate.dart';

class HRRCanvas extends StatelessWidget {
  final HRRPlate plate;
  final double size;
  final String? visionFilter;

  const HRRCanvas({
    super.key,
    required this.plate,
    this.size = 320,
    this.visionFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEBEAE7), // HRR neutral paper tone
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _HRRPainter(
            plate: plate,
            filter: visionFilter,
          ),
        ),
      ),
    );
  }
}

class _HRRDot {
  final double x;
  final double y;
  final double r;
  final Color color;

  _HRRDot(this.x, this.y, this.r, this.color);
}

class _HRRPainter extends CustomPainter {
  final HRRPlate plate;
  final String? filter;

  _HRRPainter({
    required this.plate,
    this.filter,
  });

  @override
  bool shouldRepaint(_HRRPainter oldDelegate) {
    return oldDelegate.plate != plate || oldDelegate.filter != filter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = (size.width / 2) * 0.94;

    final dots = _generateHRRDots(plate, size.width, size.height, center, maxRadius);
    final paint = Paint()..isAntiAlias = true;

    for (final dot in dots) {
      Color dotColor = dot.color;
      if (filter != null) {
        dotColor = _applyColorFilter(dotColor, filter!);
      }
      paint.color = dotColor;
      canvas.drawCircle(Offset(dot.x, dot.y), dot.r, paint);
    }
  }

  List<_HRRDot> _generateHRRDots(
    HRRPlate plate,
    double width,
    double height,
    Offset center,
    double maxRadius,
  ) {
    final random = math.Random(plate.seed * 37 + 7);
    final List<_HRRDot> dots = [];

    // Base neutral achromatic greys (HRR standard neutral noise matrix)
    final greyTones = [
      const Color(0xFF6B7280),
      const Color(0xFF9CA3AF),
      const Color(0xFFD1D5DB),
      const Color(0xFF4B5563),
      const Color(0xFFE5E7EB),
      const Color(0xFF868E96),
    ];

    // Colored palettes for target shapes
    final shapeColors = _getPlateColors(plate.category, random);

    // Grid placement with jitter for natural dot distribution
    const double step = 8.5;
    for (double x = 8; x < width - 8; x += step) {
      for (double y = 8; y < height - 8; y += step) {
        final jx = x + (random.nextDouble() - 0.5) * 5.0;
        final jy = y + (random.nextDouble() - 0.5) * 5.0;

        final distFromCenter = math.sqrt(math.pow(jx - center.dx, 2) + math.pow(jy - center.dy, 2));
        if (distFromCenter > maxRadius) continue;

        final isTarget = _isPointInsideShapes(jx, jy, width, height, plate.targetShapes);
        final r = 2.4 + random.nextDouble() * 3.4;

        if (isTarget) {
          final color = shapeColors[random.nextInt(shapeColors.length)];
          dots.add(_HRRDot(jx, jy, r, color));
        } else {
          final color = greyTones[random.nextInt(greyTones.length)];
          dots.add(_HRRDot(jx, jy, r, color));
        }
      }
    }

    return dots;
  }

  List<Color> _getPlateColors(HRRPlateCategory category, math.Random random) {
    switch (category) {
      case HRRPlateCategory.demonstration:
        return [
          const Color(0xFFD9480F),
          const Color(0xFFE8590C),
          const Color(0xFFF76707),
        ];
      case HRRPlateCategory.screeningRedGreen:
      case HRRPlateCategory.diagnosticProtan:
        return [
          const Color(0xFFE06C75),
          const Color(0xFFDE7468),
          const Color(0xFFD65D68),
        ];
      case HRRPlateCategory.diagnosticDeutan:
        return [
          const Color(0xFF5C9E76),
          const Color(0xFF68A380),
          const Color(0xFF73AC8C),
        ];
      case HRRPlateCategory.screeningBlueYellow:
      case HRRPlateCategory.diagnosticTritan:
        return [
          const Color(0xFF5C7CFA),
          const Color(0xFF748FFC),
          const Color(0xFF4C6EF5),
        ];
    }
  }

  bool _isPointInsideShapes(double px, double py, double width, double height, List<HRRShape> shapes) {
    if (shapes.isEmpty) return false;

    if (shapes.length == 1) {
      final center = Offset(width / 2, height / 2);
      final size = width * 0.42;
      return _isInSingleShape(px, py, center, size, shapes[0]);
    } else {
      // Two shapes: left and right
      final center1 = Offset(width * 0.33, height / 2);
      final center2 = Offset(width * 0.67, height / 2);
      final size = width * 0.28;
      return _isInSingleShape(px, py, center1, size, shapes[0]) ||
          _isInSingleShape(px, py, center2, size, shapes[1]);
    }
  }

  bool _isInSingleShape(double px, double py, Offset center, double size, HRRShape shape) {
    final dx = px - center.dx;
    final dy = py - center.dy;

    switch (shape) {
      case HRRShape.circle:
        final dist = math.sqrt(dx * dx + dy * dy);
        final outerR = size * 0.5;
        final innerR = size * 0.28;
        return dist >= innerR && dist <= outerR;

      case HRRShape.triangle:
        // Equilateral triangle outline
        final r = size * 0.55;
        final p1 = Offset(0, -r);
        final p2 = Offset(r * math.cos(math.pi / 6), r * math.sin(math.pi / 6));
        final p3 = Offset(-r * math.cos(math.pi / 6), r * math.sin(math.pi / 6));

        final dToSide1 = _distToSegment(Offset(dx, dy), p1, p2);
        final dToSide2 = _distToSegment(Offset(dx, dy), p2, p3);
        final dToSide3 = _distToSegment(Offset(dx, dy), p3, p1);

        final strokeWidth = size * 0.15;
        final minDist = math.min(dToSide1, math.min(dToSide2, dToSide3));
        return minDist <= strokeWidth;

      case HRRShape.cross:
        final halfThick = size * 0.14;
        final halfArm = size * 0.48;
        final inHoriz = (dx.abs() <= halfArm && dy.abs() <= halfThick);
        final inVert = (dy.abs() <= halfArm && dx.abs() <= halfThick);
        return inHoriz || inVert;
    }
  }

  double _distToSegment(Offset p, Offset a, Offset b) {
    final l2 = (b.dx - a.dx) * (b.dx - a.dx) + (b.dy - a.dy) * (b.dy - a.dy);
    if (l2 == 0) return (p - a).distance;
    final t = math.max(0.0, math.min(1.0, ((p.dx - a.dx) * (b.dx - a.dx) + (p.dy - a.dy) * (b.dy - a.dy)) / l2));
    final projection = Offset(a.dx + t * (b.dx - a.dx), a.dy + t * (b.dy - a.dy));
    return (p - projection).distance;
  }

  Color _applyColorFilter(Color color, String filter) {
    final r = color.r;
    final g = color.g;
    final b = color.b;

    double nr, ng, nb;
    switch (filter) {
      case 'protanopia':
        nr = 0.56667 * r + 0.43333 * g;
        ng = 0.55833 * r + 0.44167 * g;
        nb = 0.24167 * g + 0.75833 * b;
        break;
      case 'deuteranopia':
        nr = 0.625 * r + 0.375 * g;
        ng = 0.70 * r + 0.30 * g;
        nb = 0.30 * g + 0.70 * b;
        break;
      case 'tritanopia':
        nr = 0.95 * r + 0.05 * g;
        ng = 0.43333 * g + 0.56667 * b;
        nb = 0.475 * g + 0.525 * b;
        break;
      default:
        return color;
    }

    return Color.fromARGB(
      (color.a * 255.0).round().clamp(0, 255),
      (nr.clamp(0.0, 1.0) * 255).round(),
      (ng.clamp(0.0, 1.0) * 255).round(),
      (nb.clamp(0.0, 1.0) * 255).round(),
    );
  }
}

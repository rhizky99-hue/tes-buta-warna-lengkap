import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/models/ishihara_plate.dart';

class IshiharaCanvas extends StatelessWidget {
  final IshiharaPlate plate;
  final double size;
  final String? visionFilter; // null (normal), 'protanopia', 'deuteranopia', 'tritanopia', 'achromatopsia'

  const IshiharaCanvas({
    super.key,
    required this.plate,
    this.size = 320,
    this.visionFilter,
  });

  @override
  Widget build(BuildContext context) {
    Widget plateWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF1EDE4), // Classic Ishihara parchment base
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
          painter: _IshiharaPainter(
            plate: plate,
            filter: visionFilter,
          ),
        ),
      ),
    );

    return InteractiveViewer(
      minScale: 0.9,
      maxScale: 2.5,
      clipBehavior: Clip.none,
      child: plateWidget,
    );
  }
}

class _Dot {
  final double x;
  final double y;
  final double r;
  final Color color;

  _Dot(this.x, this.y, this.r, this.color);
}

class _IshiharaPainter extends CustomPainter {
  final IshiharaPlate plate;
  final String? filter;

  _IshiharaPainter({
    required this.plate,
    this.filter,
  });

  @override
  bool shouldRepaint(_IshiharaPainter oldDelegate) {
    return oldDelegate.plate != plate || oldDelegate.filter != filter;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = (size.width / 2) * 0.94;

    // Deterministic random generation for dots based on plate seed
    final dots = _generatePlateDots(plate, size.width, size.height, center, maxRadius);

    final paint = Paint()..isAntiAlias = true;

    for (final dot in dots) {
      Color dotColor = dot.color;
      if (filter != null) {
        dotColor = _applyColorVisionFilter(dotColor, filter!);
      }
      paint.color = dotColor;
      canvas.drawCircle(Offset(dot.x, dot.y), dot.r, paint);
    }
  }

  List<_Dot> _generatePlateDots(
    IshiharaPlate plate,
    double width,
    double height,
    Offset center,
    double maxR,
  ) {
    final random = math.Random(plate.visualSeed);
    final List<_Dot> dots = [];

    // Base palettes according to plate types
    final bgPalettes = _getBgPalette(plate.plateType, plate.plateNumber);
    final figurePalettes = _getFigurePalette(plate.plateType, plate.plateNumber);
    final secondaryFigurePalettes = _getSecondaryFigurePalette(plate.plateType, plate.plateNumber);

    // Generate concentric jittered grid of pseudoisochromatic dots
    const int rings = 28;
    for (int ring = 1; ring <= rings; ring++) {
      final ringRadius = (ring / rings) * maxR;
      final circumference = 2 * math.pi * ringRadius;
      final dotCount = math.max(6, (circumference / 13.0).round());

      for (int i = 0; i < dotCount; i++) {
        final angle = (i / dotCount) * 2 * math.pi + (random.nextDouble() * 0.12 - 0.06);
        final jitterR = ringRadius + (random.nextDouble() * 5.0 - 2.5);
        if (jitterR > maxR - 2) continue;

        final x = center.dx + jitterR * math.cos(angle);
        final y = center.dy + jitterR * math.sin(angle);
        final dotRadius = 2.8 + random.nextDouble() * 4.4; // Varied dot sizes

        // Determine if (x,y) falls on digit shape
        final digitMaskResult = _checkDigitMask(plate, x, y, width, height, center);

        Color dotColor;
        if (digitMaskResult == 1) {
          // Primary Figure
          dotColor = figurePalettes[random.nextInt(figurePalettes.length)];
        } else if (digitMaskResult == 2) {
          // Secondary Figure (for diagnostic plates like 26, 42, 35)
          dotColor = secondaryFigurePalettes[random.nextInt(secondaryFigurePalettes.length)];
        } else {
          // Background
          dotColor = bgPalettes[random.nextInt(bgPalettes.length)];
        }

        // Slight micro-variation in lightness to create authentic organic Ishihara texture
        final hsl = HSLColor.fromColor(dotColor);
        final lightnessVar = (hsl.lightness + (random.nextDouble() * 0.08 - 0.04)).clamp(0.1, 0.95);
        final finalColor = hsl.withLightness(lightnessVar).toColor();

        dots.add(_Dot(x, y, dotRadius, finalColor));
      }
    }

    return dots;
  }

  // Check digit mask coordinates
  int _checkDigitMask(
    IshiharaPlate plate,
    double x,
    double y,
    double w,
    double h,
    Offset c,
  ) {
    final nx = (x - c.dx) / (w * 0.44); // normalized -1.0 to 1.0
    final ny = (y - c.dy) / (h * 0.44);

    if (nx.abs() > 1.0 || ny.abs() > 1.0) return 0;

    final answer = plate.normalAnswer;
    if (answer == '12') {
      if (_isPointInDigit('1', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('2', nx - 0.38, ny)) return 1;
    } else if (answer == '8') {
      if (_isPointInDigit('8', nx, ny)) return 1;
    } else if (answer == '5') {
      if (_isPointInDigit('5', nx, ny)) return 1;
    } else if (answer == '29') {
      if (_isPointInDigit('2', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('9', nx - 0.38, ny)) return 1;
    } else if (answer == '74') {
      if (_isPointInDigit('7', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('4', nx - 0.38, ny)) return 1;
    } else if (answer == '7') {
      if (_isPointInDigit('7', nx, ny)) return 1;
    } else if (answer == '45') {
      if (_isPointInDigit('4', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('5', nx - 0.38, ny)) return 1;
    } else if (answer == '2') {
      if (_isPointInDigit('2', nx, ny)) return 1;
    } else if (answer == '16') {
      if (_isPointInDigit('1', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('6', nx - 0.38, ny)) return 1;
    } else if (answer == '6') {
      if (_isPointInDigit('6', nx, ny)) return 1;
    } else if (answer == '73') {
      if (_isPointInDigit('7', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('3', nx - 0.38, ny)) return 1;
    } else if (answer == '3') {
      if (_isPointInDigit('3', nx, ny)) return 1;
    } else if (answer == '15') {
      if (_isPointInDigit('1', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('5', nx - 0.38, ny)) return 1;
    } else if (answer == '97') {
      if (_isPointInDigit('9', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('7', nx - 0.38, ny)) return 1;
    } else if (answer == '26') {
      if (_isPointInDigit('2', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('6', nx - 0.38, ny)) return 2;
    } else if (answer == '42') {
      if (_isPointInDigit('4', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('2', nx - 0.38, ny)) return 2;
    } else if (answer == '35') {
      if (_isPointInDigit('3', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('5', nx - 0.38, ny)) return 2;
    } else if (answer == '96') {
      if (_isPointInDigit('9', nx + 0.38, ny)) return 1;
      if (_isPointInDigit('6', nx - 0.38, ny)) return 2;
    } else if (answer == 'BLANK') {
      if (plate.deficiencyAnswer == '5' && _isPointInDigit('5', nx, ny)) return 1;
      if (plate.deficiencyAnswer == '45') {
        if (_isPointInDigit('4', nx + 0.38, ny)) return 1;
        if (_isPointInDigit('5', nx - 0.38, ny)) return 1;
      }
      if (plate.deficiencyAnswer == '2' && _isPointInDigit('2', nx, ny)) return 1;
    }

    return 0;
  }

  // Geometric Digit Hit-Tester
  bool _isPointInDigit(String digit, double x, double y) {
    const double th = 0.16; // stroke thickness
    const double w = 0.34;  // digit half-width
    const double h = 0.55;  // digit half-height

    switch (digit) {
      case '1':
        if (x.abs() < th && y.abs() < h) return true;
        if (y < -h * 0.5 && y > -h && x < 0 && (y + h) > (x + 0.1)) return true;
        return false;

      case '2':
        if (y < -0.1) {
          final dy = y + 0.3;
          final d = math.sqrt(x * x + dy * dy);
          if (d > w - th && d < w + th && y < -0.1) return true;
        }
        if (y >= -0.15 && y <= h - th) {
          final diagX = (w * 0.8) - ((y + 0.15) / (h + 0.15)) * (w * 1.6);
          if ((x - diagX).abs() < th) return true;
        }
        if (y > h - th && y < h + 0.05 && x > -w - 0.05 && x < w + 0.05) return true;
        return false;

      case '3':
        final dyTop = y + 0.28;
        final dTop = math.sqrt(x * x + dyTop * dyTop);
        if (dTop > w - th && dTop < w + th && x > -0.05 && y < 0.05) return true;

        final dyBot = y - 0.28;
        final dBot = math.sqrt(x * x + dyBot * dyBot);
        if (dBot > w - th && dBot < w + th && x > -0.05 && y > -0.05) return true;

        if (y.abs() < th * 0.8 && x > -0.1 && x < w * 0.5) return true;
        return false;

      case '4':
        if (x > w * 0.3 - th && x < w * 0.3 + th && y.abs() < h) return true;
        if (y > 0.05 && y < 0.05 + th * 1.4 && x > -w && x < w * 0.45) return true;
        if (x < 0.1 && y < 0.1) {
          final diag = -w + ((y + h) / (h + 0.1)) * (w + 0.1);
          if ((x - diag).abs() < th) return true;
        }
        return false;

      case '5':
        if (y < -h + th * 1.3 && y > -h - 0.04 && x > -w && x < w) return true;
        if (x > -w && x < -w + th * 1.3 && y >= -h && y <= 0.0) return true;
        final dy5 = y - 0.22;
        final d5 = math.sqrt(x * x + dy5 * dy5);
        if (d5 > w - th && d5 < w + th && (x > -0.1 || y > 0.22)) return true;
        return false;

      case '6':
        final dy6 = y - 0.22;
        final d6 = math.sqrt(x * x + dy6 * dy6);
        if (d6 > w - th && d6 < w + th) return true;
        if (x < 0.0 && y < 0.22) {
          final hookX = -w + (y + h) * 0.35;
          if ((x - hookX).abs() < th) return true;
        }
        if (y < -h + th && x > -w && x < 0.1) return true;
        return false;

      case '7':
        if (y < -h + th * 1.3 && y > -h - 0.04 && x > -w && x < w) return true;
        final diagX = w - ((y + h) / (2 * h)) * (2 * w);
        if ((x - diagX).abs() < th && y > -h) return true;
        return false;

      case '8':
        final dyTop8 = y + 0.26;
        final dTop8 = math.sqrt(x * x + dyTop8 * dyTop8);
        if (dTop8 > (w * 0.85) - th && dTop8 < (w * 0.85) + th) return true;

        final dyBot8 = y - 0.26;
        final dBot8 = math.sqrt(x * x + dyBot8 * dyBot8);
        if (dBot8 > w - th && dBot8 < w + th) return true;
        return false;

      case '9':
        final dy9 = y + 0.22;
        final d9 = math.sqrt(x * x + dy9 * dy9);
        if (d9 > w - th && d9 < w + th) return true;
        if (x > 0.0 && y > -0.22) {
          final hookX = w - (y - 0.2) * 0.35;
          if ((x - hookX).abs() < th) return true;
        }
        if (y > h - th && x > -0.1 && x < w) return true;
        return false;
    }
    return false;
  }

  // Authentic Ishihara Color Palettes
  List<Color> _getBgPalette(PlateType type, int plateNo) {
    if (type == PlateType.introductory) {
      return const [
        Color(0xFF6B7F6D),
        Color(0xFF7A937D),
        Color(0xFF8BA68E),
        Color(0xFF5D6F5F),
        Color(0xFF8FA892),
      ];
    } else if (type == PlateType.transformation || type == PlateType.vanishing) {
      return const [
        Color(0xFF6F8259),
        Color(0xFF86996D),
        Color(0xFF9FB285),
        Color(0xFF5A6D45),
        Color(0xFF7B8E64),
        Color(0xFF8F9E75),
      ];
    } else if (type == PlateType.hiddenDigit) {
      return const [
        Color(0xFFC46B55),
        Color(0xFFD67F68),
        Color(0xFFB85E48),
        Color(0xFF9E4E3A),
        Color(0xFF8D5344),
      ];
    } else {
      return const [
        Color(0xFF858474),
        Color(0xFF9C9B89),
        Color(0xFF6E6D5F),
        Color(0xFFB0AF9D),
        Color(0xFF7A7969),
      ];
    }
  }

  List<Color> _getFigurePalette(PlateType type, int plateNo) {
    if (type == PlateType.introductory) {
      return const [
        Color(0xFFDE5533),
        Color(0xFFE86948),
        Color(0xFFCA4422),
        Color(0xFFF07E5F),
        Color(0xFFB83618),
      ];
    } else if (type == PlateType.transformation || type == PlateType.vanishing) {
      return const [
        Color(0xFFD95338),
        Color(0xFFE26B50),
        Color(0xFFC44329),
        Color(0xFFEE7E65),
        Color(0xFFBD381E),
      ];
    } else if (type == PlateType.hiddenDigit) {
      return const [
        Color(0xFF7B9B6E),
        Color(0xFF8CAD7E),
        Color(0xFF6B8B5E),
        Color(0xFF98B98A),
      ];
    } else {
      return const [
        Color(0xFFD75238),
        Color(0xFFE5694F),
        Color(0xFFC34128),
        Color(0xFFF28067),
      ];
    }
  }

  List<Color> _getSecondaryFigurePalette(PlateType type, int plateNo) {
    return const [
      Color(0xFF9E5785),
      Color(0xFFB56D9B),
      Color(0xFF884370),
      Color(0xFFC781AE),
      Color(0xFF75325D),
    ];
  }

  // Color Matrix Transformations for Color Blindness Simulation
  Color _applyColorVisionFilter(Color c, String filter) {
    final r = (c.r * 255.0).round().clamp(0, 255) / 255.0;
    final g = (c.g * 255.0).round().clamp(0, 255) / 255.0;
    final b = (c.b * 255.0).round().clamp(0, 255) / 255.0;

    double outR, outG, outB;

    switch (filter) {
      case 'protanopia':
        outR = 0.56667 * r + 0.43333 * g + 0.0 * b;
        outG = 0.55833 * r + 0.44167 * g + 0.0 * b;
        outB = 0.0 * r + 0.24167 * g + 0.75833 * b;
        break;

      case 'deuteranopia':
        outR = 0.625 * r + 0.375 * g + 0.0 * b;
        outG = 0.70 * r + 0.30 * g + 0.0 * b;
        outB = 0.0 * r + 0.30 * g + 0.70 * b;
        break;

      case 'tritanopia':
        outR = 0.95 * r + 0.05 * g + 0.0 * b;
        outG = 0.0 * r + 0.43333 * g + 0.56667 * b;
        outB = 0.0 * r + 0.475 * g + 0.525 * b;
        break;

      case 'achromatopsia':
        final gray = 0.299 * r + 0.587 * g + 0.114 * b;
        outR = gray;
        outG = gray;
        outB = gray;
        break;

      default:
        return c;
    }

    final alphaInt = (c.a * 255.0).round().clamp(0, 255);
    return Color.fromARGB(
      alphaInt,
      (outR.clamp(0.0, 1.0) * 255).round(),
      (outG.clamp(0.0, 1.0) * 255).round(),
      (outB.clamp(0.0, 1.0) * 255).round(),
    );
  }
}

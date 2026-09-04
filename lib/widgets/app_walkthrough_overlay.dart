import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class WalkthroughStep {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final IconData icon;

  const WalkthroughStep({
    required this.targetKey,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class AppWalkthroughOverlay extends StatefulWidget {
  final List<WalkthroughStep> steps;
  final VoidCallback onComplete;

  const AppWalkthroughOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
  });

  static void show({
    required BuildContext context,
    required List<WalkthroughStep> steps,
    required VoidCallback onComplete,
  }) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (ctx) => AppWalkthroughOverlay(
        steps: steps,
        onComplete: () {
          overlayEntry.remove();
          onComplete();
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  State<AppWalkthroughOverlay> createState() => _AppWalkthroughOverlayState();
}

class _AppWalkthroughOverlayState extends State<AppWalkthroughOverlay>
    with SingleTickerProviderStateMixin {
  int _currentStepIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Rect? _getTargetRect() {
    if (_currentStepIndex >= widget.steps.length) return null;
    final key = widget.steps[_currentStepIndex].targetKey;
    final context = key.currentContext;
    if (context == null) return null;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return null;

    final offset = renderBox.localToGlobal(Offset.zero);
    const padding = 6.0;
    return Rect.fromLTWH(
      offset.dx - padding,
      offset.dy - padding,
      renderBox.size.width + (padding * 2),
      renderBox.size.height + (padding * 2),
    );
  }

  void _nextStep() {
    if (_currentStepIndex < widget.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      _finish();
    }
  }

  void _finish() {
    _fadeController.reverse().then((_) {
      widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final currentStep = widget.steps[_currentStepIndex];
    final targetRect = _getTargetRect() ??
        Rect.fromCenter(
          center: Offset(screenSize.width / 2, screenSize.height / 2),
          width: 200,
          height: 100,
        );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate dialog position (above or below target)
    final isTargetInLowerHalf = targetRect.center.dy > screenSize.height * 0.55;
    final cardTopPosition = isTargetInLowerHalf
        ? (targetRect.top - 210).clamp(60.0, screenSize.height - 240)
        : (targetRect.bottom + 16).clamp(16.0, screenSize.height - 240);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Spotlight Hole Backdrop
            TweenAnimationBuilder<Rect?>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              tween: RectTween(begin: targetRect, end: targetRect),
              builder: (context, animRect, child) {
                return CustomPaint(
                  size: screenSize,
                  painter: _SpotlightPainter(
                    targetRect: animRect ?? targetRect,
                    borderRadius: 18.0,
                  ),
                );
              },
            ),

            // Step Explanation Dialog Card
            Positioned(
              top: cardTopPosition,
              left: 20,
              right: 20,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(currentStep.icon, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PANDUAN APLIKASI (${_currentStepIndex + 1}/${widget.steps.length})',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    currentStep.title,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          currentStep.description,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.45,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Bottom Actions & Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Dots indicator
                            Row(
                              children: List.generate(widget.steps.length, (idx) {
                                final isActive = idx == _currentStepIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(right: 6),
                                  width: isActive ? 18 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? AppColors.primary
                                        : (isDark ? Colors.white24 : Colors.black12),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),

                            // Action buttons
                            Row(
                              children: [
                                TextButton(
                                  onPressed: _finish,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Lewati',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white54 : Colors.black45,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _nextStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    _currentStepIndex == widget.steps.length - 1
                                        ? 'Mulai Sekarang'
                                        : 'Lanjut',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect targetRect;
  final double borderRadius;

  _SpotlightPainter({
    required this.targetRect,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withAlpha(190)
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final spotlightRRect = RRect.fromRectAndRadius(
      targetRect,
      Radius.circular(borderRadius),
    );

    final spotlightPath = Path()..addRRect(spotlightRRect);

    // Cut out spotlight using PathOperation.difference
    final combinedPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      spotlightPath,
    );

    canvas.drawPath(combinedPath, backgroundPaint);

    // Subtle highlight glowing border around the cut-out
    final borderPaint = Paint()
      ..color = AppColors.primary.withAlpha(160)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(spotlightRRect, borderPaint);
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
        oldDelegate.borderRadius != borderRadius;
  }
}

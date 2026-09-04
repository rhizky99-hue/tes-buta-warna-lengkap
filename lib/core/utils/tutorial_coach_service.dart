import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../constants/app_colors.dart';

class TutorialCoachService {
  static TutorialCoachMark? _currentCoachMark;

  static void showHomeTour({
    required BuildContext context,
    required GlobalKey quickTestKey,
    required GlobalKey fullTestKey,
    required GlobalKey labKey,
    required GlobalKey featuresKey,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    // If already showing, ignore
    if (_currentCoachMark != null) return;

    final targets = <TargetFocus>[
      _buildTarget(
        identify: 'quick_test',
        keyTarget: quickTestKey,
        stepNumber: 1,
        totalSteps: 4,
        title: 'Tes Cepat (12 Pelat)',
        description:
            'Skrining kilat Ishihara dalam waktu kurang dari 2 menit. Sangat cocok untuk evaluasi visual berkala.',
        icon: Icons.flash_on_rounded,
        iconColor: AppColors.secondary,
        align: ContentAlign.bottom,
      ),
      _buildTarget(
        identify: 'full_test',
        keyTarget: fullTestKey,
        stepNumber: 2,
        totalSteps: 4,
        title: 'Tes Lengkap (24 Pelat)',
        description:
            'Standar diagnosis akurat untuk seleksi kedinasan (TNI, POLRI, KAI) serta klasifikasi Protanopia vs Deuteranopia.',
        icon: Icons.verified_rounded,
        iconColor: AppColors.primary,
        align: ContentAlign.bottom,
      ),
      _buildTarget(
        identify: 'lab_methods',
        keyTarget: labKey,
        stepNumber: 3,
        totalSteps: 4,
        title: 'Laboratorium Oftalmologi',
        description:
            'Eksplorasi 4 metode klinis komprehensif: Tes HRR (Bentuk), Farnsworth 100-Hue, Nagel Anomaloskop, & Tes Cambridge.',
        icon: Icons.science_rounded,
        iconColor: Colors.tealAccent,
        align: ContentAlign.top,
      ),
      _buildTarget(
        identify: 'features_grid',
        keyTarget: featuresKey,
        stepNumber: 4,
        totalSteps: 4,
        title: 'Fitur & Eksplorasi',
        description:
            'Akses Simulator Penglihatan Warna, arsip riwayat tes offline, dan ringkasan persyaratan kesehatan mata kedinasan.',
        icon: Icons.grid_view_rounded,
        iconColor: Colors.deepPurpleAccent,
        align: ContentAlign.top,
      ),
    ];

    _currentCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF030712),
      textSkip: 'LEWATI',
      textStyleSkip: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      paddingFocus: 8,
      opacityShadow: 0.85,
      pulseEnable: true,
      onFinish: () {
        _currentCoachMark = null;
        onFinish?.call();
      },
      onSkip: () {
        _currentCoachMark = null;
        onSkip?.call();
        return true;
      },
    )..show(context: context);
  }

  static TargetFocus _buildTarget({
    required String identify,
    required GlobalKey keyTarget,
    required int stepNumber,
    required int totalSteps,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required ContentAlign align,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: keyTarget,
      alignSkip: Alignment.topRight,
      shape: ShapeLightFocus.RRect,
      radius: 18,
      paddingFocus: 6,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            final isLast = stepNumber == totalSteps;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withAlpha(30),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(120),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
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
                          color: iconColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(40),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'LANGKAH $stepNumber DARI $totalSteps',
                                style: const TextStyle(
                                  color: AppColors.primaryLight,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isLast)
                        TextButton(
                          onPressed: () {
                            controller.skip();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white60,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Lewati'),
                        ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          controller.next();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(isLast ? 'Selesai' : 'Lanjut'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

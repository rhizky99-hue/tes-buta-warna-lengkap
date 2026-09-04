import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AnomaloscopeScreen extends StatefulWidget {
  const AnomaloscopeScreen({super.key});

  @override
  State<AnomaloscopeScreen> createState() => _AnomaloscopeScreenState();
}

class _AnomaloscopeScreenState extends State<AnomaloscopeScreen> {
  // Nagel Anomaloscope standard parameters:
  // Mixture scale: 0 (pure green 546nm) to 73 (pure red 671nm). Normal match ~40-42.
  // Yellow luminance scale: 0 (dark) to 35 (bright 589nm). Normal match ~15-17.
  double _redGreenRatio = 22.0;
  double _yellowBrightness = 24.0;

  void _randomizeSliders() {
    final random = math.Random();
    setState(() {
      _redGreenRatio = 8.0 + random.nextInt(56);
      _yellowBrightness = 6.0 + random.nextInt(23);
    });
  }

  Color _getUpperMixtureColor() {
    final fractionRed = (_redGreenRatio / 73.0).clamp(0.0, 1.0);
    final r = (fractionRed * 255).round();
    final g = ((1.0 - fractionRed * 0.85) * 220).round();
    return Color.fromARGB(255, r, g, 10);
  }

  Color _getLowerYellowColor() {
    final fractionLum = (_yellowBrightness / 35.0).clamp(0.05, 1.0);
    final r = (245 * fractionLum).round();
    final g = (205 * fractionLum).round();
    final b = (20 * fractionLum).round();
    return Color.fromARGB(255, r, g, b);
  }

  void _evaluateMatch() {
    final rgDiff = (_redGreenRatio - 41.0).abs();
    final yDiff = (_yellowBrightness - 16.0).abs();

    double aq = 1.0;
    if (_redGreenRatio > 1 && _redGreenRatio < 72) {
      final userRatio = (73.0 - _redGreenRatio) / _redGreenRatio;
      const normalRatio = (73.0 - 41.0) / 41.0;
      aq = userRatio / normalRatio;
    }

    String title;
    String desc;
    Color color;

    if (rgDiff <= 4.5 && yDiff <= 3.5) {
      title = 'Kecocokan Normal (Trichromat Sempurna)';
      desc = 'Pilihan campuran warna Anda (R-G: ${_redGreenRatio.toStringAsFixed(1)}, Kuning: ${_yellowBrightness.toStringAsFixed(1)}) berada di rentang Rayleigh Match standar mata normal (AQ ≈ ${aq.toStringAsFixed(2)}).';
      color = AppColors.success;
    } else if (_redGreenRatio > 46.0) {
      title = 'Kecocokan Bergeser ke Merah (Protanomali)';
      desc = 'Anda menambahkan proporsi cahaya merah berlebih untuk mencocokkan warna kuning (AQ ≈ ${aq.toStringAsFixed(2)}), mengindikasikan defisiensi sel kerucut merah.';
      color = Colors.redAccent;
    } else if (_redGreenRatio < 36.0) {
      title = 'Kecocokan Bergeser ke Hijau (Deuteranomali)';
      desc = 'Anda menambahkan proporsi cahaya hijau berlebih untuk mencocokkan warna kuning (AQ ≈ ${aq.toStringAsFixed(2)}), mengindikasikan defisiensi sel kerucut hijau.';
      color = Colors.green;
    } else {
      title = 'Ketidakcocokan Luminansi (Kecerahan)';
      desc = 'Keseimbangan rona warna mendekati normal, namun intensitas cahaya kuning belum seimbang dengan campuran cahaya atas.';
      color = Colors.amber.shade800;
    }

    _showResultDialog(title, desc, color, aq);
  }

  void _showResultDialog(String title, String desc, Color color, double aq) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.tune_rounded, color: color, size: 38),
                ),
                const SizedBox(height: 12),
                Text(
                  'Evaluasi Rayleigh Match (Anomaloskop)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3, color: color),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Rasio R-G: ${_redGreenRatio.toStringAsFixed(1)}/73 • Kuning: ${_yellowBrightness.toStringAsFixed(1)}/35 • AQ: ${aq.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Lanjutkan Penyesuaian'),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Nagel Anomaloskop'),
        actions: [
          IconButton(
            tooltip: 'Acak Posisi',
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: _randomizeSliders,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                children: [
                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.biotech_rounded, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cocokkan warna bidang atas (campuran Merah-Hijau) dengan bidang bawah (Kuning Spektral) sampai keduanya tampak seragam.',
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.4,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Eyepiece Optical Viewport
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                      border: Border.all(color: const Color(0xFF334155), width: 6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(80),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              color: _getUpperMixtureColor(),
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Merah + Hijau',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 1.5, color: Colors.black),
                          Expanded(
                            child: Container(
                              color: _getLowerYellowColor(),
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Kuning (589nm)',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Slider 1: Red-Green
                  _AnomaloscopeSliderCard(
                    title: 'Rasio Merah - Hijau (0 - 73)',
                    valueText: _redGreenRatio.toStringAsFixed(1),
                    valueColor: AppColors.primary,
                    sliderValue: _redGreenRatio,
                    min: 0,
                    max: 73,
                    divisions: 73,
                    activeTrackColor: Colors.redAccent,
                    inactiveTrackColor: Colors.green,
                    leftLabel: 'Hijau (0)',
                    centerLabel: 'Normal (~41)',
                    rightLabel: 'Merah (73)',
                    isDark: isDark,
                    onChanged: (val) => setState(() => _redGreenRatio = val),
                  ),

                  const SizedBox(height: 10),

                  // Slider 2: Yellow Luminance
                  _AnomaloscopeSliderCard(
                    title: 'Kecerahan Kuning (0 - 35)',
                    valueText: _yellowBrightness.toStringAsFixed(1),
                    valueColor: Colors.amber.shade700,
                    sliderValue: _yellowBrightness,
                    min: 0,
                    max: 35,
                    divisions: 35,
                    activeTrackColor: Colors.amber,
                    inactiveTrackColor: Colors.grey.shade400,
                    leftLabel: 'Redup (0)',
                    centerLabel: 'Normal (~16)',
                    rightLabel: 'Terang (35)',
                    isDark: isDark,
                    onChanged: (val) => setState(() => _yellowBrightness = val),
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton.icon(
                    onPressed: _evaluateMatch,
                    icon: const Icon(Icons.check_circle_rounded, size: 18),
                    label: const Text('Evaluasi Kecocokan Warna'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Sub-Widget: Anomaloscope Slider Card
class _AnomaloscopeSliderCard extends StatelessWidget {
  final String title;
  final String valueText;
  final Color valueColor;
  final double sliderValue;
  final double min;
  final double max;
  final int divisions;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final String leftLabel;
  final String centerLabel;
  final String rightLabel;
  final bool isDark;
  final ValueChanged<double> onChanged;

  const _AnomaloscopeSliderCard({
    required this.title,
    required this.valueText,
    required this.valueColor,
    required this.sliderValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.leftLabel,
    required this.centerLabel,
    required this.rightLabel,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
              Text(
                valueText,
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: valueColor),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeTrackColor,
              inactiveTrackColor: inactiveTrackColor,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 4,
            ),
            child: Slider(
              value: sliderValue,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftLabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(centerLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
              Text(rightLabel, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

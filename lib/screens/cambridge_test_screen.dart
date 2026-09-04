import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../widgets/cambridge_canvas.dart';

class _CCTTrial {
  final CambridgeGapDirection gap;
  final CambridgeConfusionAxis axis;
  final double saturation;
  final int seed;

  const _CCTTrial({
    required this.gap,
    required this.axis,
    required this.saturation,
    required this.seed,
  });
}

class CambridgeTestScreen extends StatefulWidget {
  const CambridgeTestScreen({super.key});

  @override
  State<CambridgeTestScreen> createState() => _CambridgeTestScreenState();
}

class _CambridgeTestScreenState extends State<CambridgeTestScreen> {
  late List<_CCTTrial> _trials;
  int _currentTrialIndex = 0;
  int _correctCount = 0;
  final Map<CambridgeConfusionAxis, int> _axisCorrect = {
    CambridgeConfusionAxis.protan: 0,
    CambridgeConfusionAxis.deutan: 0,
    CambridgeConfusionAxis.tritan: 0,
  };
  final Map<CambridgeConfusionAxis, int> _axisTotal = {
    CambridgeConfusionAxis.protan: 0,
    CambridgeConfusionAxis.deutan: 0,
    CambridgeConfusionAxis.tritan: 0,
  };

  @override
  void initState() {
    super.initState();
    _initTrials();
  }

  void _initTrials() {
    final random = math.Random(12345);
    const directions = CambridgeGapDirection.values;

    List<_CCTTrial> trials = [];
    const axes = [
      CambridgeConfusionAxis.protan,
      CambridgeConfusionAxis.deutan,
      CambridgeConfusionAxis.tritan,
    ];

    for (int i = 0; i < 2; i++) {
      for (final axis in axes) {
        final dir = directions[random.nextInt(directions.length)];
        final sat = i == 0 ? 0.75 : 0.45;
        trials.add(_CCTTrial(
          gap: dir,
          axis: axis,
          saturation: sat,
          seed: 200 + trials.length,
        ));
      }
    }

    trials.shuffle(random);

    setState(() {
      _trials = trials;
      _currentTrialIndex = 0;
      _correctCount = 0;
      _axisCorrect[CambridgeConfusionAxis.protan] = 0;
      _axisCorrect[CambridgeConfusionAxis.deutan] = 0;
      _axisCorrect[CambridgeConfusionAxis.tritan] = 0;
      _axisTotal[CambridgeConfusionAxis.protan] = trials.where((t) => t.axis == CambridgeConfusionAxis.protan).length;
      _axisTotal[CambridgeConfusionAxis.deutan] = trials.where((t) => t.axis == CambridgeConfusionAxis.deutan).length;
      _axisTotal[CambridgeConfusionAxis.tritan] = trials.where((t) => t.axis == CambridgeConfusionAxis.tritan).length;
    });
  }

  void _submitDirection(CambridgeGapDirection selectedDir) {
    final current = _trials[_currentTrialIndex];
    final isCorrect = (selectedDir == current.gap);

    if (isCorrect) {
      _correctCount++;
      _axisCorrect[current.axis] = (_axisCorrect[current.axis] ?? 0) + 1;
    }

    if (_currentTrialIndex < _trials.length - 1) {
      setState(() {
        _currentTrialIndex++;
      });
    } else {
      _finishTest();
    }
  }

  void _finishTest() {
    final total = _trials.length;
    final pct = (_correctCount / total) * 100;

    String diagnosis;
    String desc;
    Color statusColor;

    if (pct >= 80) {
      diagnosis = 'Sensitivitas Kromatik Komputerisasi Normal';
      desc = 'Anda berhasil mendeteksi orientasi celah cincin Landolt C dengan akurat pada ketiga vektor sumbu warna (Protan, Deutan, dan Tritan).';
      statusColor = AppColors.success;
    } else {
      final protanPct = (_axisCorrect[CambridgeConfusionAxis.protan]! / _axisTotal[CambridgeConfusionAxis.protan]!);
      final deutanPct = (_axisCorrect[CambridgeConfusionAxis.deutan]! / _axisTotal[CambridgeConfusionAxis.deutan]!);
      final tritanPct = (_axisCorrect[CambridgeConfusionAxis.tritan]! / _axisTotal[CambridgeConfusionAxis.tritan]!);

      if (protanPct < 0.5) {
        diagnosis = 'Ambang Batas Vektor Protan Meningkat';
        desc = 'Ditemukan kesulitan mengenali celah cincin pada spektrum merah (Protan deficiency).';
        statusColor = AppColors.error;
      } else if (deutanPct < 0.5) {
        diagnosis = 'Ambang Batas Vektor Deutan Meningkat';
        desc = 'Ditemukan kesulitan mengenali celah cincin pada spektrum hijau (Deutan deficiency).';
        statusColor = AppColors.error;
      } else if (tritanPct < 0.5) {
        diagnosis = 'Ambang Batas Vektor Tritan Meningkat';
        desc = 'Ditemukan kesulitan mengenali celah cincin pada spektrum biru-kuning (Tritan deficiency).';
        statusColor = Colors.orange;
      } else {
        diagnosis = 'Sensitivitas Kromatik Menurun';
        desc = 'Ditemukan penurunan ambang diskriminasi kontras warna komputerisasi.';
        statusColor = Colors.orange;
      }
    }

    _showResultDialog(diagnosis, desc, statusColor);
  }

  void _showResultDialog(String title, String desc, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
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
                  child: Icon(Icons.computer_rounded, color: color, size: 38),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hasil Cambridge Colour Test',
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
                    'Akurasi: $_correctCount / ${_trials.length} Uji Benar (${((_correctCount / _trials.length) * 100).toStringAsFixed(0)}%)',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _initTrials();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Ulangi Tes'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Selesai'),
                      ),
                    ),
                  ],
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
    final trial = _trials[_currentTrialIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (_currentTrialIndex + 1) / _trials.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambridge Colour Test'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark ? AppColors.cardDark : AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // Status bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Uji ${_currentTrialIndex + 1} dari ${_trials.length}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                      Text(
                        'Vektor: ${trial.axis.name.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                // Canvas Area
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final canvasSize = (constraints.maxWidth < constraints.maxHeight
                                  ? constraints.maxWidth
                                  : constraints.maxHeight) *
                              0.86;
                          return CambridgeCanvas(
                            gapDirection: trial.gap,
                            axis: trial.axis,
                            chromaticSaturation: trial.saturation,
                            seed: trial.seed,
                            size: canvasSize.clamp(230.0, 320.0),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    'Ke mana arah celah (bukaan) huruf C di atas?',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),

                // Directional Pad
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    children: [
                      _DirectionButton(
                        direction: CambridgeGapDirection.up,
                        icon: Icons.keyboard_arrow_up_rounded,
                        label: 'Atas',
                        isDark: isDark,
                        onTap: () => _submitDirection(CambridgeGapDirection.up),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _DirectionButton(
                            direction: CambridgeGapDirection.left,
                            icon: Icons.keyboard_arrow_left_rounded,
                            label: 'Kiri',
                            isDark: isDark,
                            onTap: () => _submitDirection(CambridgeGapDirection.left),
                          ),
                          const SizedBox(width: 32),
                          _DirectionButton(
                            direction: CambridgeGapDirection.right,
                            icon: Icons.keyboard_arrow_right_rounded,
                            label: 'Kanan',
                            isDark: isDark,
                            onTap: () => _submitDirection(CambridgeGapDirection.right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _DirectionButton(
                        direction: CambridgeGapDirection.down,
                        icon: Icons.keyboard_arrow_down_rounded,
                        label: 'Bawah',
                        isDark: isDark,
                        onTap: () => _submitDirection(CambridgeGapDirection.down),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Sub-Widget: Direction Button
class _DirectionButton extends StatelessWidget {
  final CambridgeGapDirection direction;
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _DirectionButton({
    required this.direction,
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.cardDark : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 86,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: AppColors.primary),
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

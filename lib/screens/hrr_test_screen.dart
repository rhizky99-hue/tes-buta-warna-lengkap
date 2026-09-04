import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/hrr_dataset.dart';
import '../data/models/hrr_plate.dart';
import '../widgets/hrr_canvas.dart';

class HRRTestScreen extends StatefulWidget {
  const HRRTestScreen({super.key});

  @override
  State<HRRTestScreen> createState() => _HRRTestScreenState();
}

class _HRRTestScreenState extends State<HRRTestScreen> {
  final List<HRRPlate> _plates = HRRDataset.plates;
  int _currentIndex = 0;
  final List<HRRShape> _selectedShapes = [];
  final Map<int, List<HRRShape>> _userAnswers = {};

  void _toggleShape(HRRShape shape) {
    setState(() {
      if (_selectedShapes.contains(shape)) {
        _selectedShapes.remove(shape);
      } else {
        _selectedShapes.add(shape);
      }
    });
  }

  void _submitBlank() {
    setState(() {
      _selectedShapes.clear();
      _nextPlate();
    });
  }

  void _confirmSelection() {
    _nextPlate();
  }

  void _nextPlate() {
    _userAnswers[_plates[_currentIndex].id] = List.from(_selectedShapes);
    _selectedShapes.clear();

    if (_currentIndex < _plates.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishTest();
    }
  }

  void _finishTest() {
    int correctCount = 0;
    int rgFailed = 0;
    int byFailed = 0;

    for (final plate in _plates) {
      final answer = _userAnswers[plate.id] ?? [];
      final isCorrect = plate.matchesAnswer(answer);
      if (isCorrect) {
        correctCount++;
      } else {
        if (plate.category == HRRPlateCategory.screeningRedGreen ||
            plate.category == HRRPlateCategory.diagnosticProtan ||
            plate.category == HRRPlateCategory.diagnosticDeutan) {
          rgFailed++;
        } else if (plate.category == HRRPlateCategory.screeningBlueYellow ||
            plate.category == HRRPlateCategory.diagnosticTritan) {
          byFailed++;
        }
      }
    }

    String diagnosis;
    String description;
    Color statusColor;

    if (correctCount >= 9) {
      diagnosis = 'Penglihatan Warna Normal (Trichromat)';
      description = 'Anda berhasil mengenali simbol geometris HRR dengan tepat baik pada spektrum merah-hijau maupun biru-kuning.';
      statusColor = AppColors.success;
    } else if (rgFailed > byFailed) {
      diagnosis = 'Indikasi Gangguan Merah-Hijau';
      description = 'Ditemukan kesulitan mengenali simbol pada pelat skrining merah-hijau (Protan/Deutan).';
      statusColor = AppColors.error;
    } else if (byFailed > rgFailed) {
      diagnosis = 'Indikasi Gangguan Biru-Kuning (Tritan)';
      description = 'Ditemukan kesulitan mengenali simbol pada pelat skrining biru-kuning (Tritanopia/Tritanomali).';
      statusColor = Colors.orange;
    } else {
      diagnosis = 'Indikasi Gangguan Penglihatan Warna';
      description = 'Terdapat ketidaksesuaian pembacaan bentuk pada pelat skrining HRR.';
      statusColor = Colors.orange;
    }

    _showResultDialog(diagnosis, description, correctCount, statusColor);
  }

  void _showResultDialog(String title, String desc, int score, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
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
                  child: Icon(
                    score >= 9 ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                    color: color,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hasil Pemeriksaan HRR',
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Skor Akurasi: $score / ${_plates.length} Pelat Benar (${((score / _plates.length) * 100).toStringAsFixed(0)}%)',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
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
                          setState(() {
                            _currentIndex = 0;
                            _selectedShapes.clear();
                            _userAnswers.clear();
                          });
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
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plate = _plates[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (_currentIndex + 1) / _plates.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes HRR (Bentuk Geometris)'),
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
                // Top Status Bar
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
                          'Pelat ${_currentIndex + 1} dari ${_plates.length}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                      Text(
                        plate.category == HRRPlateCategory.demonstration
                            ? 'Pengenalan'
                            : plate.category == HRRPlateCategory.screeningBlueYellow ||
                                    plate.category == HRRPlateCategory.diagnosticTritan
                                ? 'Skrining Biru-Kuning'
                                : 'Skrining Merah-Hijau',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                // Canvas Plate Area
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
                          return HRRCanvas(
                            plate: plate,
                            size: canvasSize.clamp(230.0, 320.0),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Instructions text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Text(
                    'Pilih bentuk yang Anda lihat di dalam pelat:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),

                // Shape Selection Pad
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    children: [
                      _ShapeButton(
                        shape: HRRShape.circle,
                        label: 'Lingkaran',
                        icon: Icons.circle_outlined,
                        isSelected: _selectedShapes.contains(HRRShape.circle),
                        isDark: isDark,
                        onTap: () => _toggleShape(HRRShape.circle),
                      ),
                      const SizedBox(width: 8),
                      _ShapeButton(
                        shape: HRRShape.triangle,
                        label: 'Segitiga',
                        icon: Icons.change_history_rounded,
                        isSelected: _selectedShapes.contains(HRRShape.triangle),
                        isDark: isDark,
                        onTap: () => _toggleShape(HRRShape.triangle),
                      ),
                      const SizedBox(width: 8),
                      _ShapeButton(
                        shape: HRRShape.cross,
                        label: 'Silang',
                        icon: Icons.close_rounded,
                        isSelected: _selectedShapes.contains(HRRShape.cross),
                        isDark: isDark,
                        onTap: () => _toggleShape(HRRShape.cross),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: OutlinedButton.icon(
                          onPressed: _submitBlank,
                          icon: const Icon(Icons.visibility_off_outlined, size: 16),
                          label: const Text('Tidak Ada'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          onPressed: _selectedShapes.isNotEmpty ? _confirmSelection : null,
                          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                          label: Text(
                            _selectedShapes.isEmpty
                                ? 'Pilih Simbol'
                                : 'Lanjut (${_selectedShapes.length})',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Sub-Widget: Shape Button
class _ShapeButton extends StatelessWidget {
  final HRRShape shape;
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ShapeButton({
    required this.shape,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected
            ? AppColors.primary.withAlpha(isDark ? 40 : 20)
            : (isDark ? AppColors.cardDark : Colors.white),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
                width: isSelected ? 1.8 : 1.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

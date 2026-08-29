import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/ishihara_dataset.dart';
import '../widgets/ishihara_canvas.dart';

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  String _selectedFilter = 'normal'; // 'normal', 'protanopia', 'deuteranopia', 'tritanopia', 'achromatopsia'
  int _selectedPlateIndex = 1; // Plate 2 (8->3)

  final Map<String, Map<String, dynamic>> _filterInfo = {
    'normal': {
      'title': 'Penglihatan Normal',
      'subtitle': 'Trichromacy',
      'desc': 'Memiliki ketiga jenis sel kerucut (L, M, S) yang berfungsi sempurna untuk menangkap jutaan variasi warna.',
      'color': AppColors.success,
    },
    'protanopia': {
      'title': 'Protanopia',
      'subtitle': 'Buta Warna Merah',
      'desc': 'Sel kerucut L (merah) tidak berfungsi. Warna merah tampak gelap, kecokelatan, atau menyerupai hijau kusam.',
      'color': AppColors.protanColor,
    },
    'deuteranopia': {
      'title': 'Deuteranopia',
      'subtitle': 'Buta Warna Hijau',
      'desc': 'Sel kerucut M (hijau) tidak berfungsi. Ini adalah tipe buta warna paling umum; hijau dan merah sering tertukar.',
      'color': AppColors.deutanColor,
    },
    'tritanopia': {
      'title': 'Tritanopia',
      'subtitle': 'Buta Warna Biru-Kuning',
      'desc': 'Sel kerucut S (biru) tidak berfungsi (sangat langka). Biru tampak kehijauan dan kuning tampak merah muda/abu.',
      'color': AppColors.tritanColor,
    },
    'achromatopsia': {
      'title': 'Achromatopsia',
      'subtitle': 'Buta Warna Total',
      'desc': 'Seluruh sel kerucut tidak aktif. Dunia hanya terlihat dalam skala abu-abu (hitam, putih, abu-abu).',
      'color': AppColors.monoColor,
    },
  };

  final List<Map<String, dynamic>> _sampleColors = [
    {'name': 'Merah', 'color': const Color(0xFFEF4444)},
    {'name': 'Oranye', 'color': const Color(0xFFF97316)},
    {'name': 'Kuning', 'color': const Color(0xFFEAB308)},
    {'name': 'Hijau', 'color': const Color(0xFF22C55E)},
    {'name': 'Biru', 'color': const Color(0xFF3B82F6)},
    {'name': 'Ungu', 'color': const Color(0xFFA855F7)},
  ];

  Color _simulate(Color c, String filter) {
    if (filter == 'normal') return c;
    final r = (c.r * 255.0).round().clamp(0, 255) / 255.0;
    final g = (c.g * 255.0).round().clamp(0, 255) / 255.0;
    final b = (c.b * 255.0).round().clamp(0, 255) / 255.0;

    double outR, outG, outB;
    switch (filter) {
      case 'protanopia':
        outR = 0.56667 * r + 0.43333 * g;
        outG = 0.55833 * r + 0.44167 * g;
        outB = 0.24167 * g + 0.75833 * b;
        break;
      case 'deuteranopia':
        outR = 0.625 * r + 0.375 * g;
        outG = 0.70 * r + 0.30 * g;
        outB = 0.30 * g + 0.70 * b;
        break;
      case 'tritanopia':
        outR = 0.95 * r + 0.05 * g;
        outG = 0.43333 * g + 0.56667 * b;
        outB = 0.475 * g + 0.525 * b;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentInfo = _filterInfo[_selectedFilter]!;
    final plate = IshiharaDataset.allPlates[_selectedPlateIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulator Penglihatan Warna'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Selector Chips
            const Text(
              'Pilih Jenis Penglihatan:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterInfo.entries.map((entry) {
                  final key = entry.key;
                  final info = entry.value;
                  final isSelected = _selectedFilter == key;
                  final color = info['color'] as Color;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(info['title'] as String),
                      selectedColor: color.withAlpha(40),
                      checkmarkColor: color,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? color : (isDark ? Colors.white70 : Colors.black87),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = key;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Filter Explanation Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (currentInfo['color'] as Color).withAlpha(80),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (currentInfo['color'] as Color).withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.remove_red_eye_rounded, color: currentInfo['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentInfo['title'] as String,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            currentInfo['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentInfo['desc'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Live Ishihara Plate Simulation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Simulasi pada Pelat Ishihara:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                DropdownButton<int>(
                  value: _selectedPlateIndex,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Pelat 1 (12)')),
                    DropdownMenuItem(value: 1, child: Text('Pelat 2 (8->3)')),
                    DropdownMenuItem(value: 2, child: Text('Pelat 3 (5->2)')),
                    DropdownMenuItem(value: 3, child: Text('Pelat 4 (29->70)')),
                    DropdownMenuItem(value: 5, child: Text('Pelat 6 (7)')),
                    DropdownMenuItem(value: 11, child: Text('Pelat 12 (26)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedPlateIndex = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            Center(
              child: IshiharaCanvas(
                key: ValueKey('sim_${plate.id}_$_selectedFilter'),
                plate: plate,
                size: 240,
                visionFilter: _selectedFilter == 'normal' ? null : _selectedFilter,
              ),
            ),

            const SizedBox(height: 20),

            // Spectrum Comparison Grid
            const Text(
              'Perbandingan Palet Spektrum Warna:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _sampleColors.length,
              itemBuilder: (context, idx) {
                final item = _sampleColors[idx];
                final baseColor = item['color'] as Color;
                final simulated = _simulate(baseColor, _selectedFilter);

                return Container(
                  decoration: BoxDecoration(
                    color: simulated,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

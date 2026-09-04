import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class HueTile {
  final int idealIndex;
  final Color color;

  HueTile(this.idealIndex, this.color);
}

class FarnsworthTestScreen extends StatefulWidget {
  const FarnsworthTestScreen({super.key});

  @override
  State<FarnsworthTestScreen> createState() => _FarnsworthTestScreenState();
}

class _FarnsworthTestScreenState extends State<FarnsworthTestScreen> {
  late final HueTile _anchorTile;
  late List<HueTile> _userTiles;
  int? _selectedTileIndex;
  int _totalErrorScore = 0;
  String _diagnosis = '';
  String _axisResult = '';

  @override
  void initState() {
    super.initState();
    _initTest();
  }

  void _initTest() {
    const int total = 12;
    List<HueTile> allTiles = [];

    for (int i = 0; i < total; i++) {
      final double hue = (i * (360.0 / total)) % 360.0;
      final hsv = HSVColor.fromAHSV(1.0, hue, 0.65, 0.85);
      allTiles.add(HueTile(i, hsv.toColor()));
    }

    _anchorTile = allTiles.first;

    final movable = allTiles.sublist(1);
    final random = math.Random();
    movable.shuffle(random);

    setState(() {
      _userTiles = movable;
      _selectedTileIndex = null;
    });
  }

  void _onTileTapped(int index) {
    if (_selectedTileIndex == null) {
      setState(() {
        _selectedTileIndex = index;
      });
    } else {
      if (_selectedTileIndex == index) {
        setState(() {
          _selectedTileIndex = null;
        });
      } else {
        setState(() {
          final temp = _userTiles[_selectedTileIndex!];
          _userTiles[_selectedTileIndex!] = _userTiles[index];
          _userTiles[index] = temp;
          _selectedTileIndex = null;
        });
      }
    }
  }

  void _calculateScore() {
    final fullSequence = [_anchorTile, ..._userTiles];
    int errorScore = 0;

    for (int i = 0; i < fullSequence.length - 1; i++) {
      final diff = (fullSequence[i + 1].idealIndex - fullSequence[i].idealIndex).abs();
      if (diff > 1) {
        errorScore += (diff - 1);
      }
    }

    String diag;
    String axis;
    if (errorScore == 0) {
      diag = 'Diskriminasi Warna Sempurna (Superior)';
      axis = 'Seluruh urutan gradasi warna tersusun dengan 100% tepat tanpa kekeliruan.';
    } else if (errorScore <= 4) {
      diag = 'Diskriminasi Normal (Normal Trichromat)';
      axis = 'Kemampuan membedakan variasi nuansa warna berada dalam batas normal klinis.';
    } else if (errorScore <= 9) {
      diag = 'Defisiensi Diskriminasi Warna Ringan';
      axis = 'Ditemukan beberapa kekeliruan kecil pada spektrum gradasi warna yang saling berdekatan.';
    } else {
      diag = 'Defisiensi Diskriminasi Warna Signifikan';
      axis = 'Ditemukan pola pertukaran warna lintas spektrum yang mengindikasikan defisiensi sel kerucut.';
    }

    setState(() {
      _totalErrorScore = errorScore;
      _diagnosis = diag;
      _axisResult = axis;
    });

    _showResultDialog();
  }

  void _showResultDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGood = _totalErrorScore <= 4;
    final color = isGood ? AppColors.success : (_totalErrorScore <= 9 ? Colors.orange : AppColors.error);

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
                  child: Icon(
                    isGood ? Icons.verified_rounded : Icons.palette_outlined,
                    color: color,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hasil Farnsworth Hue Test',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _diagnosis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
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
                    'Total Error Score (TES): $_totalErrorScore ${isGood ? '(Sangat Baik)' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _axisResult,
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
                          _initTest();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Acak & Coba Lagi'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farnsworth-Munsell Hue Test'),
        actions: [
          IconButton(
            tooltip: 'Acak Ulang',
            icon: const Icon(Icons.refresh_rounded, size: 22),
            onPressed: _initTest,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Guide Card
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
                          child: const Icon(Icons.touch_app_rounded, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Petunjuk Penyusunan:',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Ketuk satu keping warna, lalu ketuk keping lain untuk menukar posisi sampai terbentuk gradasi pelangi yang halus dari Keping Jangkar ke kanan.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.4,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Anchor Cap Indicator
                  Row(
                    children: [
                      const Text(
                        'Keping Jangkar (Tetap):',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: _anchorTile.color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.lock_rounded, color: Colors.white, size: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Keping Gradasi (Ketuk untuk Menukar Urutan):',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),

                  // Interactive Hue Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final tileSize = ((constraints.maxWidth - (3 * 10)) / 4).clamp(64.0, 90.0);

                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(_userTiles.length, (index) {
                          final tile = _userTiles[index];
                          final isSelected = _selectedTileIndex == index;

                          return _HueTileCard(
                            tile: tile,
                            index: index,
                            size: tileSize,
                            isSelected: isSelected,
                            onTap: () => _onTileTapped(index),
                          );
                        }),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _initTest,
                          icon: const Icon(Icons.shuffle_rounded, size: 16),
                          label: const Text('Acak Ulang'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _calculateScore,
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: const Text('Evaluasi Gradasi'),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Sub-Widget: Hue Tile Card
class _HueTileCard extends StatelessWidget {
  final HueTile tile;
  final int index;
  final double size;
  final bool isSelected;
  final VoidCallback onTap;

  const _HueTileCard({
    required this.tile,
    required this.index,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: tile.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.black12,
            width: isSelected ? 3.0 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: tile.color.withAlpha(150),
                blurRadius: 10,
                spreadRadius: 1.5,
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                shadows: [
                  Shadow(color: Colors.black45, blurRadius: 4),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.swap_horiz_rounded, size: 12, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/local_storage_service.dart';
import 'test_runner_screen.dart';

class TestIntroScreen extends StatefulWidget {
  final String testMode; // 'quick' or 'full'

  const TestIntroScreen({super.key, required this.testMode});

  @override
  State<TestIntroScreen> createState() => _TestIntroScreenState();
}

class _TestIntroScreenState extends State<TestIntroScreen> {
  int _timerSeconds = 0; // 0 = no limit, 3s, 5s

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final timer = await LocalStorageService().getTimerDuration();
    if (mounted) {
      setState(() {
        _timerSeconds = timer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isQuick = widget.testMode == 'quick';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isQuick ? 'Petunjuk Tes Cepat' : 'Petunjuk Tes Lengkap'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mode Header Card
                    Container(
                      padding: const EdgeInsets.all(18),
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
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isQuick ? Icons.flash_on_rounded : Icons.verified_rounded,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isQuick ? 'Tes Cepat (12 Pelat)' : 'Tes Lengkap (24 Pelat)',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  isQuick
                                      ? 'Estimasi waktu: ~1 - 2 menit'
                                      : 'Estimasi waktu: ~3 - 4 menit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Preparation Steps
                    const Text(
                      'Persiapan Sebelum Tes (Standar Medis)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),

                    _buildPrepItem(
                      icon: Icons.brightness_high_rounded,
                      title: 'Atur Kecerahan Layar',
                      desc: 'Tingkatkan kecerahan layar ke 70% - 100% agar kontras warna optimal.',
                      isDark: isDark,
                    ),
                    _buildPrepItem(
                      icon: Icons.nightlight_round,
                      title: 'Matikan Filter Cahaya Biru',
                      desc: 'Nonaktifkan Night Light / Reading Mode agar warna tidak terdistorsi menjadi kekuningan.',
                      isDark: isDark,
                    ),
                    _buildPrepItem(
                      icon: Icons.straighten_rounded,
                      title: 'Jarak Pandang Ideal',
                      desc: 'Posisikan smartphone tegak lurus sejauh 75 cm (jarak rentang lengan) dari mata.',
                      isDark: isDark,
                    ),
                    _buildPrepItem(
                      icon: Icons.timer_outlined,
                      title: 'Waktu Respon Cepat',
                      desc: 'Mata normal membaca pelat dalam 3 detik. Jangan terlalu lama menatap untuk akurasi terbaik.',
                      isDark: isDark,
                    ),

                    const SizedBox(height: 20),

                    // Timer Setting Option
                    const Text(
                      'Opsi Batas Waktu per Pelat',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _buildTimerOption(0, 'Tanpa Batas', isDark),
                        const SizedBox(width: 8),
                        _buildTimerOption(3, '3 Detik (Medis)', isDark),
                        const SizedBox(width: 8),
                        _buildTimerOption(5, '5 Detik', isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Start Button
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestRunnerScreen(
                          testMode: widget.testMode,
                          timerPerPlate: _timerSeconds,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mulai Tes Sekarang',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.play_arrow_rounded, size: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrepItem({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerOption(int seconds, String label, bool isDark) {
    final isSelected = _timerSeconds == seconds;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _timerSeconds = seconds;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.cardDark : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ),
      ),
    );
  }
}

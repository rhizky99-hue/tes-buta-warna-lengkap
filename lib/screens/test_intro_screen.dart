import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/services/unity_ads_service.dart';
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
    // Pra-muat iklan interstitial sejak awal petunjuk tes
    UnityAdsService().loadInterstitial();
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mode Header Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(20),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isQuick ? Icons.flash_on_rounded : Icons.verified_rounded,
                                  color: AppColors.primary,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isQuick ? 'Tes Cepat (12 Pelat)' : 'Tes Lengkap (24 Pelat)',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                        ),
                        const SizedBox(height: 12),

                        _PrepItemCard(
                          icon: Icons.brightness_high_rounded,
                          title: 'Atur Kecerahan Layar',
                          desc: 'Tingkatkan kecerahan layar ke 75% - 100% agar kontras warna pelat optimal.',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _PrepItemCard(
                          icon: Icons.nightlight_outlined,
                          title: 'Matikan Filter Cahaya Biru',
                          desc: 'Nonaktifkan Night Light / Reading Mode agar warna tidak terdistorsi.',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _PrepItemCard(
                          icon: Icons.straighten_rounded,
                          title: 'Jarak Pandang Ideal (~75 cm)',
                          desc: 'Posisikan layar tegak lurus sejauh rentang lengan Anda dari mata.',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _PrepItemCard(
                          icon: Icons.timer_outlined,
                          title: 'Waktu Respon Ideal (3 Detik)',
                          desc: 'Mata normal mengenali pelat dalam 3 detik. Hindari menatap terlalu lama.',
                          isDark: isDark,
                        ),

                        const SizedBox(height: 24),

                        // Timer Setting Option
                        const Text(
                          'Opsi Batas Waktu per Pelat',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _TimerPillOption(
                                value: 0,
                                selectedValue: _timerSeconds,
                                label: 'Tanpa Batas',
                                isDark: isDark,
                                onSelect: (v) => setState(() => _timerSeconds = v),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _TimerPillOption(
                                value: 3,
                                selectedValue: _timerSeconds,
                                label: '3 Detik (Medis)',
                                isDark: isDark,
                                onSelect: (v) => setState(() => _timerSeconds = v),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _TimerPillOption(
                                value: 5,
                                selectedValue: _timerSeconds,
                                label: '5 Detik',
                                isDark: isDark,
                                onSelect: (v) => setState(() => _timerSeconds = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // Bottom Start Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    height: 50,
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Mulai Pemeriksaan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
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

// Extracted Sub-Widget: Prep Item Card
class _PrepItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isDark;

  const _PrepItemCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.isDark,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
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
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
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
    );
  }
}

// Extracted Sub-Widget: Timer Pill Option
class _TimerPillOption extends StatelessWidget {
  final int value;
  final int selectedValue;
  final String label;
  final bool isDark;
  final ValueChanged<int> onSelect;

  const _TimerPillOption({
    required this.value,
    required this.selectedValue,
    required this.label,
    required this.isDark,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return Material(
      color: isSelected
          ? AppColors.primary.withAlpha(isDark ? 50 : 25)
          : (isDark ? AppColors.cardDark : Colors.white),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onSelect(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }
}

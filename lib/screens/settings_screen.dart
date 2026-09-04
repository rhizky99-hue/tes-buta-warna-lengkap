import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/theme_controller.dart';
import '../data/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = LocalStorageService();

  String _themeMode = 'system';
  bool _hapticEnabled = true;
  int _timerDuration = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final theme = await _storage.getThemeMode();
    final haptic = await _storage.getHapticEnabled();
    final timer = await _storage.getTimerDuration();

    if (mounted) {
      setState(() {
        _themeMode = theme;
        _hapticEnabled = haptic;
        _timerDuration = timer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan & Informasi'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            children: [
              // Group 1: Preferensi Aplikasi
              _buildSectionHeader('Preferensi Aplikasi'),
              const SizedBox(height: 8),

              _SettingsGroupCard(
                isDark: isDark,
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Tema Tampilan', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      _themeMode == 'system'
                          ? 'Mengikuti Sistem'
                          : (_themeMode == 'dark' ? 'Mode Gelap' : 'Mode Terang'),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    trailing: DropdownButton<String>(
                      value: _themeMode,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'system', child: Text('Sistem', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'light', child: Text('Terang', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'dark', child: Text('Gelap', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) async {
                        if (val != null) {
                          setState(() => _themeMode = val);
                          await ThemeController.setTheme(val);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.vibration_rounded, color: AppColors.primary, size: 22),
                    title: const Text('Getaran Sentuhan (Haptic)', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'Umpan balik getar saat menekan tombol dialpad angka',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    trailing: Switch(
                      value: _hapticEnabled,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) async {
                        setState(() => _hapticEnabled = val);
                        await _storage.setHapticEnabled(val);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.timer_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Batas Waktu Bawaan', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      _timerDuration == 0 ? 'Tanpa batas waktu' : '$_timerDuration detik per pelat',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    trailing: DropdownButton<int>(
                      value: _timerDuration,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Tanpa Batas', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 3, child: Text('3 Detik', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 5, child: Text('5 Detik', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (val) async {
                        if (val != null) {
                          setState(() => _timerDuration = val);
                          await _storage.setTimerDuration(val);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.tour_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Tampilkan Ulang Panduan', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'Tampilkan kembali spotlight tutorial di halaman utama',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
                    onTap: () async {
                      await _storage.setTourSeen(false);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Panduan akan ditampilkan kembali saat membuka beranda.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Group 2: Standar Medis & Disclaimer
              _buildSectionHeader('Standar Medis & Disclaimer'),
              const SizedBox(height: 8),

              _SettingsGroupCard(
                isDark: isDark,
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Metode Uji Klinis', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'Ishihara 24 Plates, HRR, Farnsworth, Anomaloskop, Cambridge',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
                    title: const Text('Privasi & Keamanan Data', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '100% Offline, seluruh data pemeriksaan disimpan di memori lokal HP',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
                    title: const Text('Disclaimer Medis', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      AppStrings.medicalDisclaimer,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Footer / Version
              Center(
                child: Column(
                  children: [
                    Text(
                      'Tes Buta Warna Lengkap v1.0.0',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Created By Rhizky Putra',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Oftalmologi Klinis & Skrining Mandiri 100% Offline',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, letterSpacing: -0.2),
    );
  }
}

// Extracted Sub-Widget: Settings Group Card
class _SettingsGroupCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsGroupCard({
    required this.children,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

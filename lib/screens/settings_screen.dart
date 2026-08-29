import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        children: [
          // Section: Preferensi
          _buildSectionHeader('Preferensi Aplikasi'),
          const SizedBox(height: 8),

          _buildCard(
            isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined, color: AppColors.primary),
                title: const Text('Tema Tampilan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  _themeMode == 'system'
                      ? 'Mengikuti Sistem'
                      : (_themeMode == 'dark' ? 'Mode Gelap' : 'Mode Terang'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: _themeMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'system', child: Text('Sistem')),
                    DropdownMenuItem(value: 'light', child: Text('Terang')),
                    DropdownMenuItem(value: 'dark', child: Text('Gelap')),
                  ],
                  onChanged: (val) async {
                    if (val != null) {
                      setState(() => _themeMode = val);
                      await _storage.setThemeMode(val);
                    }
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.vibration_rounded, color: AppColors.primary),
                title: const Text('Getaran Sentuhan (Haptic)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  'Umpan balik getar saat menekan tombol angka',
                  style: TextStyle(
                    fontSize: 12,
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
            ],
          ),

          const SizedBox(height: 20),

          // Section: Batas Waktu
          _buildSectionHeader('Standar Pengujian'),
          const SizedBox(height: 8),

          _buildCard(
            isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                title: const Text('Default Batas Waktu per Pelat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  _timerDuration == 0 ? 'Tanpa Batas Waktu' : '$_timerDuration Detik per Pelat',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                trailing: DropdownButton<int>(
                  value: _timerDuration,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Tanpa Batas')),
                    DropdownMenuItem(value: 3, child: Text('3 Detik')),
                    DropdownMenuItem(value: 5, child: Text('5 Detik')),
                    DropdownMenuItem(value: 10, child: Text('10 Detik')),
                  ],
                  onChanged: (val) async {
                    if (val != null) {
                      setState(() => _timerDuration = val);
                      await _storage.setTimerDuration(val);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section: Data & Privasi
          _buildSectionHeader('Data & Privasi'),
          const SizedBox(height: 8),

          _buildCard(
            isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.security_outlined, color: AppColors.primary),
                title: const Text('Kebijakan Privasi (Offline)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Aplikasi tidak mengumpulkan data pribadi apapun.', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  _showPrivacyDialog(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                title: const Text('Hapus Semua Data Riwayat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Hapus Semua Riwayat?'),
                      content: const Text('Seluruh catatan hasil tes offline akan dibersihkan dari perangkat.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _storage.clearAllHistory();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Riwayat berhasil dibersihkan')),
                      );
                    }
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section: Tentang Aplikasi
          _buildSectionHeader('Tentang Aplikasi'),
          const SizedBox(height: 8),

          _buildCard(
            isDark,
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline_rounded, color: AppColors.primary),
                title: Text('Versi Aplikasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text('v1.0.0 (Play Store Release Build)', style: TextStyle(fontSize: 12)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.medical_information_outlined, color: AppColors.primary),
                title: const Text('Disclaimer Medis', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Klik untuk membaca pernyataan medis', style: TextStyle(fontSize: 12)),
                onTap: () {
                  _showDisclaimerDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
    );
  }

  Widget _buildCard(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(children: children),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kebijakan Privasi'),
        content: const SingleChildScrollView(
          child: Text(
            'Aplikasi Tes Buta Warna berkomitmen penuh menjaga privasi Anda.\n\n'
            '• 100% Offline: Seluruh proses kalkulasi diagnostik dilakukan langsung di perangkat HP Anda.\n'
            '• Tanpa Akun & Login: Anda tidak perlu mendaftar atau memberikan email/nama.\n'
            '• Tanpa Izin Mencurigakan: Aplikasi tidak mengakses kontak, lokasi, atau file pribadi tanpa izin eksplisit.\n'
            '• Bebas Pelacak: Tidak ada pengumpulan analitik pengguna pihak ketiga.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pernyataan Medis'),
        content: const Text(
          AppStrings.medicalDisclaimer,
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mengerti')),
        ],
      ),
    );
  }
}

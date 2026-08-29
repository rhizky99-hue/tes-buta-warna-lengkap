import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/local_storage_service.dart';
import '../data/models/test_result.dart';
import 'test_intro_screen.dart';
import 'history_screen.dart';
import 'simulator_screen.dart';
import 'education_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = LocalStorageService();
  List<TestResult> _recentHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await _storage.getHistory();
    if (mounted) {
      setState(() {
        _recentHistory = history;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.visibility_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Tes Buta Warna'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              _loadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              _buildHeroBanner(isDark),
              const SizedBox(height: 20),

              // Section Title: Mode Tes
              const Text(
                'Pilih Mode Pemeriksaan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // Test Card 1: Tes Cepat
              _buildTestCard(
                context: context,
                mode: 'quick',
                title: 'Tes Cepat (12 Pelat)',
                subtitle: 'Skrining kilat < 2 menit. Sangat cocok untuk pengecekan berkala.',
                badgeText: 'POPULER',
                badgeColor: AppColors.secondary,
                gradientColors: [const Color(0xFF0F766E), const Color(0xFF14B8A6)],
                icon: Icons.flash_on_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 14),

              // Test Card 2: Tes Lengkap
              _buildTestCard(
                context: context,
                mode: 'full',
                title: 'Tes Lengkap (24 Pelat)',
                subtitle: 'Diagnosis akurat & menyeluruh standar medis (Protanopia vs Deuteranopia).',
                badgeText: 'STANDAR MEDIS',
                badgeColor: AppColors.accent,
                gradientColors: [const Color(0xFF1E293B), const Color(0xFF334155)],
                icon: Icons.verified_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // Quick Features Grid
              const Text(
                'Fitur & Eksplorasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.35,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildFeatureTile(
                    title: 'Simulator Warna',
                    subtitle: 'Lihat dunia seperti penderita',
                    icon: Icons.palette_outlined,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SimulatorScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildFeatureTile(
                    title: 'Riwayat Tes',
                    subtitle: '${_recentHistory.length} hasil tersimpan',
                    icon: Icons.history_rounded,
                    color: Colors.blue,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      );
                      _loadData();
                    },
                    isDark: isDark,
                  ),
                  _buildFeatureTile(
                    title: 'Panduan Kedinasan',
                    subtitle: 'Syarat TNI, POLRI, KAI',
                    icon: Icons.menu_book_rounded,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EducationScreen()),
                      );
                    },
                    isDark: isDark,
                  ),
                  _buildFeatureTile(
                    title: 'Info & Tips Layar',
                    subtitle: 'Petunjuk pencahayaan',
                    icon: Icons.lightbulb_outline_rounded,
                    color: Colors.amber.shade800,
                    onTap: () {
                      _showQuickTipsDialog(context);
                    },
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Test Summary if available
              if (_recentHistory.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hasil Tes Terakhir',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HistoryScreen()),
                        );
                        _loadData();
                      },
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildRecentResultCard(_recentHistory.first, isDark),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF042F2E), Color(0xFF0F766E), Color(0xFF0E7490)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.offline_bolt_rounded, color: Colors.yellowAccent, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '100% Offline & Privat',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Uji Penglihatan Warna Anda',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Menggunakan metode pelat pseudoisokromatik Ishihara medis yang diakui secara internasional.',
            style: TextStyle(
              color: Colors.white.withAlpha(210),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard({
    required BuildContext context,
    required String mode,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required List<Color> gradientColors,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TestIntroScreen(testMode: mode),
              ),
            );
            _loadData();
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentResultCard(TestResult result, bool isDark) {
    final isNormal = result.diagnosis == DiagnosisType.normal;
    final statusColor = isNormal ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNormal ? Icons.check_circle_rounded : Icons.info_rounded,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.diagnosisTitle,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Akurasi: ${result.scorePercentage.toStringAsFixed(0)}% • ${result.correctCount}/${result.totalPlates} Benar',
                  style: TextStyle(
                    fontSize: 11,
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

  void _showQuickTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.lightbulb_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('Petunjuk Akurasi Tes'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agar hasil tes akurat:'),
            SizedBox(height: 8),
            Text('1. Atur kecerahan layar HP sekitar 70% - 100%.'),
            SizedBox(height: 4),
            Text('2. Matikan filter cahaya biru (Night Mode / Reading Mode).'),
            SizedBox(height: 4),
            Text('3. Jaga jarak pandang sekitar 75 cm dari layar.'),
            SizedBox(height: 4),
            Text('4. Jawab setiap pelat dalam waktu 3 hingga 5 detik.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }
}

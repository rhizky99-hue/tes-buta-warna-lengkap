import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/local_storage_service.dart';
import '../data/models/test_result.dart';
import 'test_intro_screen.dart';
import 'history_screen.dart';
import 'simulator_screen.dart';
import 'education_screen.dart';
import 'settings_screen.dart';
import 'test_methods_hub_screen.dart';
import 'package:animations/animations.dart';
import '../core/utils/tutorial_coach_service.dart';
import '../core/services/unity_ads_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = LocalStorageService();
  List<TestResult> _recentHistory = [];
  bool _isLoading = true;

  // Walkthrough Target Keys
  final GlobalKey _quickTestKey = GlobalKey();
  final GlobalKey _fullTestKey = GlobalKey();
  final GlobalKey _labKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadData();
    _checkTour();
  }

  Future<void> _checkTour() async {
    final hasSeen = await _storage.hasSeenTour();
    if (!hasSeen && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Wait slightly for layout to settle
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _startTour();
        });
      });
    }
  }

  void _startTour() {
    TutorialCoachService.showHomeTour(
      context: context,
      quickTestKey: _quickTestKey,
      fullTestKey: _fullTestKey,
      labKey: _labKey,
      featuresKey: _featuresKey,
      onFinish: () {
        _storage.setTourSeen(true);
      },
      onSkip: () {
        _storage.setTourSeen(true);
      },
    );
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/app_icon.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tes Buta Warna Lengkap',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Offline • Created By Rhizky Putra',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: 'Panduan Fitur Aplikasi',
            child: IconButton(
              icon: const Icon(Icons.help_outline_rounded, size: 22),
              onPressed: _startTour,
            ),
          ),
          Tooltip(
            message: 'Pengaturan & Informasi Medis',
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 22),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
                _loadData();
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2.5))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Hero Medical Banner
                        _buildHeroBanner(isDark),
                        const SizedBox(height: 24),

                        // 2. Section: Pemeriksaan Utama
                        _buildSectionHeader('Pemeriksaan Utama (Ishihara)'),
                        const SizedBox(height: 12),

                        KeyedSubtree(
                          key: _quickTestKey,
                          child: OpenContainer(
                            closedElevation: 0,
                            openElevation: 0,
                            closedColor: Colors.transparent,
                            openColor: isDark ? AppColors.bgDark : AppColors.bgLight,
                            middleColor: isDark ? AppColors.bgDark : AppColors.bgLight,
                            transitionDuration: const Duration(milliseconds: 500),
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            onClosed: (_) => _loadData(),
                            openBuilder: (context, action) => const TestIntroScreen(testMode: 'quick'),
                            closedBuilder: (context, action) => _TestModeCard(
                              mode: 'quick',
                              title: 'Tes Cepat (12 Pelat)',
                              subtitle: 'Skrining kilat < 2 menit untuk pemeriksaan berkala.',
                              badgeText: 'SKRINING KILAT',
                              badgeColor: AppColors.secondary,
                              icon: Icons.flash_on_rounded,
                              isDark: isDark,
                              onTap: action,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        KeyedSubtree(
                          key: _fullTestKey,
                          child: OpenContainer(
                            closedElevation: 0,
                            openElevation: 0,
                            closedColor: Colors.transparent,
                            openColor: isDark ? AppColors.bgDark : AppColors.bgLight,
                            middleColor: isDark ? AppColors.bgDark : AppColors.bgLight,
                            transitionDuration: const Duration(milliseconds: 500),
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            onClosed: (_) => _loadData(),
                            openBuilder: (context, action) => const TestIntroScreen(testMode: 'full'),
                            closedBuilder: (context, action) => _TestModeCard(
                              mode: 'full',
                              title: 'Tes Lengkap (24 Pelat)',
                              subtitle: 'Diagnosis akurat standar medis (Protanopia vs Deuteranopia).',
                              badgeText: 'STANDAR MEDIS',
                              badgeColor: AppColors.primary,
                              icon: Icons.verified_rounded,
                              isDark: isDark,
                              onTap: action,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 3. Section: Laboratorium 4 Metode Tambahan
                        KeyedSubtree(
                          key: _labKey,
                          child: OpenContainer(
                            closedElevation: 0,
                            openElevation: 0,
                            closedColor: Colors.transparent,
                            openColor: isDark ? AppColors.bgDark : AppColors.bgLight,
                            middleColor: isDark ? AppColors.bgDark : AppColors.bgLight,
                            transitionDuration: const Duration(milliseconds: 500),
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            openBuilder: (context, action) => const TestMethodsHubScreen(),
                            closedBuilder: (context, action) => _MethodsHubBanner(
                              isDark: isDark,
                              onTap: action,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 4. Section: Fitur & Eksplorasi Grid
                        _buildSectionHeader('Fitur & Eksplorasi'),
                        const SizedBox(height: 12),

                        KeyedSubtree(
                          key: _featuresKey,
                          child: _buildFeatureGrid(context, isDark),
                        ),
                        const SizedBox(height: 24),

                        // 5. Recent History Card (if any)
                        if (_recentHistory.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSectionHeader('Hasil Pemeriksaan Terakhir'),
                              TextButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                                  );
                                  _loadData();
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Lihat Semua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _RecentResultCard(
                            result: _recentHistory.first,
                            isDark: isDark,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const HistoryScreen()),
                              );
                              _loadData();
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: UnityAdsService().buildBannerAd(),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildHeroBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.offline_pin_rounded, color: AppColors.primary, size: 14),
                    SizedBox(width: 5),
                    Text(
                      '100% Offline & Privat',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withAlpha(12) : Colors.black.withAlpha(8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Created By Rhizky Putra',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tes Buta Warna Lengkap',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pemeriksaan komprehensif standar medis internasional untuk mendeteksi defisiensi merah-hijau dan biru-kuning secara akurat.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.35,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        OpenContainer(
          closedElevation: 0,
          openElevation: 0,
          closedColor: Colors.transparent,
          openColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          middleColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: ContainerTransitionType.fadeThrough,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          openBuilder: (context, action) => const SimulatorScreen(),
          closedBuilder: (context, action) => _FeatureGridTile(
            title: 'Simulator Warna',
            subtitle: 'Simulasi pandangan mata',
            icon: Icons.palette_outlined,
            iconColor: Colors.deepPurple,
            isDark: isDark,
            onTap: action,
          ),
        ),
        OpenContainer(
          closedElevation: 0,
          openElevation: 0,
          closedColor: Colors.transparent,
          openColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          middleColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: ContainerTransitionType.fadeThrough,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onClosed: (_) => _loadData(),
          openBuilder: (context, action) => const HistoryScreen(),
          closedBuilder: (context, action) => _FeatureGridTile(
            title: 'Riwayat Tes',
            subtitle: '${_recentHistory.length} hasil tersimpan',
            icon: Icons.history_rounded,
            iconColor: AppColors.secondary,
            isDark: isDark,
            onTap: action,
          ),
        ),
        OpenContainer(
          closedElevation: 0,
          openElevation: 0,
          closedColor: Colors.transparent,
          openColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          middleColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: ContainerTransitionType.fadeThrough,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          openBuilder: (context, action) => const EducationScreen(),
          closedBuilder: (context, action) => _FeatureGridTile(
            title: 'Info Kedinasan',
            subtitle: 'Syarat TNI, POLRI, KAI',
            icon: Icons.menu_book_rounded,
            iconColor: AppColors.primary,
            isDark: isDark,
            onTap: action,
          ),
        ),
        _FeatureGridTile(
          title: 'Tips Akurasi',
          subtitle: 'Panduan layar & cahaya',
          icon: Icons.lightbulb_outline_rounded,
          iconColor: Colors.amber.shade800,
          isDark: isDark,
          onTap: () => _showTipsDialog(context),
        ),
      ],
    );
  }

  void _showTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lightbulb_rounded, color: Colors.amber, size: 22),
            SizedBox(width: 8),
            Text('Petunjuk Akurasi Tes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agar hasil pemeriksaan optimal:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            SizedBox(height: 10),
            Text('1. Atur kecerahan layar sekitar 75% - 100%.', style: TextStyle(fontSize: 12, height: 1.4)),
            SizedBox(height: 6),
            Text('2. Nonaktifkan filter cahaya biru (Night Shift / Reading Mode).', style: TextStyle(fontSize: 12, height: 1.4)),
            SizedBox(height: 6),
            Text('3. Jaga jarak pandang sekitar 75 cm tegak lurus dari layar.', style: TextStyle(fontSize: 12, height: 1.4)),
            SizedBox(height: 6),
            Text('4. Jawab dalam durasi 3 - 5 detik per pelat.', style: TextStyle(fontSize: 12, height: 1.4)),
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

// Extracted Sub-Widget: Test Mode Card
class _TestModeCard extends StatelessWidget {
  final String mode;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _TestModeCard({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            color: badgeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: badgeColor.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: badgeColor, size: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Sub-Widget: Methods Hub Banner
class _MethodsHubBanner extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _MethodsHubBanner({
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.science_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LABORATORIUM OFTALMOLOGI',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ragam Metode Tes Klinis',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'HRR (Bentuk), Farnsworth 100-Hue, Nagel Anomaloskop, & Tes Cambridge.',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Sub-Widget: Feature Grid Tile
class _FeatureGridTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isDark;
  final VoidCallback onTap;

  const _FeatureGridTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isDark,
    required this.onTap,
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
                    color: iconColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
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
}

// Extracted Sub-Widget: Recent Result Card
class _RecentResultCard extends StatelessWidget {
  final TestResult result;
  final bool isDark;
  final VoidCallback onTap;

  const _RecentResultCard({
    required this.result,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNormal = result.diagnosis == DiagnosisType.normal;
    final statusColor = isNormal ? AppColors.success : AppColors.error;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isNormal ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                    color: statusColor,
                    size: 22,
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
                const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'test_intro_screen.dart';
import 'hrr_test_screen.dart';
import 'farnsworth_test_screen.dart';
import 'anomaloscope_screen.dart';
import 'cambridge_test_screen.dart';

class TestMethodsHubScreen extends StatelessWidget {
  const TestMethodsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ragam Metode Tes Buta Warna'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Clinical Context
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.science_rounded, color: AppColors.primary, size: 14),
                            SizedBox(width: 5),
                            Text(
                              'Standar Oftalmologi Klinis',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Pusat Pemeriksaan Penglihatan Warna',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pilih salah satu dari 5 metodologi pengujian klinis terkemuka di dunia untuk mengevaluasi kepekaan spektrum warna Anda.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Metode & Simulasi Interaktif',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                ),
                const SizedBox(height: 12),

                // 1. Tes Ishihara
                _MethodCard(
                  title: 'Tes Ishihara (Pelat Angka)',
                  subtitle: 'Metode skrining merah-hijau paling populer di dunia dengan pelat titik pseudoisokromatik.',
                  badge: 'SKRINING UTAMA',
                  badgeColor: AppColors.secondary,
                  icon: Icons.filter_vintage_rounded,
                  features: const ['12 & 24 Pelat', 'Deteksi Merah-Hijau', 'Standar Kedinasan'],
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TestIntroScreen(testMode: 'full')),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 2. Tes HRR
                _MethodCard(
                  title: 'Tes HRR (Hardy-Rand-Rittler)',
                  subtitle: 'Menggunakan simbol bentuk (lingkaran, segitiga, silang) alih-alih angka. Efektif mendeteksi gangguan merah-hijau hingga biru-kuning serta ramah anak.',
                  badge: 'RAMAH ANAK & TRITAN',
                  badgeColor: Colors.teal,
                  icon: Icons.category_rounded,
                  features: const ['Simbol Geometris', 'Deteksi Biru-Kuning (Tritan)', 'Achromatic Noise'],
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HRRTestScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 3. Tes Farnsworth-Munsell
                _MethodCard(
                  title: 'Tes Farnsworth-Munsell Hue',
                  subtitle: 'Menyusun kepingan warna dengan gradasi halus dalam urutan spektrum yang tepat untuk mengukur ketajaman membedakan nuansa warna tipis.',
                  badge: 'GRADASI WARNA HALUS',
                  badgeColor: Colors.deepPurple,
                  icon: Icons.palette_rounded,
                  features: const ['Interaktif Tap-to-Swap', 'Skor Error TES', 'Analisis Sumbu Rona'],
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FarnsworthTestScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 4. Anomaloskop
                _MethodCard(
                  title: 'Anomaloscope (Nagel Anomaloskop)',
                  subtitle: 'Simulasi instrumen optik standar emas medis untuk mencocokkan dua sumber cahaya (campuran Merah-Hijau vs Kuning Murni) via tombol/slider.',
                  badge: 'STANDAR EMAS MEDIS',
                  badgeColor: Colors.amber.shade900,
                  icon: Icons.biotech_rounded,
                  features: const ['Rayleigh Match', 'Anomalie Quotient (AQ)', 'Presisi Diagnostik'],
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnomaloscopeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 5. Tes Cambridge
                _MethodCard(
                  title: 'Tes Cambridge (Cambridge Colour Test)',
                  subtitle: 'Pengujian psikofisik komputerisasi untuk mendeteksi arah celah cincin Landolt C pada matriks chromatic noise berlatar netral.',
                  badge: 'KOMPUTERISASI MODERN',
                  badgeColor: Colors.blue.shade700,
                  icon: Icons.laptop_chromebook_rounded,
                  features: const ['Cincin Landolt C', 'Trivector Protan/Deutan/Tritan', 'Ambang Batas Kromatik'],
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CambridgeTestScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Sub-Widget: Method Card
class _MethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final IconData icon;
  final List<String> features;
  final bool isDark;
  final VoidCallback onTap;

  const _MethodCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.features,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: badgeColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                color: badgeColor,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: features.map((f) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black.withAlpha(8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '• $f',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Buka & Uji Sekarang',
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, color: badgeColor, size: 15),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

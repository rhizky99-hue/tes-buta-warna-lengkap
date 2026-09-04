import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/services/unity_ads_service.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi & Info Kedinasan'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Intro
                Container(
                  padding: const EdgeInsets.all(16),
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
                        child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Panduan komprehensif mengenai ragam metode tes klinis, genetika buta warna, serta persyaratan seleksi kerja kedinasan di Indonesia.',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.45,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section 1: 5 Metode Tes
                const Text(
                  '5 Ragam Metode Pengujian Klinis',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                ),
                const SizedBox(height: 10),

                _MethodInfoTile(
                  title: '1. Tes Ishihara (Pseudoisochromatic Plates)',
                  badge: 'SKRINING UTAMA MERAH-HIJAU',
                  badgeColor: AppColors.primary,
                  desc: 'Buku pelat lingkaran titik-titik warna acak. Penderita buta warna membaca angka berbeda atau tidak melihat angka sama sekali.',
                  points: const [
                    'Standar seleksi kedinasan (TNI, POLRI, KAI, Pelayaran).',
                    'Keterbatasan: Hanya mendeteksi merah-hijau (tidak bisa deteksi biru-kuning / Tritan).',
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _MethodInfoTile(
                  title: '2. Tes HRR (Hardy-Rand-Rittler)',
                  badge: 'SIMBOL BENTUK • RAMAH ANAK & TRITAN',
                  badgeColor: Colors.teal,
                  desc: 'Menggunakan simbol bentuk (Lingkaran, Segitiga, Silang) pada matriks titik netral abu-abu.',
                  points: const [
                    'Mendeteksi gangguan Merah-Hijau DAN Biru-Kuning (Tritan).',
                    'Sangat cocok untuk anak-anak / balita yang belum mengenal angka.',
                    'Referensi: Wajak Husada & National Eye Center.',
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _MethodInfoTile(
                  title: '3. Tes Farnsworth-Munsell 100-Hue (D-15)',
                  badge: 'PENGURUTAN GRADASI RONA',
                  badgeColor: Colors.purple,
                  desc: 'Pasien menyusun keping gradasi warna halus dalam urutan spektrum pelangi yang benar.',
                  points: const [
                    'Mengukur ketajaman membedakan nuansa warna yang tipis (Total Error Score).',
                    'Digunakan oleh desainer, industri cat/tekstil, dan oftalmologi forensik.',
                    'Referensi: Ciputra Hospital & American Academy of Ophthalmology.',
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _MethodInfoTile(
                  title: '4. Nagel Anomaloskop (Rayleigh Match)',
                  badge: 'STANDAR EMAS MEDIS',
                  badgeColor: Colors.amber.shade900,
                  desc: 'Instrumen optik split-circle: mencocokkan campuran Merah-Hijau dengan Kuning Spektral murni via tombol putar.',
                  points: const [
                    'Paling akurat membedakan dikromat mutlak dan trikromat anomali via Anomalie Quotient (AQ).',
                    'Referensi: RSUD Buleleng & HelloSehat.',
                  ],
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _MethodInfoTile(
                  title: '5. Tes Cambridge (Cambridge Colour Test)',
                  badge: 'PSIKOFISIK KOMPUTERISASI',
                  badgeColor: Colors.blue.shade700,
                  desc: 'Menebak arah bukaan celah cincin Landolt C (Atas, Bawah, Kiri, Kanan) di atas chromatic noise.',
                  points: const [
                    '100% otomatis, bebas bias penguji, mengukur ambang batas kontras kromatik.',
                    'Referensi: Cambridge University Physiological Laboratory.',
                  ],
                  isDark: isDark,
                ),

                const SizedBox(height: 24),

                // Section 2: Syarat Kedinasan
                const Text(
                  'Persyaratan Buta Warna per Instansi & Profesi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                ),
                const SizedBox(height: 10),

                _CareerRequirementCard(
                  icon: Icons.shield_rounded,
                  title: 'TNI (AD, AL, AU) & POLRI',
                  status: 'TIDAK BOLEH BUTA WARNA (TOTAL & PARSIAL)',
                  statusColor: AppColors.error,
                  desc: 'Wajib lulus seluruh pelat Ishihara tanpa kesalahan demi keselamatan navigasi taktis dan pengenalan kode sinyal militer.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _CareerRequirementCard(
                  icon: Icons.train_rounded,
                  title: 'PT Kereta Api Indonesia (Persero)',
                  status: 'BEBAS BUTA WARNA KETAT',
                  statusColor: AppColors.error,
                  desc: 'Wajib bebas buta warna parsial/total bagi Masinis dan Petugas PPKA demi mengenali semboyan lampu jalur rel.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _CareerRequirementCard(
                  icon: Icons.local_hospital_rounded,
                  title: 'Kedokteran & Tenaga Medis',
                  status: 'BEBAS BUTA WARNA',
                  statusColor: AppColors.error,
                  desc: 'Dokter wajib membedakan warna jaringan biologis, darah teroksigenasi, ruam kulit, dan hasil tes reagen lab.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _CareerRequirementCard(
                  icon: Icons.flight_rounded,
                  title: 'Penerbangan (Pilot) & Pelayaran',
                  status: 'BEBAS BUTA WARNA',
                  statusColor: AppColors.error,
                  desc: 'Regulasi ICAO mewajibkan pilot dapat membaca lampu landasan PAPI, instrumen kokpit, dan suar navigasi laut.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _CareerRequirementCard(
                  icon: Icons.computer_rounded,
                  title: 'Teknologi Informasi & Software',
                  status: 'DIPERBOLEHKAN (DENGAN ALAT BANTU)',
                  statusColor: AppColors.success,
                  desc: 'Sebagian besar profesi software engineering tidak mensyaratkan tes buta warna karena didukung fitur aksesibilitas OS modern.',
                  isDark: isDark,
                ),

                const SizedBox(height: 24),

                // Section 3: Mitos vs Fakta
                const Text(
                  'Mitos vs Fakta Medis',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2),
                ),
                const SizedBox(height: 10),

                _FaqCard(
                  q: 'Apakah buta warna bawaan bisa disembuhkan dengan obat atau terapi?',
                  a: 'Fakta Medis: Buta warna bawaan disebabkan oleh mutasi genetik pada kromosom X fotopigmen sel kerucut retina. Hingga kini, belum ada obat atau suplemen yang dapat mengubah struktur genetik tersebut.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _FaqCard(
                  q: 'Apakah kacamata filter warna (seperti EnChroma) menyembuhkan buta warna?',
                  a: 'Fakta Medis: Kacamata tersebut bekerja sebagai filter optik takik (notch filter) untuk meningkatkan kontras visual, bukan menyembuhkan sel kerucut. Kacamata ini tidak diperbolehkan dalam tes seleksi resmi kedinasan.',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _FaqCard(
                  q: 'Mengapa pria jauh lebih banyak mengalami buta warna dibandingkan wanita?',
                  a: 'Fakta Medis: Gen fotopigmen merah dan hijau terletak pada kromosom X. Karena pria hanya memiliki 1 kromosom X (XY), jika kromosom tersebut membawa gen defisiensi, pria langsung mengalaminya (~8% populasi pria). Wanita (XX) memiliki kromosom X cadangan sehingga lebih sering hanya menjadi pembawa sifat (carrier).',
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
              ],
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
}

// Extracted Sub-Widget: Method Info Tile
class _MethodInfoTile extends StatelessWidget {
  final String title;
  final String badge;
  final Color badgeColor;
  final String desc;
  final List<String> points;
  final bool isDark;

  const _MethodInfoTile({
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.desc,
    required this.points,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(20),
              borderRadius: BorderRadius.circular(5),
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
          const SizedBox(height: 8),
          Text(
            desc,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 6),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Expanded(
                      child: Text(
                        p,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// Extracted Sub-Widget: Career Requirement Card
class _CareerRequirementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final Color statusColor;
  final String desc;
  final bool isDark;

  const _CareerRequirementCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.statusColor,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
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
    );
  }
}

// Extracted Sub-Widget: FAQ Card
class _FaqCard extends StatelessWidget {
  final String q;
  final String a;
  final bool isDark;

  const _FaqCard({
    required this.q,
    required this.a,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            q,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            a,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

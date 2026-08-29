import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edukasi & Info Kedinasan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Intro
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF166534) : const Color(0xFFBBF7D0),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Panduan komprehensif mengenai mekanisme buta warna, genetika, serta persyaratan medis seleksi kerja & kedinasan di Indonesia.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Persyaratan Buta Warna per Instansi & Profesi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            _buildRequirementCard(
              icon: Icons.shield_rounded,
              title: 'TNI (AD, AL, AU) & POLRI',
              status: 'TIDAK BOLEH BUTA WARNA (TOTAL & PARSIAL)',
              statusColor: AppColors.error,
              desc: 'Calon prajurit dan taruna Akmil/Akpol/Bintara wajib lulus seluruh pelat Ishihara tanpa toleransi kesalahan karena menyangkut keselamatan operasi taktis, navigasi peta, dan pengenalan kode sinyal militer.',
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildRequirementCard(
              icon: Icons.train_rounded,
              title: 'PT Kereta Api Indonesia (Persero)',
              status: 'BEBAS BUTA WARNA KETAT',
              statusColor: AppColors.error,
              desc: 'Posisi Masinis, Asisten Masinis, Pengatur Perjalanan Kereta Api (PPKA), dan Teknisi Sinyal wajib bebas buta warna parsial/total demi mengenali semboyan lampu merah/hijau/kuning di jalur rel.',
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildRequirementCard(
              icon: Icons.local_hospital_rounded,
              title: 'Fakultas Kedokteran & Keperawatan',
              status: 'BEBAS BUTA WARNA',
              statusColor: AppColors.error,
              desc: 'Dokter dan tenaga medis perlu membedakan warna jaringan tubuh, darah teroksigenasi, pembuluh darah, ruam kulit, dan hasil tes reagen laboratorium.',
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildRequirementCard(
              icon: Icons.flight_rounded,
              title: 'Penerbangan & Pelayaran (Pilot / Nakhoda)',
              status: 'BEBAS BUTA WARNA TOTAL & PARSIAL',
              statusColor: AppColors.error,
              desc: 'Regulasi ICAO mewajibkan pilot dapat membaca lampu landasan PAPI, instrumen kokpit, dan sinyal suar laut navigasi.',
              isDark: isDark,
            ),
            const SizedBox(height: 10),

            _buildRequirementCard(
              icon: Icons.computer_rounded,
              title: 'Teknologi Informasi / Software Engineering',
              status: 'DIPERBOLEHKAN (DENGAN ALAT BANTU)',
              statusColor: AppColors.success,
              desc: 'Sebagian besar perusahaan teknologi tidak mensyaratkan tes buta warna untuk software engineer atau analis data, didukung oleh tersedianya color filters di sistem operasi modern.',
              isDark: isDark,
            ),

            const SizedBox(height: 24),

            const Text(
              'Mitos vs Fakta Medis',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            _buildFaqItem(
              q: 'Apakah buta warna bawaan bisa disembuhkan dengan obat atau vitamin?',
              a: 'Fakta Medis: Buta warna bawaan (kongenital) disebabkan oleh mutasi genetik pada kromosom X yang mengatur fotopigmen sel kerucut retina. Hingga saat ini, belum ada obat, terapi, atau vitamin yang dapat mengubah struktur genetik sel kerucut tersebut.',
              isDark: isDark,
            ),
            const SizedBox(height: 8),

            _buildFaqItem(
              q: 'Apakah kacamata "EnChroma" / filter warna menyembuhkan buta warna?',
              a: 'Fakta Medis: Kacamata tersebut TIDAK menyembuhkan, melainkan bekerja sebagai filter optik notch yang memotong panjang gelombang cahaya yang tumpang tindih untuk meningkatkan kontras visual. Kacamata ini biasanya tidak diperbolehkan dalam tes resmi kedinasan.',
              isDark: isDark,
            ),
            const SizedBox(height: 8),

            _buildFaqItem(
              q: 'Mengapa pria jauh lebih banyak mengalami buta warna dibandingkan wanita?',
              a: 'Gen fotopigmen merah dan hijau terletak pada kromosom X. Karena pria hanya memiliki 1 kromosom X (XY), jika kromosom tersebut membawa gen resesif buta warna, pria akan langsung mengalaminya (~8% populasi pria). Wanita (XX) memiliki kromosom X cadangan sehingga sebagian besar hanya menjadi pembawa sifat (carrier).',
              isDark: isDark,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementCard({
    required IconData icon,
    required String title,
    required String status,
    required Color statusColor,
    required String desc,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required String q,
    required String a,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              fontSize: 12,
              height: 1.4,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

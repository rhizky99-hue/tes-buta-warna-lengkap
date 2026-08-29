import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/pdf_generator.dart';
import '../data/models/test_result.dart';
import 'test_intro_screen.dart';

class TestResultScreen extends StatelessWidget {
  final TestResult result;

  const TestResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNormal = result.diagnosis == DiagnosisType.normal;
    final statusColor = isNormal ? AppColors.success : (result.scorePercentage > 60 ? AppColors.warning : AppColors.error);
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Diagnosis Medis'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Ekspor PDF',
            icon: const Icon(Icons.picture_as_pdf_rounded),
            onPressed: () {
              PdfReportGenerator.printOrShareReport(result);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score & Diagnosis Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withAlpha(80), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withAlpha(25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Gauge / Status Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isNormal ? Icons.verified_rounded : Icons.info_outline_rounded,
                      color: statusColor,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Diagnosis Title
                  Text(
                    result.diagnosisTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(result.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Score Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChip(
                        'Akurasi: ${result.scorePercentage.toStringAsFixed(0)}%',
                        statusColor,
                      ),
                      const SizedBox(width: 8),
                      _buildChip(
                        '${result.correctCount}/${result.totalPlates} Benar',
                        AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Text(
                    result.diagnosisDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recommendation & Career Advice Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF13201D) : const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF166534) : const Color(0xFFBBF7D0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.medical_services_outlined, size: 20, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'Rekomendasi & Info Kedinasan',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.recommendation,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons (PDF Export, Test Again, Home)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      PdfReportGenerator.printOrShareReport(result);
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    label: const Text('Ekspor PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TestIntroScreen(testMode: result.testMode),
                        ),
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Tes Ulang'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Plate Details Breakdown
            const Text(
              'Rincian Jawaban Setiap Pelat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: result.plateAnswers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final answer = result.plateAnswers[index];
                return _buildPlateAnswerTile(answer, isDark);
              },
            ),

            const SizedBox(height: 20),

            // Home Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('Kembali ke Beranda'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPlateAnswerTile(UserPlateAnswer a, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: a.isCorrect
              ? (isDark ? AppColors.borderDark : AppColors.borderLight)
              : AppColors.error.withAlpha(60),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: a.isCorrect ? AppColors.success.withAlpha(25) : AppColors.error.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              a.isCorrect ? Icons.check_rounded : Icons.close_rounded,
              color: a.isCorrect ? AppColors.success : AppColors.error,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pelat #${a.plateNumber} (${a.plateType.name.toUpperCase()})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Jawaban Anda: ${a.userAnswer.isEmpty ? 'KOSONG' : (a.userAnswer == 'BLANK' ? 'Tidak Terlihat' : a.userAnswer)} • Normal: ${a.normalAnswer == 'BLANK' ? 'Tidak Terlihat' : a.normalAnswer}',
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
}

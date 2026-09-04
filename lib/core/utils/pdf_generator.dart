import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/test_result.dart';

class PdfReportGenerator {
  static Future<Uint8List> generateTestReport(TestResult result, {String userName = 'Pengguna'}) async {
    final pdf = pw.Document();
    String formattedDate;
    try {
      formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(result.timestamp);
    } catch (_) {
      formattedDate = '${result.timestamp.day}/${result.timestamp.month}/${result.timestamp.year} ${result.timestamp.hour.toString().padLeft(2, '0')}:${result.timestamp.minute.toString().padLeft(2, '0')}';
    }

    final isNormal = result.diagnosis == DiagnosisType.normal;
    final primaryColor = PdfColor.fromHex('#0F766E');
    final statusColor = isNormal ? PdfColor.fromHex('#10B981') : PdfColor.fromHex('#EF4444');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header Certificate Banner
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'LAPORAN HASIL TES BUTA WARNA',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Tes Buta Warna Lengkap • Created By Rhizky Putra',
                        style: const pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                    ),
                    child: pw.Text(
                      result.testMode == 'quick' ? 'TES CEPAT (12)' : 'TES LENGKAP (24)',
                      style: pw.TextStyle(
                        color: primaryColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // Metadata Row
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF8FAFC),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.fromBorderSide(pw.BorderSide(color: PdfColor.fromInt(0xFFE2E8F0))),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Nama Peserta: $userName', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      pw.SizedBox(height: 3),
                      pw.Text('Waktu Pemeriksaan: $formattedDate WIB', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Skor Akurasi: ${result.scorePercentage.toStringAsFixed(1)}%', style: const pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      pw.SizedBox(height: 3),
                      pw.Text('Benar: ${result.correctCount} dari ${result.totalPlates} Pelat', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // Diagnosis Box
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: isNormal ? const PdfColor.fromInt(0xFFECFDF5) : const PdfColor.fromInt(0xFFFEF2F2),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: statusColor, width: 1.5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    children: [
                      pw.Container(
                        width: 10,
                        height: 10,
                        decoration: pw.BoxDecoration(
                          color: statusColor,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Text(
                        'DIAGNOSIS SKRINING:',
                        style: pw.TextStyle(
                          color: statusColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    result.diagnosisTitle,
                    style: const pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    result.diagnosisDescription,
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800, lineSpacing: 2),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 14),

            // Recommendation Box
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF0FDF4),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.fromBorderSide(pw.BorderSide(color: PdfColor.fromInt(0xFFBBF7D0))),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Rekomendasi & Catatan Klinis / Kedinasan:',
                    style: const pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF166534)),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    result.recommendation,
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800, lineSpacing: 2),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // Plate Details Table
            pw.Text(
              'Rincian Jawaban Setiap Pelat Ishihara:',
              style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),

            pw.TableHelper.fromTextArray(
              headers: ['Pelat #', 'Tipe Pelat', 'Jawaban Anda', 'Kunci Normal', 'Hasil'],
              data: result.plateAnswers.map((a) {
                return [
                  'Pelat ${a.plateNumber}',
                  a.plateType.name.toUpperCase(),
                  a.userAnswer.isEmpty ? 'KOSONG' : (a.userAnswer == 'BLANK' ? 'Tidak Terlihat' : a.userAnswer),
                  a.normalAnswer == 'BLANK' ? 'Tidak Terlihat' : a.normalAnswer,
                  a.isCorrect ? 'BENAR' : 'SALAH',
                ];
              }).toList(),
              headerStyle: const pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 9),
              headerDecoration: pw.BoxDecoration(color: primaryColor),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5))),
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
            ),

            pw.SizedBox(height: 16),

            // Disclaimer Footer
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
              ),
              child: pw.Text(
                'Disclaimer Medis: Dokumen ini diterbitkan oleh Aplikasi Tes Buta Warna Lengkap (Created By Rhizky Putra) untuk keperluan skrining awal mandiri. '
                'Hasil tidak bersifat mengikat secara hukum atau menggantikan surat keterangan resmi dari Dokter Spesialis Mata (Sp.M).',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printOrShareReport(TestResult result, {String userName = 'Pengguna'}) async {
    final pdfBytes = await generateTestReport(result, userName: userName);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Laporan_Tes_Buta_Warna_${result.timestamp.millisecondsSinceEpoch}.pdf',
    );
  }
}

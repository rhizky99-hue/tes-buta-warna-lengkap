import 'models/ishihara_plate.dart';
import 'models/test_result.dart';

class IshiharaDataset {
  static const List<IshiharaPlate> allPlates = [
    // 1. Pelat Pembuka (Introductory)
    IshiharaPlate(
      id: 1,
      plateNumber: 1,
      normalAnswer: '12',
      deficiencyAnswer: '12',
      plateType: PlateType.introductory,
      explanation: 'Pelat demonstrasi. Dirancang agar dapat dibaca oleh semua orang dengan penglihatan normal maupun buta warna.',
      normalDescription: 'Melihat angka 12 dengan jelas.',
      deficiencyDescription: 'Melihat angka 12 dengan jelas.',
      visualSeed: 101,
    ),
    // 2. Transformation Plate
    IshiharaPlate(
      id: 2,
      plateNumber: 2,
      normalAnswer: '8',
      deficiencyAnswer: '3',
      plateType: PlateType.transformation,
      explanation: 'Pelat transformasi merah-hijau.',
      normalDescription: 'Mata normal melihat angka 8.',
      deficiencyDescription: 'Defisiensi merah-hijau cenderung membaca angka 3.',
      visualSeed: 102,
    ),
    // 3. Transformation Plate
    IshiharaPlate(
      id: 3,
      plateNumber: 3,
      normalAnswer: '5',
      deficiencyAnswer: '2',
      plateType: PlateType.transformation,
      explanation: 'Pelat transformasi merah-hijau.',
      normalDescription: 'Mata normal melihat angka 5.',
      deficiencyDescription: 'Defisiensi merah-hijau cenderung membaca angka 2.',
      visualSeed: 103,
    ),
    // 4. Transformation Plate
    IshiharaPlate(
      id: 4,
      plateNumber: 4,
      normalAnswer: '29',
      deficiencyAnswer: '70',
      plateType: PlateType.transformation,
      explanation: 'Pelat transformasi merah-hijau.',
      normalDescription: 'Mata normal melihat angka 29.',
      deficiencyDescription: 'Defisiensi merah-hijau membaca angka 70.',
      visualSeed: 104,
    ),
    // 5. Transformation Plate
    IshiharaPlate(
      id: 5,
      plateNumber: 5,
      normalAnswer: '74',
      deficiencyAnswer: '21',
      plateType: PlateType.transformation,
      explanation: 'Pelat transformasi merah-hijau.',
      normalDescription: 'Mata normal melihat angka 74.',
      deficiencyDescription: 'Defisiensi merah-hijau membaca angka 21.',
      visualSeed: 105,
    ),
    // 6. Vanishing Plate
    IshiharaPlate(
      id: 6,
      plateNumber: 6,
      normalAnswer: '7',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 7.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 106,
    ),
    // 7. Vanishing Plate
    IshiharaPlate(
      id: 7,
      plateNumber: 7,
      normalAnswer: '45',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 45.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 107,
    ),
    // 8. Vanishing Plate
    IshiharaPlate(
      id: 8,
      plateNumber: 8,
      normalAnswer: '2',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 2.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 108,
    ),
    // 9. Vanishing Plate
    IshiharaPlate(
      id: 9,
      plateNumber: 9,
      normalAnswer: '16',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 16.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 109,
    ),
    // 10. Hidden Digit Plate
    IshiharaPlate(
      id: 10,
      plateNumber: 10,
      normalAnswer: 'BLANK',
      deficiencyAnswer: '5',
      plateType: PlateType.hiddenDigit,
      explanation: 'Pelat tersembunyi (Hidden Digit).',
      normalDescription: 'Mata normal tidak melihat angka apapun (Blank).',
      deficiencyDescription: 'Penderita buta warna merah-hijau dapat melihat angka 5.',
      visualSeed: 110,
    ),
    // 11. Hidden Digit Plate
    IshiharaPlate(
      id: 11,
      plateNumber: 11,
      normalAnswer: 'BLANK',
      deficiencyAnswer: '45',
      plateType: PlateType.hiddenDigit,
      explanation: 'Pelat tersembunyi (Hidden Digit).',
      normalDescription: 'Mata normal tidak melihat angka apapun (Blank).',
      deficiencyDescription: 'Penderita buta warna merah-hijau dapat melihat angka 45.',
      visualSeed: 111,
    ),
    // 12. Diagnostic Plate (Protan vs Deutan)
    IshiharaPlate(
      id: 12,
      plateNumber: 12,
      normalAnswer: '26',
      protanAnswer: '6',
      deutanAnswer: '2',
      deficiencyAnswer: '2',
      plateType: PlateType.diagnostic,
      explanation: 'Pelat diagnostik diferensial Protanopia vs Deuteranopia.',
      normalDescription: 'Mata normal melihat angka 26.',
      deficiencyDescription: 'Protanopia melihat angka 6. Deuteranopia melihat angka 2.',
      visualSeed: 112,
    ),
    // 13. Diagnostic Plate (Protan vs Deutan)
    IshiharaPlate(
      id: 13,
      plateNumber: 13,
      normalAnswer: '42',
      protanAnswer: '2',
      deutanAnswer: '4',
      deficiencyAnswer: '4',
      plateType: PlateType.diagnostic,
      explanation: 'Pelat diagnostik diferensial Protanopia vs Deuteranopia.',
      normalDescription: 'Mata normal melihat angka 42.',
      deficiencyDescription: 'Protanopia melihat angka 2. Deuteranopia melihat angka 4.',
      visualSeed: 113,
    ),
    // 14. Diagnostic Plate
    IshiharaPlate(
      id: 14,
      plateNumber: 14,
      normalAnswer: '35',
      protanAnswer: '5',
      deutanAnswer: '3',
      deficiencyAnswer: '3',
      plateType: PlateType.diagnostic,
      explanation: 'Pelat diagnostik diferensial Protanopia vs Deuteranopia.',
      normalDescription: 'Mata normal melihat angka 35.',
      deficiencyDescription: 'Protanopia melihat angka 5. Deuteranopia melihat angka 3.',
      visualSeed: 114,
    ),
    // 15. Diagnostic Plate
    IshiharaPlate(
      id: 15,
      plateNumber: 15,
      normalAnswer: '96',
      protanAnswer: '6',
      deutanAnswer: '9',
      deficiencyAnswer: '9',
      plateType: PlateType.diagnostic,
      explanation: 'Pelat diagnostik diferensial Protanopia vs Deuteranopia.',
      normalDescription: 'Mata normal melihat angka 96.',
      deficiencyDescription: 'Protanopia melihat angka 6. Deuteranopia melihat angka 9.',
      visualSeed: 115,
    ),
    // 16. Vanishing Plate
    IshiharaPlate(
      id: 16,
      plateNumber: 16,
      normalAnswer: '6',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 6.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 116,
    ),
    // 17. Vanishing Plate
    IshiharaPlate(
      id: 17,
      plateNumber: 17,
      normalAnswer: '73',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 73.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 117,
    ),
    // 18. Transformation Plate
    IshiharaPlate(
      id: 18,
      plateNumber: 18,
      normalAnswer: '3',
      deficiencyAnswer: '5',
      plateType: PlateType.transformation,
      explanation: 'Pelat transformasi merah-hijau.',
      normalDescription: 'Mata normal melihat angka 3.',
      deficiencyDescription: 'Defisiensi merah-hijau melihat angka 5.',
      visualSeed: 118,
    ),
    // 19. Transformation Plate
    IshiharaPlate(
      id: 19,
      plateNumber: 19,
      normalAnswer: '15',
      deficiencyAnswer: '17',
      plateType: PlateType.transformation,
      explanation: 'Pelat transformasi merah-hijau.',
      normalDescription: 'Mata normal melihat angka 15.',
      deficiencyDescription: 'Defisiensi merah-hijau membaca angka 17.',
      visualSeed: 119,
    ),
    // 20. Vanishing Plate
    IshiharaPlate(
      id: 20,
      plateNumber: 20,
      normalAnswer: '42',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 42.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 120,
    ),
    // 21. Vanishing Plate
    IshiharaPlate(
      id: 21,
      plateNumber: 21,
      normalAnswer: '97',
      deficiencyAnswer: 'BLANK',
      plateType: PlateType.vanishing,
      explanation: 'Pelat vanishing merah-hijau.',
      normalDescription: 'Mata normal melihat angka 97.',
      deficiencyDescription: 'Penderita buta warna tidak melihat angka apapun.',
      visualSeed: 121,
    ),
    // 22. Hidden Digit Plate
    IshiharaPlate(
      id: 22,
      plateNumber: 22,
      normalAnswer: 'BLANK',
      deficiencyAnswer: '2',
      plateType: PlateType.hiddenDigit,
      explanation: 'Pelat tersembunyi (Hidden Digit).',
      normalDescription: 'Mata normal tidak melihat angka apapun.',
      deficiencyDescription: 'Penderita buta warna merah-hijau dapat melihat angka 2.',
      visualSeed: 122,
    ),
    // 23. Diagnostic Plate
    IshiharaPlate(
      id: 23,
      plateNumber: 23,
      normalAnswer: '26',
      protanAnswer: '6',
      deutanAnswer: '2',
      deficiencyAnswer: '6',
      plateType: PlateType.diagnostic,
      explanation: 'Pelat diagnostik verifikasi Protan vs Deutan.',
      normalDescription: 'Mata normal melihat angka 26.',
      deficiencyDescription: 'Protanopia melihat angka 6. Deuteranopia melihat angka 2.',
      visualSeed: 123,
    ),
    // 24. Diagnostic Plate
    IshiharaPlate(
      id: 24,
      plateNumber: 24,
      normalAnswer: '42',
      protanAnswer: '2',
      deutanAnswer: '4',
      deficiencyAnswer: '2',
      plateType: PlateType.diagnostic,
      explanation: 'Pelat diagnostik verifikasi Protan vs Deutan.',
      normalDescription: 'Mata normal melihat angka 42.',
      deficiencyDescription: 'Protanopia melihat angka 2. Deuteranopia melihat angka 4.',
      visualSeed: 124,
    ),
  ];

  static List<IshiharaPlate> getPlatesForMode(String mode) {
    if (mode == 'quick') {
      // 12 essential plates for fast screening
      return [
        allPlates[0],  // 1 (Intro)
        allPlates[1],  // 2 (Transform 8->3)
        allPlates[2],  // 3 (Transform 5->2)
        allPlates[3],  // 4 (Transform 29->70)
        allPlates[4],  // 5 (Transform 74->21)
        allPlates[5],  // 6 (Vanishing 7)
        allPlates[6],  // 7 (Vanishing 45)
        allPlates[8],  // 9 (Vanishing 16)
        allPlates[9],  // 10 (Hidden 5)
        allPlates[11], // 12 (Diag 26)
        allPlates[12], // 13 (Diag 42)
        allPlates[14], // 15 (Diag 96)
      ];
    }
    // Full 24 plates
    return allPlates;
  }

  // Algoritma Evaluasi Diagnostik Medis Ishihara
  static TestResult evaluateTest({
    required String testMode,
    required List<UserPlateAnswer> answers,
  }) {
    int totalPlates = answers.length;
    int correctCount = answers.where((a) => a.isCorrect).length;
    double scorePercentage = totalPlates > 0 ? (correctCount / totalPlates) * 100 : 0.0;

    int protanIndications = 0;
    int deutanIndications = 0;
    int transformationDefects = 0;
    int vanishingFails = 0;

    for (var a in answers) {
      final plate = allPlates.firstWhere(
        (p) => p.plateNumber == a.plateNumber,
        orElse: () => allPlates.first,
      );

      final userClean = a.userAnswer.trim().toUpperCase();

      if (!a.isCorrect) {
        if (plate.plateType == PlateType.vanishing) {
          vanishingFails++;
        } else if (plate.plateType == PlateType.transformation) {
          if (plate.deficiencyAnswer != null &&
              userClean == plate.deficiencyAnswer!.toUpperCase()) {
            transformationDefects++;
          }
        }
      }

      if (plate.plateType == PlateType.diagnostic) {
        if (plate.protanAnswer != null && userClean == plate.protanAnswer!.toUpperCase()) {
          protanIndications++;
        }
        if (plate.deutanAnswer != null && userClean == plate.deutanAnswer!.toUpperCase()) {
          deutanIndications++;
        }
      }
    }

    DiagnosisType diagnosis;
    String diagnosisTitle;
    String diagnosisDescription;
    String recommendation;

    // Kriteria Medis
    if (correctCount >= totalPlates - 1) {
      diagnosis = DiagnosisType.normal;
      diagnosisTitle = 'Penglihatan Warna Normal (Trichromat)';
      diagnosisDescription = 
          'Penglihatan warna Anda berfungsi dengan sangat baik dan normal. '
          'Anda mampu membedakan spektrum warna merah, hijau, biru, dan kombinasinya tanpa hambatan.';
      recommendation = 
          'Selamat! Hasil Anda memenuhi syarat penglihatan warna untuk seluruh profesi, '
          'termasuk TNI, POLRI, Kedokteran, Penerbangan, Pelayaran, PT KAI, dan Teknik Elektro.';
    } else if (correctCount >= (totalPlates * 0.75)) {
      // Kelemahan ringan / anomali
      if (protanIndications > deutanIndications) {
        diagnosis = DiagnosisType.protanomaly;
        diagnosisTitle = 'Protanomali (Kelemahan Warna Merah Ringan/Sedang)';
        diagnosisDescription = 
            'Anda memiliki anomali pada sel kerucut fotoreseptor L (merah). '
            'Warna merah mungkin tampak sedikit pudar atau sulit dibedakan dengan warna gelap dan hijau dalam pencahayaan redup.';
        recommendation = 
            'Disarankan berkonsultasi dengan dokter spesialis mata (Sp.M) untuk uji konfirmasi Farnsworth D-15. '
            'Untuk aktivitas harian umumnya tidak ada kendala berarti.';
      } else if (deutanIndications > protanIndications) {
        diagnosis = DiagnosisType.deuteranomaly;
        diagnosisTitle = 'Deuteranomali (Kelemahan Warna Hijau Ringan/Sedang)';
        diagnosisDescription = 
            'Ini adalah jenis buta warna parsial yang paling umum. Sel kerucut M (hijau) mengalami pergeseran sensitivitas spektrum.';
        recommendation = 
            'Disarankan pemeriksaan lanjutan ke dokter mata. Pastikan pencahayaan cukup saat membaca kode warna atau grafik di tempat kerja.';
      } else {
        diagnosis = DiagnosisType.redGreenDefect;
        diagnosisTitle = 'Defisiensi Warna Merah-Hijau Parsial Ringan';
        diagnosisDescription = 
            'Terdapat beberapa kekeliruan dalam membaca pelat merah-hijau. Kemungkinan mengalami anomali persepsi warna ringan.';
        recommendation = 
            'Lakukan tes ulang di ruangan dengan pencahayaan alami matahari yang cukup.';
      }
    } else if (correctCount <= 2 && vanishingFails >= 4 && transformationDefects == 0) {
      diagnosis = DiagnosisType.totalColorBlind;
      diagnosisTitle = 'Achromatopsia (Kecurigaan Buta Warna Total)';
      diagnosisDescription = 
          'Anda hanya dapat membaca pelat pembuka dan kesulitan pada hampir semua variasi warna lainnya.';
      recommendation = 
          'Sangat disarankan segera berkonsultasi dengan dokter spesialis mata untuk pemeriksaan oftalmologi komprehensif.';
    } else {
      // Defisiensi sedang hingga berat (Dichromacy)
      if (protanIndications > deutanIndications) {
        diagnosis = DiagnosisType.protanopia;
        diagnosisTitle = 'Protanopia (Buta Warna Merah)';
        diagnosisDescription = 
            'Fotoreseptor kerucut merah (L-cone) tidak aktif secara optimal. '
            'Warna merah tampak lebih gelap dan sering tertukar dengan cokelat tua, abu-abu, atau hijau.';
        recommendation = 
            'Penting untuk memperhatikan lampu lalu lintas berdasarkan posisi (atas = merah) dan gunakan label warna pada perangkat kerja.';
      } else if (deutanIndications > protanIndications) {
        diagnosis = DiagnosisType.deuteranopia;
        diagnosisTitle = 'Deuteranopia (Buta Warna Hijau)';
        diagnosisDescription = 
            'Fotoreseptor kerucut hijau (M-cone) tidak aktif secara optimal. '
            'Warna hijau tampak menyerupai beige, kuning muda, atau abu-abu.';
        recommendation = 
            'Gunakan fitur aksesibilitas filter warna di smartphone/komputer Anda (Color Correction -> Deuteranomaly).';
      } else {
        diagnosis = DiagnosisType.redGreenDefect;
        diagnosisTitle = 'Buta Warna Merah-Hijau (Dichromacy)';
        diagnosisDescription = 
            'Kesulitan signifikan dalam membedakan pigmen warna merah dan hijau.';
        recommendation = 
            'Konsultasikan hasil ini dengan dokter mata profesional.';
      }
    }

    return TestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      testMode: testMode,
      totalPlates: totalPlates,
      correctCount: correctCount,
      scorePercentage: scorePercentage,
      diagnosis: diagnosis,
      diagnosisTitle: diagnosisTitle,
      diagnosisDescription: diagnosisDescription,
      recommendation: recommendation,
      plateAnswers: answers,
    );
  }
}

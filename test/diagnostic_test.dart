import 'package:flutter_test/flutter_test.dart';
import 'package:tes_buta_warna/data/ishihara_dataset.dart';
import 'package:tes_buta_warna/data/models/ishihara_plate.dart';
import 'package:tes_buta_warna/data/models/test_result.dart';

void main() {
  group('Ishihara Diagnostic Engine Tests', () {
    test('Semua jawaban normal harus menghasilkan diagnosis Trichromat Normal (100% Benar)', () {
      final plates = IshiharaDataset.getPlatesForMode('quick');
      final answers = plates.map((p) {
        return UserPlateAnswer(
          plateId: p.id,
          plateNumber: p.plateNumber,
          userAnswer: p.normalAnswer,
          normalAnswer: p.normalAnswer,
          deficiencyAnswer: p.deficiencyAnswer,
          plateType: p.plateType,
          isCorrect: true,
          responseTimeMs: 1200,
        );
      }).toList();

      final result = IshiharaDataset.evaluateTest(
        testMode: 'quick',
        answers: answers,
      );

      expect(result.diagnosis, DiagnosisType.normal);
      expect(result.correctCount, plates.length);
      expect(result.scorePercentage, 100.0);
    });

    test('Jawaban khas Protanopia harus terdiagnosa Protanopia', () {
      final plates = IshiharaDataset.getPlatesForMode('full');
      final answers = plates.map((p) {
        String answer;
        if (p.plateType == PlateType.introductory) {
          answer = p.normalAnswer; // 12
        } else if (p.plateType == PlateType.diagnostic && p.protanAnswer != null) {
          answer = p.protanAnswer!;
        } else if (p.deficiencyAnswer != null) {
          answer = p.deficiencyAnswer!;
        } else {
          answer = 'BLANK';
        }

        final isCorrect = p.isCorrect(answer);
        return UserPlateAnswer(
          plateId: p.id,
          plateNumber: p.plateNumber,
          userAnswer: answer,
          normalAnswer: p.normalAnswer,
          deficiencyAnswer: p.deficiencyAnswer,
          plateType: p.plateType,
          isCorrect: isCorrect,
          responseTimeMs: 2000,
        );
      }).toList();

      final result = IshiharaDataset.evaluateTest(
        testMode: 'full',
        answers: answers,
      );

      expect(result.diagnosis, DiagnosisType.protanopia);
    });

    test('Jawaban khas Deuteranopia harus terdiagnosa Deuteranopia', () {
      final plates = IshiharaDataset.getPlatesForMode('full');
      final answers = plates.map((p) {
        String answer;
        if (p.plateType == PlateType.introductory) {
          answer = p.normalAnswer; // 12
        } else if (p.plateType == PlateType.diagnostic && p.deutanAnswer != null) {
          answer = p.deutanAnswer!;
        } else if (p.deficiencyAnswer != null) {
          answer = p.deficiencyAnswer!;
        } else {
          answer = 'BLANK';
        }

        final isCorrect = p.isCorrect(answer);
        return UserPlateAnswer(
          plateId: p.id,
          plateNumber: p.plateNumber,
          userAnswer: answer,
          normalAnswer: p.normalAnswer,
          deficiencyAnswer: p.deficiencyAnswer,
          plateType: p.plateType,
          isCorrect: isCorrect,
          responseTimeMs: 2000,
        );
      }).toList();

      final result = IshiharaDataset.evaluateTest(
        testMode: 'full',
        answers: answers,
      );

      expect(result.diagnosis, DiagnosisType.deuteranopia);
    });
  });
}

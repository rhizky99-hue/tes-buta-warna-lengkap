import 'ishihara_plate.dart';

enum DiagnosisType {
  normal,          // Penglihatan Warna Normal
  protanopia,      // Buta warna merah berat
  protanomaly,     // Kelemahan warna merah sedang/ringan
  deuteranopia,    // Buta warna hijau berat
  deuteranomaly,   // Kelemahan warna hijau sedang/ringan
  redGreenDefect,  // Defisiensi merah-hijau umum
  totalColorBlind, // Buta warna total (Achromatopsia)
  inconclusive,    // Jawaban tidak konsisten / tes tidak selesai
}

class UserPlateAnswer {
  final int plateId;
  final int plateNumber;
  final String userAnswer;
  final String normalAnswer;
  final String? deficiencyAnswer;
  final PlateType plateType;
  final bool isCorrect;
  final int responseTimeMs;

  UserPlateAnswer({
    required this.plateId,
    required this.plateNumber,
    required this.userAnswer,
    required this.normalAnswer,
    this.deficiencyAnswer,
    required this.plateType,
    required this.isCorrect,
    required this.responseTimeMs,
  });

  Map<String, dynamic> toJson() => {
    'plateId': plateId,
    'plateNumber': plateNumber,
    'userAnswer': userAnswer,
    'normalAnswer': normalAnswer,
    'deficiencyAnswer': deficiencyAnswer,
    'plateType': plateType.index,
    'isCorrect': isCorrect,
    'responseTimeMs': responseTimeMs,
  };

  factory UserPlateAnswer.fromJson(Map<String, dynamic> json) => UserPlateAnswer(
    plateId: json['plateId'] as int,
    plateNumber: json['plateNumber'] as int,
    userAnswer: json['userAnswer'] as String,
    normalAnswer: json['normalAnswer'] as String,
    deficiencyAnswer: json['deficiencyAnswer'] as String?,
    plateType: PlateType.values[json['plateType'] as int],
    isCorrect: json['isCorrect'] as bool,
    responseTimeMs: json['responseTimeMs'] as int? ?? 0,
  );
}

class TestResult {
  final String id;
  final DateTime timestamp;
  final String testMode; // 'quick' (12) or 'full' (24)
  final int totalPlates;
  final int correctCount;
  final double scorePercentage;
  final DiagnosisType diagnosis;
  final String diagnosisTitle;
  final String diagnosisDescription;
  final String recommendation;
  final List<UserPlateAnswer> plateAnswers;

  TestResult({
    required this.id,
    required this.timestamp,
    required this.testMode,
    required this.totalPlates,
    required this.correctCount,
    required this.scorePercentage,
    required this.diagnosis,
    required this.diagnosisTitle,
    required this.diagnosisDescription,
    required this.recommendation,
    required this.plateAnswers,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'testMode': testMode,
    'totalPlates': totalPlates,
    'correctCount': correctCount,
    'scorePercentage': scorePercentage,
    'diagnosis': diagnosis.index,
    'diagnosisTitle': diagnosisTitle,
    'diagnosisDescription': diagnosisDescription,
    'recommendation': recommendation,
    'plateAnswers': plateAnswers.map((a) => a.toJson()).toList(),
  };

  factory TestResult.fromJson(Map<String, dynamic> json) => TestResult(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    testMode: json['testMode'] as String,
    totalPlates: json['totalPlates'] as int,
    correctCount: json['correctCount'] as int,
    scorePercentage: (json['scorePercentage'] as num).toDouble(),
    diagnosis: DiagnosisType.values[json['diagnosis'] as int],
    diagnosisTitle: json['diagnosisTitle'] as String,
    diagnosisDescription: json['diagnosisDescription'] as String,
    recommendation: json['recommendation'] as String,
    plateAnswers: (json['plateAnswers'] as List<dynamic>)
        .map((a) => UserPlateAnswer.fromJson(a as Map<String, dynamic>))
        .toList(),
  );
}

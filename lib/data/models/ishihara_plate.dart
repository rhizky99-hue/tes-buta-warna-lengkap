enum PlateType {
  introductory,    // Pelat 1 (Semua orang normal & buta warna melihat angka ini)
  transformation,  // Pelat yang terbaca angka berbeda oleh penderita
  vanishing,       // Hanya terlihat oleh mata normal
  hiddenDigit,     // Hanya terlihat oleh penderita buta warna merah-hijau
  diagnostic,      // Menentukan klasifikasi Protanopia (merah) vs Deuteranopia (hijau)
}

class IshiharaPlate {
  final int id;
  final int plateNumber;
  final String normalAnswer;
  final String? deficiencyAnswer;
  final String? protanAnswer;
  final String? deutanAnswer;
  final PlateType plateType;
  final String explanation;
  final String normalDescription;
  final String deficiencyDescription;
  final int visualSeed; // Deterministic seed for generating exact dot patterns

  const IshiharaPlate({
    required this.id,
    required this.plateNumber,
    required this.normalAnswer,
    this.deficiencyAnswer,
    this.protanAnswer,
    this.deutanAnswer,
    required this.plateType,
    required this.explanation,
    required this.normalDescription,
    required this.deficiencyDescription,
    required this.visualSeed,
  });

  bool isCorrect(String userAnswer) {
    final cleanUser = userAnswer.trim().toUpperCase();
    final cleanNormal = normalAnswer.trim().toUpperCase();
    if (cleanNormal == '' || cleanNormal == 'NONE' || cleanNormal == 'BLANK') {
      return cleanUser == '' || cleanUser == 'NONE' || cleanUser == 'BLANK' || cleanUser == '0';
    }
    return cleanUser == cleanNormal;
  }
}

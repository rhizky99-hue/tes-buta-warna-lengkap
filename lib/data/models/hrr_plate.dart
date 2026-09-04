enum HRRShape {
  circle,   // Lingkaran
  triangle, // Segitiga
  cross,    // Silang
}

enum HRRPlateCategory {
  demonstration,       // Semua orang bisa melihat (kontrol)
  screeningRedGreen,   // Deteksi merah-hijau
  screeningBlueYellow, // Deteksi biru-kuning (Tritan)
  diagnosticProtan,    // Deteksi spesifik defisiensi merah
  diagnosticDeutan,    // Deteksi spesifik defisiensi hijau
  diagnosticTritan,    // Deteksi spesifik defisiensi biru-kuning
}

class HRRPlate {
  final int id;
  final int plateNumber;
  final List<HRRShape> targetShapes; // Simbol target yang ditampilkan
  final HRRPlateCategory category;
  final String normalAnswerText;
  final String explanation;
  final int seed;

  const HRRPlate({
    required this.id,
    required this.plateNumber,
    required this.targetShapes,
    required this.category,
    required this.normalAnswerText,
    required this.explanation,
    required this.seed,
  });

  bool matchesAnswer(List<HRRShape> userSelected) {
    if (userSelected.length != targetShapes.length) return false;
    final userSet = userSelected.toSet();
    final targetSet = targetShapes.toSet();
    return userSet.length == targetSet.length && userSet.containsAll(targetSet);
  }
}

/// Lightweight surah item from `/surah`.
class SurahModel {
  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  String get title => englishName;
  String get subtitle => englishNameTranslation;
  String get arabicName => name;
  int get ayahCount => numberOfAyahs;

  int get startJuz => _juzRange.$1;
  int get endJuz => _juzRange.$2;

  /// Short metadata shown on the surah card.
  String get meta {
    final juzText = startJuz == endJuz
        ? 'Juz $startJuz'
        : 'Juz $startJuz-$endJuz';
    return '$juzText  •  $numberOfAyahs Ayat';
  }

  /// Checks whether this surah belongs to the selected Juz range.
  bool containsJuz(int juz) => juz >= startJuz && juz <= endJuz;

  (int, int) get _juzRange {
    return _surahJuzRanges[number] ?? (1, 1);
  }

  /// Creates a surah item from API JSON.
  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
      numberOfAyahs: json['numberOfAyahs'] as int? ?? 0,
      revelationType: json['revelationType'] as String? ?? '',
    );
  }
}

/// Local Juz range mapping used by the Home Juz navigation.
const Map<int, (int, int)> _surahJuzRanges = {
  1: (1, 1),
  2: (1, 3),
  3: (3, 4),
  4: (4, 6),
  5: (6, 7),
  6: (7, 8),
  7: (8, 9),
  8: (9, 10),
  9: (10, 11),
  10: (11, 11),
  11: (11, 12),
  12: (12, 13),
  13: (13, 13),
  14: (13, 13),
  15: (14, 14),
  16: (14, 14),
  17: (15, 15),
  18: (15, 16),
  19: (16, 16),
  20: (16, 16),
  21: (17, 17),
  22: (17, 17),
  23: (18, 18),
  24: (18, 18),
  25: (18, 19),
  26: (19, 19),
  27: (19, 20),
  28: (20, 20),
  29: (20, 21),
  30: (21, 21),
  31: (21, 21),
  32: (21, 21),
  33: (21, 22),
  34: (22, 22),
  35: (22, 22),
  36: (22, 23),
  37: (23, 23),
  38: (23, 23),
  39: (23, 24),
  40: (24, 24),
  41: (24, 25),
  42: (25, 25),
  43: (25, 25),
  44: (25, 25),
  45: (25, 25),
  46: (26, 26),
  47: (26, 26),
  48: (26, 26),
  49: (26, 26),
  50: (26, 26),
  51: (26, 27),
  52: (27, 27),
  53: (27, 27),
  54: (27, 27),
  55: (27, 27),
  56: (27, 27),
  57: (27, 27),
  58: (28, 28),
  59: (28, 28),
  60: (28, 28),
  61: (28, 28),
  62: (28, 28),
  63: (28, 28),
  64: (28, 28),
  65: (28, 28),
  66: (28, 28),
  67: (29, 29),
  68: (29, 29),
  69: (29, 29),
  70: (29, 29),
  71: (29, 29),
  72: (29, 29),
  73: (29, 29),
  74: (29, 29),
  75: (29, 29),
  76: (29, 29),
  77: (29, 29),
  78: (30, 30),
  79: (30, 30),
  80: (30, 30),
  81: (30, 30),
  82: (30, 30),
  83: (30, 30),
  84: (30, 30),
  85: (30, 30),
  86: (30, 30),
  87: (30, 30),
  88: (30, 30),
  89: (30, 30),
  90: (30, 30),
  91: (30, 30),
  92: (30, 30),
  93: (30, 30),
  94: (30, 30),
  95: (30, 30),
  96: (30, 30),
  97: (30, 30),
  98: (30, 30),
  99: (30, 30),
  100: (30, 30),
  101: (30, 30),
  102: (30, 30),
  103: (30, 30),
  104: (30, 30),
  105: (30, 30),
  106: (30, 30),
  107: (30, 30),
  108: (30, 30),
  109: (30, 30),
  110: (30, 30),
  111: (30, 30),
  112: (30, 30),
  113: (30, 30),
  114: (30, 30),
};

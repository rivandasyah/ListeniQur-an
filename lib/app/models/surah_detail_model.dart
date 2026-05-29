import 'surah_model.dart';

/// Detailed surah response with ayah audio URLs.
class SurahDetailModel {
  const SurahDetailModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
    required this.edition,
  });

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<AyahAudioModel> ayahs;
  final EditionModel edition;

  String get title => englishName;
  String get subtitle => englishNameTranslation;
  String get arabicName => name;

  /// Converts detail data back to the lightweight surah item.
  SurahModel get surah {
    return SurahModel(
      number: number,
      name: name,
      englishName: englishName,
      englishNameTranslation: englishNameTranslation,
      numberOfAyahs: numberOfAyahs,
      revelationType: revelationType,
    );
  }

  /// Creates detail data from API JSON.
  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    final ayahsJson = json['ayahs'] as List? ?? [];

    return SurahDetailModel(
      number: json['number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      englishNameTranslation: json['englishNameTranslation'] as String? ?? '',
      revelationType: json['revelationType'] as String? ?? '',
      numberOfAyahs: json['numberOfAyahs'] as int? ?? 0,
      ayahs: ayahsJson
          .map((e) => AyahAudioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      edition: EditionModel.fromJson(
        json['edition'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Audio data for one ayah.
class AyahAudioModel {
  const AyahAudioModel({
    required this.number,
    required this.audio,
    required this.audioSecondary,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  final int number;
  final String audio;
  final List<String> audioSecondary;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  /// Creates ayah audio data from API JSON.
  factory AyahAudioModel.fromJson(Map<String, dynamic> json) {
    final audioSecondaryJson = json['audioSecondary'] as List? ?? [];

    return AyahAudioModel(
      number: json['number'] as int? ?? 0,
      audio: json['audio'] as String? ?? '',
      audioSecondary: audioSecondaryJson.map((e) => e.toString()).toList(),
      text: json['text'] as String? ?? '',
      numberInSurah: json['numberInSurah'] as int? ?? 0,
      juz: json['juz'] as int? ?? 0,
      manzil: json['manzil'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      ruku: json['ruku'] as int? ?? 0,
      hizbQuarter: json['hizbQuarter'] as int? ?? 0,
      sajda: json['sajda'] is bool ? json['sajda'] as bool : false,
    );
  }
}

/// Edition and reciter metadata from the API.
class EditionModel {
  const EditionModel({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    required this.direction,
  });

  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  /// Creates edition metadata from API JSON.
  factory EditionModel.fromJson(Map<String, dynamic> json) {
    return EditionModel(
      identifier: json['identifier'] as String? ?? '',
      language: json['language'] as String? ?? '',
      name: json['name'] as String? ?? '',
      englishName: json['englishName'] as String? ?? '',
      format: json['format'] as String? ?? '',
      type: json['type'] as String? ?? '',
      direction: json['direction'] as String?,
    );
  }
}

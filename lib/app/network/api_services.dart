import 'package:dio/dio.dart';

import '../models/surah_detail_model.dart';
import '../models/surah_model.dart';
import 'api_exception.dart';
import 'dio_client.dart';

/// Quran API endpoints used by the app.
class ApiServices {
  ApiServices({DioClient? dioClient})
    : _dio = (dioClient ?? DioClient.instance).dio;

  static const String alafasyEdition = 'ar.alafasy';

  final Dio _dio;

  /// Loads the 114 surahs for the Home screen.
  Future<List<SurahModel>> getSurahs() async {
    try {
      final res = await _dio.get<dynamic>('/surah');
      final List list = res.data['data'] as List;

      return list.map((e) => SurahModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Loads one surah with ayah audio URLs.
  Future<SurahDetailModel> getSurah({
    required int number,
    String edition = alafasyEdition,
  }) async {
    try {
      final res = await _dio.get<dynamic>('/surah/$number/$edition');
      final data = res.data['data'] as Map<String, dynamic>;

      return SurahDetailModel.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

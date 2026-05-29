import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../models/surah_detail_model.dart';
import '../../../models/surah_model.dart';

/// Handles ayah-based Quran playback for the Player screen.
class PlayerController extends GetxController {
  PlayerController({AudioPlayer? audioPlayer})
    : _player = audioPlayer ?? AudioPlayer();

  final AudioPlayer _player;

  late final SurahDetailModel surahDetail;
  late final SurahModel surah;

  final errorMessage = ''.obs;
  final isPlaying = false.obs;
  final isBuffering = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;
  final currentAyahIndex = 0.obs;

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  bool _isAudioSessionConfigured = false;

  @override
  void onInit() {
    final arguments = Get.arguments;
    surahDetail = arguments is SurahDetailModel
        ? arguments
        : const SurahDetailModel(
            number: 1,
            name: 'سُورَةُ ٱلْفَاتِحَةِ',
            englishName: 'Al-Faatiha',
            englishNameTranslation: 'The Opening',
            revelationType: 'Meccan',
            numberOfAyahs: 7,
            ayahs: [],
            edition: EditionModel(
              identifier: 'ar.alafasy',
              language: 'ar',
              name: 'مشاري العفاسي',
              englishName: 'Alafasy',
              format: 'audio',
              type: 'versebyverse',
              direction: null,
            ),
          );
    surah = surahDetail.surah;

    super.onInit();
    _bindAudioPlayer();
    prepareAudio();
  }

  /// Progress for the currently playing ayah only.
  double get progress {
    if (duration.value.inMilliseconds == 0) {
      return 0;
    }

    return position.value.inMilliseconds / duration.value.inMilliseconds;
  }

  String get ayahText => '${surah.subtitle} (${surah.numberOfAyahs} Ayah)';

  /// Juz label shown as secondary playback context.
  String get juzText {
    if (surah.startJuz == surah.endJuz) {
      return 'Juz ${surah.startJuz}';
    }

    return 'Juz ${surah.startJuz}-${surah.endJuz}';
  }

  /// Current ayah label from just_audio `currentIndexStream`.
  String get ayahPositionText {
    final ayahNumber = currentAyahIndex.value + 1;
    return 'Ayah $ayahNumber of ${surah.numberOfAyahs}';
  }

  /// Creates one playlist containing all ayah audio URLs and starts playback.
  Future<void> prepareAudio() async {
    try {
      errorMessage.value = '';
      position.value = Duration.zero;
      duration.value = Duration.zero;
      currentAyahIndex.value = 0;

      await _player.stop();
      await _configureAudioSession();

      final ayahs = surahDetail.ayahs.where((ayah) => ayah.audio.isNotEmpty);
      // ignore: deprecated_member_use
      final playlist = ConcatenatingAudioSource(
        children: ayahs
            .map((ayah) => AudioSource.uri(Uri.parse(ayah.audio), tag: ayah))
            .toList(),
      );

      if (playlist.length == 0) {
        throw const PlayerAudioException('No audio source found');
      }

      await _player.setAudioSource(playlist);
      await _player.play();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  /// Formats a duration as mm:ss.
  String formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Toggles play, pause, and resume on a single AudioPlayer.
  Future<void> togglePlayback() async {
    if (_player.playing) {
      await _player.pause();
      return;
    }

    await _player.play();
  }

  /// Seeks within the current ayah only.
  Future<void> seekToProgress(double value) async {
    if (duration.value == Duration.zero) {
      return;
    }

    final nextMilliseconds = duration.value.inMilliseconds * value;
    await _player.seek(Duration(milliseconds: nextMilliseconds.round()));
  }

  /// Skips backward 5 seconds within the current ayah.
  Future<void> skipBackward() async {
    final next = position.value - const Duration(seconds: 5);
    await _player.seek(next.isNegative ? Duration.zero : next);
  }

  /// Skips forward 5 seconds within the current ayah.
  Future<void> skipForward() async {
    final currentDuration = duration.value;
    if (currentDuration == Duration.zero) {
      return;
    }

    final next = position.value + const Duration(seconds: 5);
    await _player.seek(next < currentDuration ? next : currentDuration);
  }

  /// Binds just_audio streams to GetX state for the UI.
  void _bindAudioPlayer() {
    _subscriptions.addAll([
      _player.playingStream.listen((playing) {
        isPlaying.value = playing;
      }),
      _player.positionStream.listen((value) {
        position.value = value;
      }),
      _player.durationStream.listen((value) {
        duration.value = value ?? Duration.zero;
      }),
      _player.currentIndexStream.listen((index) {
        currentAyahIndex.value = index ?? 0;
        position.value = Duration.zero;
        duration.value = _player.duration ?? Duration.zero;
      }),
      _player.processingStateStream.listen((state) {
        isBuffering.value =
            state == ProcessingState.loading ||
            state == ProcessingState.buffering;
      }),
    ]);
  }

  /// Configures the audio session and pauses on common interruptions.
  Future<void> _configureAudioSession() async {
    if (_isAudioSessionConfigured) {
      return;
    }

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _isAudioSessionConfigured = true;

    _subscriptions.add(
      session.becomingNoisyEventStream.listen((_) {
        _player.pause();
      }),
    );
    _subscriptions.add(
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          _player.pause();
        }
      }),
    );
  }

  @override
  void onClose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _player.dispose();
    super.onClose();
  }
}

class PlayerAudioException implements Exception {
  const PlayerAudioException(this.message);

  final String message;

  @override
  String toString() => message;
}

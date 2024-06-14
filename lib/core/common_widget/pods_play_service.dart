import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  Stream<Duration?> get positionStream => _audioPlayer.positionStream;

  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  Future<void> setUrl(String url) async {
    await _audioPlayer.setUrl(url);
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  void seekForMeditationAudio({required Duration position, int? index}) {
    audioPlayer.seek(position, index: index);
  }

  Future<void> skipForward() async {
    final currentPosition = _audioPlayer.position;
    await _audioPlayer.seek(currentPosition + const Duration(seconds: 15));
  }

  Future<void> skipBackward() async {
    final currentPosition = _audioPlayer.position;
    await _audioPlayer.seek(currentPosition - const Duration(seconds: 15));
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

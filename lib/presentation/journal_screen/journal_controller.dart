import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class JournalController extends GetxController{
  ///___________________ audio service Common File ________-
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rx<Duration?> _position = Duration.zero.obs;
  final Rx<Duration?> _duration = Duration.zero.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isVisible = false.obs;

  AudioPlayer get audioPlayer => _audioPlayer;

  Rx<Duration?> get positionStream => _position;

  Rx<Duration?> get durationStream => _duration;

  RxBool get isPlaying => _isPlaying;

  RxBool get isVisible => _isVisible;

  Future<void> play() async {
    _isVisible.value = true;
    await _audioPlayer.play();
    update();
    update(["update"]);

  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    update(["update"]);
  }

  void seekForMeditationAudio({required Duration position, int? index}) {
    _audioPlayer.seek(position, index: index);
  }

  Future<void> skipForward() async {
    final currentPosition = _audioPlayer.position;
    await _audioPlayer.seek(currentPosition + const Duration(seconds: 15));
  }

  Future<void> skipBackward() async {
    final currentPosition = _audioPlayer.position;
    await _audioPlayer.seek(currentPosition - const Duration(seconds: 15));
  }

  Future<void> disposeAudio() async {
    await _audioPlayer.dispose();
    _isVisible.value = false;
  }

  @override
  Future<void> onClose() async {
    await _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> reset() async {
    await _audioPlayer.stop();
    _isVisible.value = false;
    update(["update"]);

  }

  Future<void> setUrl(String url) async {


    await _audioPlayer.setUrl(url);
    update(["update"]);

  }
}
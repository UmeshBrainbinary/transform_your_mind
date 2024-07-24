import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AffirmationController extends GetxController{
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
  void seekForMeditationAudio({required Duration position, int? index}) {
    _audioPlayer.seek(position, index: index);
  }
  Future<void> play() async {
    _isVisible.value = true;
    await _audioPlayer.play();
    update();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  void onInit() {
    _audioPlayer.positionStream.listen((event) {
      _position.value = event;
    });
    _audioPlayer.durationStream.listen((event) {
      _duration.value = event;
    });
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying.value = state.playing;
    });
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _onAudioFinished();
      }
    });
    super.onInit();
  }
  void _onAudioFinished() async {
    await _audioPlayer.seek(Duration.zero);
    await pause();
    isPlaying.value = false;
    update();
  }
  String? currentUrl;


  Future<void> setUrl(String url,
      {String? name,
        String? expertName,
        String? description,
        String? img}) async {


    update();
    if (_isPlaying.value) {
      // Option 1: Do nothing if the same URL is playing
      if (currentUrl == url) return;
      await _audioPlayer.stop();
    }
    if (currentUrl == url) return;
    currentUrl = url;
    await _audioPlayer.setUrl(url);
  }
}
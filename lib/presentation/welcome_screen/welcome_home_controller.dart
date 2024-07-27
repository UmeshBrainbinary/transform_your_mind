import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class WelcomeHomeController extends GetxController{
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
    await _audioPlayer.play();
    update();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  void onInit() {

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
    await _audioPlayer.setAsset(url);
    update();
  }
}
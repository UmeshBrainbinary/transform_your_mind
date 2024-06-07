import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:network_services/apiServices/networkService/network_service.dart';
import 'package:transform_your_mind/core/common_widget/common_gradiant_container.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:video_player/video_player.dart';

import '../utils/audio_manager/audio_player_manager.dart';


List<GlobalKey<VideoThumbWidgetState>> videoKeys = [
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
  GlobalKey<VideoThumbWidgetState>(),
];

class VideoThumbWidget extends StatefulWidget {
  final VoidCallback onTap;

  const VideoThumbWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<VideoThumbWidget> createState() => VideoThumbWidgetState();
}

class VideoThumbWidgetState extends State<VideoThumbWidget> {
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  bool enteredInFullScreen = false;
  ValueNotifier<bool> playVideo = ValueNotifier(false);
  final NetworkService network = NetworkService();
  @override
  void initState() {
    super.initState();
    getVideoLoad();
  }

  final AudioPlayerManager _audioPlayerManager = AudioPlayerManager();

  getVideoLoad() async {
    //check if it will run on offline
 /*   if (network.isConnected) {
      videoPlayerController = VideoPlayerController.network(
          widget.tutorialVideoData.videoUrl ?? '');
      await videoPlayerController!.initialize();
    }*/
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    if (_audioPlayerManager.isBackgroundAudioPlaying) {
      _audioPlayerManager.playPauseEventHandler(
          audioPlayPauseEvent: AudioPlayPauseEvent.playBgAudio);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: playVideo,
        builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
           /*   if (widget.tutorialVideoData.videoUrl?.isNotEmpty ?? false) {
                widget.onTap.call();
                playVideo.value = true;
                chewieController = ChewieController(
                  videoPlayerController: videoPlayerController!,
                  autoPlay: true,
                  looping: false,
                  showControlsOnInitialize: false,
                  showOptions: false,
                  allowFullScreen: true,
                  allowPlaybackSpeedChanging: false,
                  materialProgressColors: ChewieProgressColors(
                    playedColor: themeManager.colorThemed6,
                    bufferedColor: themeManager.colorThemed6.withOpacity(0.2),
                    handleColor: const Color.fromRGBO(200, 200, 200, 1.0),
                    backgroundColor: const Color.fromRGBO(200, 200, 200, 0.5),
                  ),
                  deviceOrientationsAfterFullScreen: [
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ],
                  deviceOrientationsOnEnterFullScreen: [
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight
                  ],
                );
                videoPlayerController?.addListener(() {
                  if (!(chewieController?.isPlaying ?? false)) {
                    if (_audioPlayerManager.isBackgroundAudioPlaying) {
                      _audioPlayerManager.playPauseEventHandler(
                          audioPlayPauseEvent: AudioPlayPauseEvent.playBgAudio);
                    }
                  } else {
                    _audioPlayerManager.playPauseEventHandler(
                        audioPlayPauseEvent: AudioPlayPauseEvent.pauseBgAudio);
                    _audioPlayerManager.playPauseEventHandler(
                        audioPlayPauseEvent:
                        AudioPlayPauseEvent.pauseMeditationAudio);

                    _audioPlayerManager.isMiniAudioPlayerInPlayingState.value =
                    false;
                    videoPlayerController?.removeListener(() {});
                    return;
                  }
                  if (chewieController?.isFullScreen ?? false) {
                    enteredInFullScreen = true;
                  }
                });
              }*/
            },
            child: Container(
              height: getHeight(MediaQuery.of(context).size.width),
              decoration: BoxDecoration(borderRadius: Dimens.d20.radiusAll),
              child: !playVideo.value
                  ? Stack(
                children: [
                  CommonLoadImage(
                    url:'' ?? '',
                    width: double.infinity,
                    height: getHeight(MediaQuery.of(context).size.width),
                    borderRadius: Dimens.d16,
                  ),
                  Container(
                    height: getHeight(MediaQuery.of(context).size.width),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: Dimens.d16.radiusAll,
                        color: Colors.black.withOpacity(Dimens.d0_2)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      ImageConstant.imgPlayButton,
                      height: Dimens.d40,
                      width: Dimens.d40,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: Dimens.d16.paddingAll,
                      height: Dimens.d20.h,
                      width: Dimens.d53,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Dimens.d50.radiusAll,
                      ),
                      child: Text(
                        ""?? '',
                        style: Style.montserratRegular(
                            fontSize: Dimens.d14, ),
                      ),
                    ),
                  ),
                ],
              )
                  : Container(
                height: getHeight(MediaQuery.of(context).size.width),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Chewie(controller: chewieController!),
                ),
              ),
            ),
          );
        });
  }

  void play() {
    videoPlayerController?.play();
  }

  void pause() {
    if (!(chewieController?.isFullScreen ?? false)) {
      videoPlayerController?.pause();
    }
  }
}

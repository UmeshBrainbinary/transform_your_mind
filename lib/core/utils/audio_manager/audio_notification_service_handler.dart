// import 'dart:convert';
//
// import 'package:audio_service/audio_service.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dartz/dartz.dart';
// import 'package:shoorah/features/data/modal/response_modal/common_response.dart';
//
// import '../../../../core/base/api_error.dart';
// import '../../../../core/utils/common_imports.dart';
// import '../../../../core/utils/shared_pref_utils.dart';
// import '../../../../features/data/modal/request_modal/add_trendings_request.dart';
// import '../../../features/domain/usecases/add_trendings_usecase.dart';
// import '../../../features/presentation/choose_theme/sound_player_model.dart';
// import '../../common_widgets/tutorial_video_player.dart';
// import '../../network/network_state.dart';
// import 'audio_player_manager.dart';
//
// class AudioNotificationServiceHandler extends BaseAudioHandler {
//   bool isBgAudioPlayerInFocus = true;
//   bool isBgAudioPlayerStopped = false;
//   final AudioPlayerManager _audioPlayerManager;
//   final NetworkService network = sl<NetworkService>();
//
//   AudioNotificationServiceHandler(
//       {required AudioPlayerManager audioPlayerManager})
//       : _audioPlayerManager = audioPlayerManager {
//     handleBgAudioPlayerControllerForNotification();
//   }
//
//   @override
//   Future<void> play() async {
//     if (isBgAudioPlayerInFocus) {
//       _audioPlayerManager.isBackgroundAudioPlaying = true;
//
//       listenForBgAudioDataChanges();
//       _audioPlayerManager.playPauseEventHandler(
//           audioPlayPauseEvent: AudioPlayPauseEvent.playBgAudio);
//     } else {
//       for (var element in videoKeys) {
//         element.currentState?.pause();
//       }
//       _audioPlayerManager.playPauseEventHandler(
//           audioPlayPauseEvent: AudioPlayPauseEvent.pauseBgAudio);
//       listenForAudioDataChanges();
//       _audioPlayerManager
//         ..playPauseEventHandler(
//             audioPlayPauseEvent: AudioPlayPauseEvent.playMeditationAudio)
//         ..isMiniAudioPlayerInPlayingState.value = true;
//     }
//   }
//
//   @override
//   Future<void> pause() async {
//     if (isBgAudioPlayerInFocus) {
//       _audioPlayerManager.isBackgroundAudioPlaying = false;
//
//       listenForBgAudioDataChanges();
//       _audioPlayerManager.playPauseEventHandler(
//           audioPlayPauseEvent: AudioPlayPauseEvent.pauseBgAudio);
//     } else {
//       listenForAudioDataChanges();
//       _audioPlayerManager
//         ..playPauseEventHandler(
//             audioPlayPauseEvent: AudioPlayPauseEvent.pauseMeditationAudio)
//         ..isMiniAudioPlayerInPlayingState.value = false;
//     }
//   }
//
//   @override
//   Future<void> stop() async {
//     isBgAudioPlayerInFocus = true;
//     _audioPlayerManager.isMeditationAudioPlaying.value =
//         !_audioPlayerManager.isMeditationAudioPlaying.value;
//     _audioPlayerManager.isMiniAudioPlayerHovering = false;
//     listenForBgAudioDataChanges();
//     _audioPlayerManager.stopMeditationAudio();
//     _audioPlayerManager.playPauseEventHandler(
//         audioPlayPauseEvent: AudioPlayPauseEvent.playBgAudio);
//     _audioPlayerManager.currentAudioPlayingId = null;
//     _audioPlayerManager.audioPlayer.seek(Duration.zero, index: 0);
//     SharedPrefUtils.removeValue(SharedPrefUtilsKeys.currentPlayingTrack);
//     ConnectivityResult result = await Connectivity().checkConnectivity();
//     if (result == ConnectivityResult.mobile ||
//         result == ConnectivityResult.wifi) {
//       await _addTrendingApi();
//     }
//   }
//
//   Future<void> _addTrendingApi() async {
//     var trendingValue =
//         SharedPrefUtils.getValue(SharedPrefUtilsKeys.addTrendings, '');
//     AddTrendings trendings = trendingValue.isNotEmpty
//         ? AddTrendings.fromJson(jsonDecode(trendingValue))
//         : AddTrendings();
//     if (trendings.duration != 0) {
//       Either<CommonResponse, APIError> trendingResponse =
//           await sl<AddTrendingsUseCase>().call(trendings);
//       trendingResponse.fold((l) async {
//         if (l.meta?.code == 1) {
//           showLog(message: 'new token response ==> ${l.toJson()}');
//         } else {
//           showLog(message: 'Something went wrong!');
//         }
//       }, (r) {
//         showLog(message: 'Something went wrong!');
//       });
//     }
//   }
//
//   void listenForAudioDataChanges() {
//     if (network.isConnected) {
//       mediaItem.add(
//         MediaItem(
//           id: _audioPlayerManager.meditationAudioData?.contentId ?? 'unique_id',
//           album:
//               _audioPlayerManager.meditationAudioData?.expertName ?? 'Shoorah',
//           title:
//               _audioPlayerManager.meditationAudioData?.contentName ?? 'Shoorah',
//           duration: _audioPlayerManager.currentlyPlayingMeditationAudioDuration,
//           artUri: Uri.parse(_audioPlayerManager.meditationAudioData?.image ??
//               _audioPlayerManager.meditationAudioData?.expertImage ??
//               'https://d12231i07r54en.cloudfront.net/app_configs/shoorah_logo.png'),
//         ),
//       );
//     }
//   }
//
//   void handleAudioPlayerControllerForNotification() {
//     _audioPlayerManager.audioPlayer.playingStream.listen((event) {
//       playbackState.add(
//         PlaybackState(
//           controls: [
//             if (!isBgAudioPlayerStopped)
//               if (!isBgAudioPlayerInFocus)
//                 if (event) MediaControl.pause else MediaControl.play,
//             MediaControl.stop,
//           ],
//           playing: event,
//           updatePosition: _audioPlayerManager.audioPlayer.position,
//           bufferedPosition: _audioPlayerManager.audioPlayer.bufferedPosition,
//           speed: _audioPlayerManager.audioPlayer.speed,
//         ),
//       );
//     });
//   }
//
//   void listenForBgAudioDataChanges({String? value}) {
//     if (network.isConnected) {
//       if (isBgAudioPlayerInFocus) {
//         handleBgAudioPlayerControllerForNotification();
//       }
//
//       String audioName = SoundPlayerConst()
//           .listOfSounds[SharedPrefUtils.getValue(
//                   (SharedPrefUtilsKeys.selectedBgSoundId), 0) %
//               6]
//           .songName;
//       mediaItem.add(
//         MediaItem(
//           id: 'unique_id_$audioName',
//           album: value ?? audioName,
//           title: value ?? audioName,
//           artUri: Uri.parse(value ??
//               'https://d12231i07r54en.cloudfront.net/app_configs/shoorah_logo.png'),
//         ),
//       );
//     }
//   }
//
//   void handleBgAudioPlayerControllerForNotification() {
//     _audioPlayerManager.bgAudioPlayer.playingStream.listen((event) {
//       playbackState.add(
//         PlaybackState(
//           controls: [
//             if (!isBgAudioPlayerStopped)
//               if (event) MediaControl.pause else MediaControl.play,
//           ],
//           playing: event,
//           updatePosition: _audioPlayerManager.bgAudioPlayer.position,
//           bufferedPosition: _audioPlayerManager.bgAudioPlayer.bufferedPosition,
//           speed: _audioPlayerManager.bgAudioPlayer.speed,
//         ),
//       );
//     });
//   }
//
//   void closeNotification() {
//     isBgAudioPlayerStopped = true;
//   }
// }

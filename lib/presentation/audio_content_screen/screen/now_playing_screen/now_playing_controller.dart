import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';

class NowPlayingController extends GetxController {
  TextEditingController ratingController = TextEditingController();
  FocusNode ratingFocusNode = FocusNode();
  int? currentRating = 0;

  ///___________________ audio service Common File ________-
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Rx<Duration?> _position = Duration.zero.obs;
  final Rx<Duration?> _duration = Duration.zero.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isVisible = false.obs;
  String? _currentUrl;
  String? currentName;
  String? currentDescription;
  String? currentExpertName;
  String? currentImage;

  AudioPlayer get audioPlayer => _audioPlayer;

  Rx<Duration?> get positionStream => _position;

  Rx<Duration?> get durationStream => _duration;

  RxBool get isPlaying => _isPlaying;

  RxBool get isVisible => _isVisible;

  RxBool loader = false.obs;
  GetPodsModel getPodsModel = GetPodsModel();
  GetUserModel getUserModel = GetUserModel();
  List bookmarkedList = [];
  List ratedList = [];
  RxBool bookmark = false.obs;
  RxBool rated = false.obs;

  getPodsData() async {
    loader.value = true;
    await getPodApi();
    loader.value = false;
    update(['update']);
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
    super.onInit();
  }

  Future<void> setUrl(String url,
      {String? name,
      String? expertName,
      String? description,
      String? img}) async {
    currentName = name;
    currentName = expertName;
    currentName = description;
    currentImage = img;
    update();
    if (_currentUrl == url) return;
    _currentUrl = url;
    await _audioPlayer.setUrl(url);
  }

  Future<void> play() async {
    _isVisible.value = true;
    await _audioPlayer.play();
    update();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
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
    _currentUrl = null;
    await _audioPlayer.stop();
    _isVisible.value = false;
  }

  addBookmark(id, BuildContext context, bool value) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
      request.fields.addAll({'isBookMarked': '$value', 'podId': id});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        /*  showSnackBarSuccess(
            context, "yourSoundsSuccessfullyBookmarked".tr);*/
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addRating(
      {String? id,
      BuildContext? context,
      bool? value,
      int? star,
      String? note}) async {
    loader.value = true;
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.updateUser}${PrefService.getString(PrefKey.userId)}'));
    request.fields.addAll({
      'isRating': 'true',
      'podId': id ?? "",
      'star': "$star",
      'note': ratingController.text ?? ""
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loader.value = false;
      Get.back();
      showSnackBarSuccess(context!, "ratingsAdded".tr);

      debugPrint(await response.stream.bytesToString());
    } else if (response.statusCode == 400) {
      loader.value = false;

      showSnackBarSuccess(context!, "alreadyRated".tr);
      Get.back();
      debugPrint(response.reasonPhrase);
    } else {
      loader.value = false;

      debugPrint(response.reasonPhrase);
    }
    loader.value = false;
  }

  List<RatedPod>? ratedPods = [];

  getUser(
    String? id,
  ) async {
    currentRating = 0;
    ratingController.clear();
    bookmarkedList = [];
    bookmark = false.obs;
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
        'GET',
        Uri.parse(
          "${EndPoints.getUser}${PrefService.getString(PrefKey.userId)}",
        ),
      );

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getUserModel = getUserModelFromJson(responseBody);
        ratedPods = getUserModel.data?.ratedPods ?? [];
        for (int i = 0; i < getUserModel.data!.bookmarkedPods!.length; i++) {
          bookmarkedList.add(getUserModel.data!.bookmarkedPods![i]);
        }
        if (bookmarkedList.contains(id)) {
          bookmark.value = true;
        } else {
          bookmark.value = false;
        }
        for (int i = 0; i < getUserModel.data!.ratedPods!.length; i++) {
          if (getUserModel.data!.ratedPods![i].podId == id) {
            currentRating = getUserModel.data!.ratedPods![i].star;
            ratingController.text = getUserModel.data!.ratedPods![i].note ?? "";
            ratedList.add(getUserModel.data!.ratedPods![i]);
          }
        }

        debugPrint("Bookmark List $bookmarkedList");
        debugPrint("rated List $ratedList");
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;
  }

  final ValueNotifier<double> slideValue = ValueNotifier(40.0);
  final ValueNotifier<bool> isAudioLoading = ValueNotifier(false);

  final ValueNotifier<Duration> updatedRealtimeAudioDuration =
      ValueNotifier(const Duration(hours: 0, minutes: 0, seconds: 0));

  getPodApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request('GET', Uri.parse(EndPoints.getPod));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getPodsModel = getPodsModelFromJson(responseBody);
        update(['update']);
      } else {
        print(response.reasonPhrase);
        update(['update']);
      }
    } catch (e) {
      loader.value = false;
      debugPrint(e.toString());
    }
    update(['update']);
  }
}

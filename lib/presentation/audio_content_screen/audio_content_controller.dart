import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';

class AudioContentController extends GetxController {
  RxList<AudioData> audioData = <AudioData>[].obs;
  RxList<AudioData> audioDataDownloaded = <AudioData>[].obs;

  @override
  void onInit() {
    checkInternet();
    super.onInit();
  }

  checkInternet() async {
    if (await isConnected()) {
      getPodsData();
    } else {
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  RxList<AudioData> filterList(String query, RxList<AudioData> dataList) {
    if (query.isEmpty) {
      getPodApi();
    }
    return dataList
        .where(
            (audio) => audio.name!.toLowerCase().contains(query.toLowerCase()))
        .toList()
        .obs;
  }

  getPodsData() async {
    loader.value = true;
    await getPodApi();
    loader.value = false;
    update(['update']);
  }

  List audioListDuration = [];
  List audioListDurationD = [];

  RxBool loader = false.obs;
  RxBool loaderD = false.obs;
  GetPodsModel getPodsModel = GetPodsModel();
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> getPodApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              '${EndPoints.getPod}?userId=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        getPodsModel = getPodsModelFromJson(responseBody);
        audioData.value = getPodsModel.data ?? [];

        for(int i = 0;i<audioData.length;i++){
          audioData[i].download = false;
        }
        for(int i = 0;i<audioData.length;i++){
          await _audioPlayer.setUrl(audioData[i].audioFile!);
          final duration = await _audioPlayer.load();
          audioListDuration.add(duration);
        }

        update(['update']);
        String? audioDataJson = PrefService.getString(PrefKey.podsSave);

        if (audioDataJson.isNotEmpty) {
          List<AudioData> audioDataSave = [];
          List<dynamic> decodedData = jsonDecode(audioDataJson);
          audioDataSave = decodedData.map((item) => AudioData.fromJson(item)).toList();

          if (audioDataSave.isNotEmpty) {
            for (int i = 0; i < audioDataSave.length; i++) {
              audioData.firstWhere((element) => element.id == audioDataSave[i].id).download = true;
            }
          }
        }

        update(['update']);
        loader.value = false;

        debugPrint("save pods read method$audioData");
        debugPrint("filter Data $audioData");
      } else {
        debugPrint(response.reasonPhrase);
        update(['update']);
      }
    } catch (e) {
      loader.value = false;
      debugPrint(e.toString());
    }
    update(['update']);
    update();
  }

  Future<void> getRate() async {
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://transformyourmind-server.onrender.com/api/v1/rating-pod?lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }

    update(['update']);
  }



  Future<void> getDownloadedList() async {
    String? audioDataJson = PrefService.getString(PrefKey.podsSave);
    List<AudioData> audioDataSave = [];

    if (audioDataJson.isNotEmpty) {
      List<dynamic> decodedData = jsonDecode(audioDataJson);
      audioDataSave = decodedData.map((item) => AudioData.fromJson(item)).toList();
    }

    if (audioDataSave.isNotEmpty) {
      audioDataDownloaded.value = audioDataSave;
      for(int i = 0;i<audioDataDownloaded.length;i++){
        await _audioPlayer.setUrl(audioDataDownloaded[i].audioFile!);
        final duration = await _audioPlayer.load();
        audioListDurationD.add(duration);
      }
    }
  }


  Future<void> removeData(int index) async {
    audioDataDownloaded.removeAt(index);

    List<Map<String, dynamic>> audioDataJson = audioDataDownloaded.map((item) => item.toJson()).toList();
    await PrefService.setValue(PrefKey.podsSave, jsonEncode(audioDataJson));

    getDownloadedList();
  }

  Future<void> setDownloadView({
    required BuildContext? context,
    required String? url,
    required int? index,
    required String? fileName
  }) async {
    String? downloadPath = "";
    loaderD.value = true;
    downloadPath = await downloadFile(url: url!, fileName: fileName!);
    audioData[index!].downloadedPath = downloadPath;
    audioData[index].download = true;
    loaderD.value = false;

    List<AudioData> audioDataSave = [];

    String? audioDataJson = PrefService.getString(PrefKey.podsSave);
    if (audioDataJson.isNotEmpty) {
      List<dynamic> decodedData = jsonDecode(audioDataJson);
      audioDataSave = decodedData.map((item) => AudioData.fromJson(item)).toList();
    }

    audioDataSave.add(audioData[index]);

    final data = List.generate(audioDataSave.length, (index) => audioDataSave[index].toJson(),);

    await PrefService.setValue(PrefKey.podsSave, jsonEncode(data));

    showSnackBarSuccess(context!, "podsDownloaded".tr);
    update(["update"]);
  }



    Future<String> downloadFile({
      required String url,
      required String fileName,
    }) async {
      try {
        final Directory directory = await getApplicationDocumentsDirectory();

        final String filePath = '${directory.path}/$fileName';

        if (!(await Directory(directory.path).exists())) {
          await Directory(directory.path).create(recursive: true);
        }
        final File file = File(filePath);
        final http.Response response = await http.get(Uri.parse(url));
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      } catch (e) {
        debugPrint(e.toString());
        rethrow;
      }
    }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';
import 'package:vibration/vibration.dart';

import '../../../core/utils/prefKeys.dart';

class AddAffirmationPage extends StatefulWidget {
  final bool isFromMyAffirmation;
  final bool? isEdit;
  final bool? isSaved, record;
  final int? index;
  final String? title, des,id;

  const AddAffirmationPage(
      {required this.isFromMyAffirmation,
      this.isSaved,
      this.title,
      this.des,
      this.isEdit,
      this.index,
      this.id,
      this.record = false,
      super.key});

  @override
  State<AddAffirmationPage> createState() => _AddAffirmationPageState();
}

class _AddAffirmationPageState extends State<AddAffirmationPage>
    with SingleTickerProviderStateMixin {
  ValueNotifier<int> currentLength = ValueNotifier(0);

  final TextEditingController descController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  String recordedText   = "";

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  String? urlImage;
  File? selectedImage;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loader = false;
  bool recordFile = false;

  @override
  void initState() {
    _requestMicrophonePermission();
    _speech = stt.SpeechToText();


    if (widget.des != null) {
      setState(() {
        descController.text = widget.des.toString();
        _lastText = widget.des.toString();
      });
    }

    audioPlayerVoices.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {

        await audioPlayerVoices.pause();
        setState(() {
         play = false;
        });
        await audioPlayerVoices.seek(Duration.zero, index: 0);

        print("#### Done #####");

      }


    });

    super.initState();
  }

  String? _recordFilePath;
  bool _isRecording = false;
  final record = AudioRecorder();

  Future<void> _startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}';
      _recordFilePath = '${directory.path}/$fileName.aac';

      await record.start(const RecordConfig(), path: _recordFilePath!);
      setState(() => _isRecording = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for recording.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      _stopListening();

      await record.stop();
      setState(() => _isRecording = false);

      debugPrint('Recording saved to: $_recordFilePath');
    }
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      // Microphone permission granted
      debugPrint('Microphone permission granted');
      // Proceed with recording
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Handle permanently denied case (open app settings)
      openAppSettings();
    } else {
      // Handle other permission status (denied, etc.)
      debugPrint('Microphone permission denied');
    }
  }


  addAffirmation() async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };

    var request = http.MultipartRequest('POST', Uri.parse(EndPoints.addAffirmation));
    request.fields.addAll({
      'created_by':PrefService.getString(PrefKey.userId),
      'description': descController.text.trim(),
      'lang': PrefService.getString(PrefKey.language).isEmpty
          ? "english"
          : PrefService.getString(PrefKey.language) != "en-US"
              ? "german"
              : "english"
    });


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      loader = false;
      var d = (await response.stream.bytesToString());
      //showSnackBarSuccess(context, "successfullyAffirmation".tr);
      setState(() {});
      if(_recordFilePath != null && _recordFilePath !=''){
       await  updateAffirmationRecord(
          id: jsonDecode(d)['affirmation']['_id'] ?? '',
          description: descController.text.trim(),
        );
      }
      else {
        Get.back();
      }
    }
    else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });

  }
  CommonModel commonModel = CommonModel();
  updateAffirmation() async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.updateAffirmation}${widget.id}'));
    request.fields.addAll({
      "description": descController.text,
      "created_by": PrefService.getString(PrefKey.userId),
      "isDefault":_recordFilePath != null && _recordFilePath !=''?true.toString():false.toString(),
      'lang': PrefService.getString(PrefKey.language).isEmpty
          ? "english"
          : PrefService.getString(PrefKey.language) != "en-US"
              ? "german"
              : "english"
    });
    if(_recordFilePath != null && _recordFilePath !=''){
      request.files.add(await http.MultipartFile.fromPath('audioFile',_recordFilePath! ));
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      // showSnackBarSuccess(context, "affirmationSuccessfully".tr);
      setState(() {});
      Get.back();
    }
    else {
              final responseBody = await response.stream.bytesToString();
    commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message.toString());
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }

  }
  updateAffirmationRecord({required String id,required String description}) async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.updateAffirmation}$id'));
    request.fields.addAll({
      "description":description,
      "created_by": PrefService.getString(PrefKey.userId),
      "isDefault":_recordFilePath != null && _recordFilePath !=''?true.toString():false.toString(),
      'lang': PrefService.getString(PrefKey.language).isEmpty
          ? "english"
          : PrefService.getString(PrefKey.language) != "en-US"
              ? "german"
              : "english"
    });
    if(_recordFilePath != null && _recordFilePath !=''){
      request.files.add(await http.MultipartFile.fromPath('audioFile',_recordFilePath! ));
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      // showSnackBarSuccess(context, "affirmationSuccessfully".tr);
      setState(() {});
      Get.back();
    }
    else {
              final responseBody = await response.stream.bytesToString();
    commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message.toString());
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }

  }

  //________________________________ speech to text _________________
  final AudioPlayer audioPlayerVoices = AudioPlayer();

  bool _isPressed = false;
  bool play = false;
  bool _isListening = false;
  stt.SpeechToText? _speech;

  void _onLongPressEnd() {
    _stopListening();
    setState(() {

    });


    _speech!.stop();
  }
  String _lastText = "";

  void _startListening() {
    _speech!.listen(
      onResult: (result) {
        setState(() {
          descController.text = "$_lastText ${result.recognizedWords}";
        });
      },
      onSoundLevelChange: (level) {},

    );
    setState(() {
      _isListening = true;
    });
  }
  void _stopListening() {
    _speech!.stop();
    setState(() {
      _isListening = false;
      _lastText = descController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeController.isDarkMode.value
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(
        title: widget.isEdit! ? "editAffirmation".tr : widget.isFromMyAffirmation && (widget.record ?? false)? "Record affirmation":"addAffirmation".tr,
        action: !(widget.isFromMyAffirmation)
            ? Row(children: [
                GestureDetector(onTap: () {}, child: Text("skip".tr)),
                Dimens.d20.spaceWidth,
              ])
            : const SizedBox.shrink(),
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: Dimens.d100),
                child: SvgPicture.asset(themeController.isDarkMode.isTrue
                    ? ImageConstant.profile1Dark
                    : ImageConstant.profile1),
              )),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.d120),
                child: SvgPicture.asset(themeController.isDarkMode.isTrue
                    ? ImageConstant.profile2Dark
                    : ImageConstant.profile2),
              )),
          LayoutBuilder(
            builder: (context, constraints) {
              return Form(
                key: _formKey,
                child:
                widget.record!
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    (widget.record ?? false)?Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(widget.des ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 12,
                        textAlign: TextAlign.center,style:  Style.nunitoSemiBold(
                          fontSize: Dimens.d20,
                          color: themeController.isDarkMode.value
                              ? ColorConstant.white
                              : ColorConstant.black),),
                    ):const SizedBox(),

                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [


                            GestureDetector(
                              onTap: () {
                                if(recordFile) {
                                  setState(() {
                                    _stopRecording();

                                    recordFile = false;
                                  });
                                }
                                else
                                  {
                                    setState(() {
                                      _startRecording();
                                      recordFile = true;
                                    });
                                  }
                              },
                              child: Container(
                                height: 68,
                                width: 68,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorConstant.themeColor
                                ),
                                alignment: Alignment.center,
                                child: recordFile ?
                                const Icon(Icons.stop_circle_outlined, color: Colors.redAccent,size: 35,):
                                const Icon(Icons.mic_rounded,color: Colors.white,size: 35,),
                              ),
                            ),

                            Dimens.d10.spaceHeight,
                            Text(recordFile ?"Stop".tr:"Record".tr,style: Style.nunRegular(
                                fontSize: Dimens.d14,

                                color: ColorConstant.black),),
                          ],
                        ),
                        _recordFilePath!=null &&!recordFile?const SizedBox(width: 50,):const SizedBox(),
                        _recordFilePath!=null && !recordFile? Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (audioPlayerVoices.playing) {
                                  play = false;

                                  audioPlayerVoices.pause();
                                } else {



                                  await audioPlayerVoices.setFilePath(_recordFilePath!);
                                  audioPlayerVoices.play();
                                  play = true;

                                }

                                setState(() {

                                });
                              },
                              child: Container(
                                height: 68,
                                width: 68,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: ColorConstant.themeColor
                                ),
                                alignment: Alignment.center,
                                child:  Icon(play?Icons.pause:Icons.play_arrow,color: Colors.white,size: 35,),
                              ),
                            ),

                            Dimens.d10.spaceHeight,
                            Text("Test recording".tr,style: Style.nunRegular(
                                fontSize: Dimens.d14,
                                color: ColorConstant.black),),
                          ],
                        ):const SizedBox(),
                      ],
                    ),
                    Dimens.d50.spaceHeight,
                    _recordFilePath!=null?Row(
                      children: [
                        !widget.isEdit!
                            ? const SizedBox()
                            : Expanded(
                          child: CommonElevatedButton(
                            title: "cancel".tr,
                            outLined: true,
                            textStyle: Style.nunRegular(
                                color: themeController
                                    .isDarkMode.isTrue
                                    ? Colors.white
                                    : ColorConstant.black),
                            onTap: () {
                              setState(() {});
                              Get.back();
                            },
                          ),
                        ),
                        Dimens.d20.spaceWidth,
                        _recordFilePath!=null && !recordFile?  Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: CommonElevatedButton(
                              textStyle: Style.nunRegular(
                                  fontSize: widget.isEdit!
                                      ? Dimens.d14
                                      : Dimens.d20,
                                  color: ColorConstant.white),
                              title: widget.isEdit!
                                  ? "update".tr
                                  : "save".tr,
                              onTap: () async {
                                titleFocus.unfocus();
                                descFocus.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  if (widget.isEdit!) {
                                    if (await isConnected()) {
                                      updateAffirmation();
                                    } else {
                                      showSnackBarError(
                                          context, "noInternet".tr);
                                    }
                                  } else {
                                    if (await isConnected()) {
                                      PrefService.setValue(
                                          PrefKey
                                              .firstTimeUserAffirmation,
                                          true);

                                      if(widget.isFromMyAffirmation)
                                        {
                                          updateAffirmation();
                                        }
                                      else
                                        {
                                      addAffirmation();

                                        }
                                    } else {
                                      showSnackBarError(
                                          context, "noInternet".tr);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ):const SizedBox(),
                      ],
                    ):const SizedBox(),

                  ],
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    !widget.record!
                        ? Expanded(
                            child: CustomScrollViewWidget(
                        child: LayoutContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Dimens.d20.spaceHeight,
                                    Stack(alignment: Alignment.topRight,
                                      children: [
                                        CommonTextField(addSuffix: true,
                                          hintText: "typeYourDescription".tr,
                                          labelText: "description".tr,
                                          controller: descController,
                                          hintStyle: const TextStyle(fontSize: 14),
                                          textStyle: const TextStyle(fontSize: 14),
                                          focusNode: descFocus,
                                          transform: Matrix4.translationValues(
                                              0, -108.h, 0),
                                          prefixLottieIcon:
                                              ImageConstant.lottieDescription,
                                          maxLines: 15,
                                          maxLength: 2000,
                                          validator: (value) {
                                            if (value!.trim().isEmpty) {
                                              return "pleaseEnterDescription".tr;
                                            }else if (value.length > 2000) {
                                              return "youCantMoreThan".tr;
                                            }
                                            return null;
                                            },
                                          onChanged: (value) => currentLength
                                              .value = descController.text.length,
                                        ),
                                      /*  Padding(
                                          padding: const EdgeInsets.only(top: 45,right: 20),
                                          child: GestureDetector(
                                              onLongPressStart: (details) async {
                                                Vibration.vibrate(
                                                  pattern: [80, 80, 0, 0, 0, 0, 0, 0],
                                                  intensities: [
                                                    20,
                                                    20,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0
                                                  ],
                                                );
                                                setState(() {
                                                  _isPressed = true;
                                                });


                                                if (!_isListening) {
                                                  bool available =
                                                  await _speech!.initialize(
                                                    onStatus: (val) {
                                                      debugPrint(
                                                          "Status for speech recording $val");
                                                      if (val == "done") {
                                                        _isPressed = false;
                                                        _isListening = false;
                                                      } else if (val ==
                                                          'notListening') {
                                                        _isPressed = false;
                                                        _isListening = false;
                                                      }
                                                    },
                                                    onError: (val) {
                                                      debugPrint(
                                                          "Status for speech recording error $val");

                                                      if (val.errorMsg ==
                                                          "error_no_match") {
                                                        _onLongPressEnd();
                                                      }
                                                    },
                                                  );
                                                  if (available) {
                                                    _isListening = true;
                                                    _startListening();
                                                  } else {
                                                    _isPressed = false;
                                                    _isListening = false;
                                                  }
                                                }
                                                setState(() {

                                                });
                                              },
                                              onLongPressEnd: (details) {
                                                _onLongPressEnd();
                                                setState(() {


                                                });
                                                Vibration.vibrate(
                                                  pattern: [80, 80, 0, 0, 0, 0, 0, 0],
                                                  intensities: [
                                                    20,
                                                    20,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                    0
                                                  ],
                                                );

                                              },
                                              child: _isListening
                                                  ? Lottie.asset(
                                                ImageConstant.micAnimation,
                                                height: Dimens.d50,
                                                width: Dimens.d50,
                                                fit: BoxFit.fill,
                                                repeat: true,
                                              )
                                                  : SvgPicture.asset(
                                                  ImageConstant.mic)),
                                        ),*/
                                      ],
                                    ),
                              Dimens.d20.spaceHeight,

                              Row(

                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [


                                      GestureDetector(
                                        onTap: () {
                                          if(recordFile) {
                                            setState(() {
                                              _stopRecording();

                                              recordFile = false;
                                            });
                                          }
                                          else
                                          {
                                            setState(() {
                                              _startRecording();
                                              recordFile = true;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 68,
                                          width: 68,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: ColorConstant.themeColor
                                          ),
                                          alignment: Alignment.center,
                                          child: recordFile ?
                                          const Icon(Icons.stop_circle_outlined, color: Colors.redAccent,size: 35,):
                                          const Icon(Icons.mic_rounded,color: Colors.white,size: 35,),
                                        ),
                                      ),

                                      Dimens.d10.spaceHeight,
                                      Text(recordFile ?"Stop".tr:"Record".tr,style: Style.nunRegular(
                                          fontSize: Dimens.d14,

                                          color: ColorConstant.black),),
                                    ],
                                  ),
                                  _recordFilePath!=null &&!recordFile?const SizedBox(width: 50,):const SizedBox(),
                                  _recordFilePath!=null && !recordFile? Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (audioPlayerVoices.playing) {
                                            play = false;

                                            audioPlayerVoices.pause();
                                          } else {



                                            await audioPlayerVoices.setFilePath(_recordFilePath!);
                                            audioPlayerVoices.play();
                                            play = true;

                                          }

                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          height: 68,
                                          width: 68,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: ColorConstant.themeColor
                                          ),
                                          alignment: Alignment.center,
                                          child:  Icon(play?Icons.pause:Icons.play_arrow,color: Colors.white,size: 35,),
                                        ),
                                      ),

                                      Dimens.d10.spaceHeight,
                                      Text("Test recording".tr,style: Style.nunRegular(
                                          fontSize: Dimens.d14,
                                          color: ColorConstant.black),),
                                    ],
                                  ):const SizedBox(),
                                ],
                              ),
                              Dimens.d30.h.spaceHeight,
                              Row(
                                children: [
                                  !widget.isEdit!?const SizedBox():Expanded(
                                    child: CommonElevatedButton(
                                      title: "cancel".tr,
                                      outLined: true,
                                            textStyle: Style.nunRegular(
                                                color: themeController
                                                        .isDarkMode.isTrue
                                                    ? Colors.white
                                                    : ColorConstant.black),
                                            onTap: () {
                                        setState(() {});
                                        Get.back();
                                      },
                                    ),
                                  ),
                                  Dimens.d20.spaceWidth,
                                  Expanded(
                                    child: CommonElevatedButton(
                                      textStyle: Style.nunRegular(
                                          fontSize: widget.isEdit!
                                              ? Dimens.d14
                                              : Dimens.d20,
                                          color: ColorConstant.white),
                                      title: widget.isEdit!
                                          ? "update".tr
                                          : "save".tr,
                                      onTap: () async {
                                        titleFocus.unfocus();
                                        descFocus.unfocus();
                                        if (_formKey.currentState!
                                            .validate()) {
                                          if (widget.isEdit!) {
                                            if (await isConnected()) {
                                              updateAffirmation();
                                            } else {
                                              showSnackBarError(
                                                  context, "noInternet".tr);
                                            }
                                          } else {
                                            if (await isConnected()) {
                                              PrefService.setValue(
                                                  PrefKey
                                                      .firstTimeUserAffirmation,
                                                  true);

                                              addAffirmation();
                                            } else {
                                              showSnackBarError(
                                                  context, "noInternet".tr);
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                          )
                        : const SizedBox(),
                    Dimens.d10.spaceHeight,
                    Dimens.d50.spaceHeight,
                  ],
                ),
              );
            },
          ),
          loader == true ? commonLoader() : const SizedBox()
        ],
      ),
    );
  }

  int countWords(String text) {
    return text.trim().split(RegExp(r'\s+')).length;
  }

}

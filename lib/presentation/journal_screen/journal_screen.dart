import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/common_gradiant_container.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/model_class/get_user_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_affirmation_focus_page.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../../core/utils/style.dart';
import 'package:http/http.dart' as http;
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  int gratitudeAddedCount = 0;
  final audioPlayerController = Get.find<NowPlayingController>();

  late AnimationController _controller;
  ScrollController scrollController = ScrollController();
  bool _isScrollingOrNot = false;
  @override
  void initState() {
    super.initState();
    getStatusBar();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  getStatusBar() {

  }
  bool ratingView = false;
  ThemeController themeController = Get.find<ThemeController>();
  List<JournalData> journalList = [
    JournalData(
      img: ImageConstant.gratitudeJournal,
      title: "gratitudeJournal".tr,
      lottie: ImageConstant.gratitudeJournal,
      route: AppRoutes.myGratitudePage,
    ),
    JournalData(
      img: ImageConstant.affirmation,

      title: "affirmation".tr,
      lottie: ImageConstant.affirmation,
      route: AppRoutes.myAffirmationPage,
    ),

    JournalData(
      img: ImageConstant.motivationalIcon,

      title: "motivational".tr,
      lottie: ImageConstant.motivationalIcon,
      route: AppRoutes.motivationScreen,
    ),
    JournalData(
      img: ImageConstant.positiveMoment,

      title: "positiveMoments".tr,
      lottie: ImageConstant.positiveMoment,
      route: AppRoutes.positiveScreen,
    ),
    JournalData(
      img: ImageConstant.selfHypnotic,
      title: "selfHypnotic".tr,
      lottie: ImageConstant.selfHypnotic,
      route: AppRoutes.selfHypnotic,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  GetUserModel getUserModel =GetUserModel();
  getUSer() async {

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
        await PrefService.setValue(
            PrefKey.userImage, getUserModel.data?.userProfile ?? "");
        await PrefService.setValue(
            PrefKey.isFreeUser, getUserModel.data?.isFreeVersion ?? false);
        await PrefService.setValue(
            PrefKey.isSubscribed, getUserModel.data?.isSubscribed ?? false);
        await PrefService.setValue(
            PrefKey.subId, getUserModel.data?.subscriptionId ?? '');
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {

      debugPrint(e.toString());
    }

  }
  int initialRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
        themeController.isDarkMode.isTrue?
        ColorConstant.darkBackground:
        ColorConstant.white,
        appBar: CustomAppBar(
          title: "selfDevelopment".tr,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Dimens.d20.spaceHeight,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.d20),
                    child: Text(
                      textAlign: TextAlign.center,
                      "useSelfDevelopment".tr,
                      style: Style.nunRegular(fontSize: 14,color:themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF: ColorConstant.color747474),
                    ),
                  ),
                  Dimens.d60.spaceHeight,
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is UserScrollNotification) {
                        setState(() {
                          _isScrollingOrNot = true;
                          if (scrollController.offset <=
                                  scrollController.position.minScrollExtent &&
                              !scrollController.position.outOfRange) {
                            setState(() {
                              _isScrollingOrNot = false;
                            });
                          }
                        });
                      }

                      return false;
                    },
                    child: Expanded(
                      child: Stack(
                        children: [
                          ValueListenableBuilder(
                              valueListenable: isTutorialVideoVisible,
                              builder: (BuildContext context, value,
                                  Widget? child) {
                                return Column(
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        controller: scrollController,
                                        itemCount: journalList.length,
                                        padding: EdgeInsets.only(
                                          bottom: Dimens.d100,
                                          top: isTutorialVideoVisible.value
                                              ? Dimens.d20
                                              : 0,
                                          left: Dimens.d5,
                                          right: Dimens.d5,
                                        ),
                                        physics:
                                            const ClampingScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: Dimens.d2.toInt(),
                                          crossAxisSpacing: Dimens.d30,
                                          mainAxisSpacing: Dimens.d10,

                                        ),
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return GestureDetector(
                                            onTap: () async {

                                              if( journalList[index].route == '/myAffirmationPage')
                                                {
                                                  await getUSer();
                                                  if ((getUserModel.data?.affirmationCreated ?? false) ==
                                                      false) {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return  SelectYourAffirmationFocusPage(
                                                                setting: true,
                                                                isFromMe: false);
                                                          },
                                                        )).then(
                                                          (value) async {

                                                        setState(() {});
                                                      },
                                                    );
                                                  }
                                                  else {
                                                    if (PrefService.getBool(
                                                        PrefKey.isSubscribed) ==
                                                        false) {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return SubscriptionScreen(
                                                                skip: false,
                                                              );
                                                            },
                                                          )).then(
                                                            (value) async {
                                                          MotivationalController moti = Get
                                                              .find<
                                                              MotivationalController>();
                                                          await moti.audioPlayer
                                                              .dispose();
                                                          await moti.audioPlayer
                                                              .pause();
                                                          setState(() {
                                                            getStatusBar();
                                                          });
                                                        },
                                                      );
                                                    }
                                                    else {
                                                      Navigator.pushNamed(
                                                        context,
                                                        journalList[index]
                                                            .route ??
                                                            "",
                                                      ).then(
                                                            (value) async {
                                                          MotivationalController moti = Get
                                                              .find<
                                                              MotivationalController>();
                                                          await moti.audioPlayer
                                                              .dispose();
                                                          await moti.audioPlayer
                                                              .pause();
                                                          setState(() {
                                                            getStatusBar();
                                                          });
                                                        },
                                                      );
                                                    }
                                                  }
                                                }

                                              else if(journalList[index].route == '/myGratitudePage')
                                                {
                                                  if (PrefService.getBool(
                                                      PrefKey.isSubscribed) ==
                                                      false) {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return SubscriptionScreen(
                                                              skip: false,
                                                            );
                                                          },
                                                        )).then(
                                                          (value) async {
                                                        MotivationalController moti = Get
                                                            .find<
                                                            MotivationalController>();
                                                        await moti.audioPlayer
                                                            .dispose();
                                                        await moti.audioPlayer
                                                            .pause();
                                                        setState(() {
                                                          getStatusBar();
                                                        });
                                                      },
                                                    );
                                                  }
                                                  else {
                                                    Navigator.pushNamed(
                                                      context,
                                                      journalList[index]
                                                          .route ??
                                                          "",
                                                    ).then(
                                                          (value) async {
                                                        MotivationalController moti = Get
                                                            .find<
                                                            MotivationalController>();
                                                        await moti.audioPlayer
                                                            .dispose();
                                                        await moti.audioPlayer
                                                            .pause();
                                                        setState(() {
                                                          getStatusBar();
                                                        });
                                                      },
                                                    );
                                                  }
                                                }
                                              else if(journalList[index].route == '/positiveScreen')
                                                {
                                                  if (PrefService.getBool(
                                                      PrefKey.isSubscribed) ==
                                                      false) {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return SubscriptionScreen(
                                                              skip: false,
                                                            );
                                                          },
                                                        )).then(
                                                          (value) async {
                                                        MotivationalController moti = Get
                                                            .find<
                                                            MotivationalController>();
                                                        await moti.audioPlayer
                                                            .dispose();
                                                        await moti.audioPlayer
                                                            .pause();
                                                        setState(() {
                                                          getStatusBar();
                                                        });
                                                      },
                                                    );
                                                  }
                                                  else {
                                                    Navigator.pushNamed(
                                                      context,
                                                      journalList[index]
                                                          .route ??
                                                          "",
                                                    ).then(
                                                          (value) async {
                                                        MotivationalController moti = Get
                                                            .find<
                                                            MotivationalController>();
                                                        await moti.audioPlayer
                                                            .dispose();
                                                        await moti.audioPlayer
                                                            .pause();
                                                        setState(() {
                                                          getStatusBar();
                                                        });
                                                      },
                                                    );
                                                  }
                                                }
                                              else
                                                {
                                                  Navigator.pushNamed(
                                                    context,
                                                    journalList[index].route ??
                                                        "",
                                                  ).then(
                                                        (value) async {
                                                      MotivationalController moti = Get.find<MotivationalController>();
                                                      await moti.audioPlayer.dispose();
                                                      await moti.audioPlayer.pause();
                                                      setState(() {
                                                        getStatusBar();
                                                      });
                                                    },
                                                  );
                                                }
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 128,
                                                  width: 153,
                                                  padding:
                                                      Dimens.d12.paddingAll,
                                                  alignment:
                                                      Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.colorF8F8FA,
                                                    borderRadius: Dimens
                                                        .d20.radiusAll,
                                                  ),
                                                  child: Column(children: [
                                                    Dimens.d8.spaceHeight,

                                                    SvgPicture.asset( journalList[index].img!,height: Dimens.d54,width: Dimens.d54,),
                                                    Dimens.d15.spaceHeight,
                                                    Text(
                                                      journalList[index].title,maxLines: 1,overflow: TextOverflow.ellipsis,
                                                      style: Style
                                                          .nunRegular(),
                                                    )
                                                  ],)
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          (_isScrollingOrNot)
                              ? commonGradiantContainer(
                                  color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white,
                              h: 30)
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!audioPlayerController.isVisible.value) {
                return const SizedBox.shrink();
              }

              final currentPosition =
                  audioPlayerController.positionStream.value ??
                      Duration.zero;
              final duration =
                  audioPlayerController.durationStream.value ??
                      Duration.zero;
              final isPlaying = audioPlayerController.isPlaying.value;

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          Dimens.d24,
                        ),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return NowPlayingScreen(
                        audioData: audioDataStore!,
                      );
                    },
                  );
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 72,
                    width: Get.width,
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 8, right: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 50),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            ColorConstant.colorB9CCD0,
                            ColorConstant.color86A6AE,
                            ColorConstant.color86A6AE,
                          ], // Your gradient colors
                          begin: Alignment.bottomLeft,
                          end: Alignment.bottomRight,
                        ),
                        color: ColorConstant.themeColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CommonLoadImage(
                                borderRadius: 6.0,
                                url: audioDataStore!.image!,
                                width: 47,
                                height: 47),
                            Dimens.d12.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  if (isPlaying) {
                                    await audioPlayerController
                                        .pause();
                                  } else {
                                    await audioPlayerController
                                        .play();
                                  }
                                },
                                child: SvgPicture.asset(
                                  isPlaying
                                      ? ImageConstant.pause
                                      : ImageConstant.play,
                                  height: 17,
                                  width: 17,
                                )),
                            Dimens.d10.spaceWidth,
                            Expanded(
                              child: Text(
                                audioDataStore!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Style.nunRegular(
                                    fontSize: 12,
                                    color: ColorConstant.white),
                              ),
                            ),
                            Dimens.d10.spaceWidth,
                            GestureDetector(
                                onTap: () async {
                                  await audioPlayerController.reset();
                                },
                                child: SvgPicture.asset(
                                  ImageConstant.closePlayer,
                                  color: ColorConstant.white,
                                  height: 24,
                                  width: 24,
                                )),
                            Dimens.d10.spaceWidth,
                          ],
                        ),
                        Dimens.d8.spaceHeight,
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor:
                            ColorConstant.white.withOpacity(0.2),
                            inactiveTrackColor:
                            ColorConstant.color6E949D,
                            trackHeight: 1.5,
                            thumbColor: ColorConstant.transparent,
                            thumbShape: SliderComponentShape.noThumb,
                            overlayColor: ColorConstant.backGround
                                .withAlpha(32),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius:
                                16.0), // Customize the overlay shape and size
                          ),
                          child: SizedBox(
                            height: 2,
                            child: Slider(
                              thumbColor: Colors.transparent,
                              activeColor: ColorConstant.backGround,
                              value: currentPosition.inMilliseconds
                                  .toDouble(),
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                audioPlayerController
                                    .seekForMeditationAudio(
                                    position: Duration(
                                        milliseconds:
                                        value.toInt()));
                              },
                            ),
                          ),
                        ),
                        Dimens.d5.spaceHeight,
                      ],
                    ),
                  ),
                ),
              );
            }),

          ],
        ));
  }
}

class JournalData {
  final String lottie;
  final String title;
  final String? route;
  final String? img;

  JournalData({
    this.route,
    required this.title,
    required this.lottie,
    required this.img,
  });
}

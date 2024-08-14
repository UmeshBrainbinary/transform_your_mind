import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:transform_your_mind/core/common_widget/common_text_button.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/model_class/gratitude_model.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/affirmation_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/home_controller.dart';
import 'package:transform_your_mind/presentation/home_screen/home_message_page.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/home_widget.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feeling_today_screen.dart';
import 'package:transform_your_mind/presentation/how_feeling_today/how_feelings_evening.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivation_screen.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_screen.dart';
import 'package:transform_your_mind/presentation/start_practcing_screen/start_pratice_controller.dart';
import 'package:transform_your_mind/presentation/start_practcing_screen/start_pratice_screen.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_affirmation_controller.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_pratice_affirmation.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/presentation/transform_pods_screen/transform_pods_screen.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _lottieBgController;
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  PositiveController positiveController = Get.put(PositiveController());
  DateTime now = DateTime.now();
  HomeController g = Get.put(HomeController());
  ThemeController themeController = Get.find<ThemeController>();
  GratitudeModel gratitudeModel = GratitudeModel();
  AffirmationController affirmationController = Get.put(AffirmationController());
  String currentLanguage = PrefService.getString(PrefKey.language);
  MotivationalController motivationalController = Get.put(MotivationalController());
  @override
  void initState() {
    _setGreetingBasedOnTime();
    _lottieBgController = AnimationController(vsync: this);
    scrollController.addListener(() {
      double showOffset = 10.0;
      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });

    checkInternet();

    setState(() {});
    super.initState();
  }



  getGratitude() async {

    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}get-gratitude?created_by=${PrefService.getString(PrefKey.userId)}&date=${DateFormat('dd/MM/yyyy').format(now)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      gratitudeModel = GratitudeModel();
      final responseBody = await response.stream.bytesToString();
      gratitudeModel = gratitudeModelFromJson(responseBody);

      debugPrint("gratitude Model ${gratitudeModel.data}");


    } else {

      debugPrint(response.reasonPhrase);
    }
  }

  checkInternet() async {


    if (await isConnected()) {
      getData();
    } else {
      showSnackBarError(context, "noInternet".tr);
    }

  }

  getData() async {
    await g.getUSer();
    getGratitude();
    g.getMotivationalMessage();
    g.getPodApi();
    g.getSelfHypnoticApi();
    g.getBookMarkedList();
    g.getTodayAffirmation();
    g.getRecentlyList();
    g.getPersonalData();
    positiveController.getPositiveMoments();
    if(motivationalController.isPlaying.isTrue){
      await motivationalController.pause();
    }
    setState(() {});
  }


  String greeting = "";

  void _setGreetingBasedOnTime() {
    greeting = _getGreetingBasedOnTime();
    greeting.toUpperCase().camelCase;

    setState(() {});
  }

  String _getGreetingBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'goodMorning';
    } else if (hour >= 12 && hour < 17) {
      return 'goodAfternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'goodEvening';
    } else {
      return 'goodNight';
    }
  }


  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _lottieBgController.dispose();
    super.dispose();
  }

  final audioPlayerController = Get.put(NowPlayingController());

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }


  Future<void> _refresh() async {
    checkInternet();
  }
  String _formatDuration(Duration? duration) {
    if (duration == null) return "00:00";
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
  @override
  Widget build(BuildContext context) {
    if (themeController.isDarkMode.isTrue) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
    return Stack(
      children: [
        Scaffold(
            backgroundColor: themeController.isDarkMode.isTrue
                ? ColorConstant.darkBackground
                : ColorConstant.white,
            body: RefreshIndicator(
              onRefresh: _refresh,
              child: GetBuilder<HomeController>(
                id: "home",
                builder: (controller) {
                  return Stack(
                    children: [
                      CustomScrollViewWidget(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Dimens.d50.spaceHeight,

                            //__________________________ top view ____________________
                            topView(controller
                                    .getUserModel.data?.motivationalMessage ??
                                "Believe in yourself, even when doubt creeps in. Today's progress is a step towards your dreams."),
                            Dimens.d25.spaceHeight,
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.d20),
                                child: Text(
                                    "${greeting.tr}, ${capitalizeFirstLetter(PrefService.getString(PrefKey.name).toString())}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: themeController.isDarkMode.isTrue
                                            ? ColorConstant.white
                                            : ColorConstant.black,
                                        fontFamily: FontFamily.nunitoBold,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24,
                                        letterSpacing: 1)),
                              ),
                            ),

                            Dimens.d30.spaceHeight,

                            yourGratitude(),
                            Dimens.d30.spaceHeight,
                            yourAffirmation(),
                            Dimens.d30.spaceHeight,

                            //______________________________ yourDaily Recommendations _______________________

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d20),
                              child: Text(
                                "meditations".tr,
                                textAlign: TextAlign.center,
                                style: Style.nunitoBold(fontSize: Dimens.d22),
                              ),
                            ),
                            Dimens.d20.spaceHeight,
                            recentlyView(),
                            positiveController.positiveMomentList.isEmpty?const SizedBox():Dimens.d40.spaceHeight,
                            positiveController.positiveMomentList.isEmpty?const SizedBox():Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d20),
                              child: Row(children: [
                                Text(
                                  "positiveMomentH".tr,
                                  textAlign: TextAlign.center,
                                  style: Style.nunitoBold(fontSize: Dimens.d22),
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const PositiveScreen();
                                        },
                                      )).then(
                                        (value) {
                                          if (themeController.isDarkMode.isTrue) {
                                            SystemChrome.setSystemUIOverlayStyle(
                                                const SystemUiOverlayStyle(
                                                  statusBarBrightness: Brightness.dark,
                                                  statusBarIconBrightness: Brightness.light,
                                                ));
                                          } else {
                                            SystemChrome.setSystemUIOverlayStyle(
                                                const SystemUiOverlayStyle(
                                                  statusBarBrightness: Brightness.light,
                                                  statusBarIconBrightness: Brightness.dark,
                                                ));
                                          }
                                          Future.delayed(const Duration(seconds: 1)).then(
                                                (value) {
                                              setState(() {});
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "seeAll".tr,
                                      style: Style.gothamLight(
                                          color: ColorConstant.color5A7681,
                                          fontSize: 12),
                                    )),
                                Dimens.d4.spaceWidth,
                                SvgPicture.asset(ImageConstant.seeAll)

                              ]),
                            ),
                            positiveController.positiveMomentList.isEmpty?const SizedBox():Dimens.d24.spaceHeight,
                            positiveController.positiveMomentList.isEmpty?const SizedBox():SizedBox(
                              height: 156,
                              child: ListView.builder(padding: const EdgeInsets.only(left: 22),
                                itemCount: positiveController.positiveMomentList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return const PositiveScreen();
                                      },
                                    )).then((value) async {
                                     await positiveController.getPositiveMoments();
                                      setState(() {});
                                    },);
                                  },child: PositiveMoment(index: index,));
                                },
                              ),
                            ),


                            Dimens.d30.spaceHeight,
                            //___________________________________________ recommendation _____________________

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d20),
                              child: Text(
                                "yourRecommendations".tr,
                                textAlign: TextAlign.center,
                                style: Style.nunitoBold(
                                  fontSize: Dimens.d22,
                                ),
                              ),
                            ),
                            Dimens.d30.spaceHeight,
                            recommendation(),
                            Dimens.d30.spaceHeight,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d20),
                              child: Text(
                                "quickAccess".tr,
                                textAlign: TextAlign.center,
                                style: Style.nunitoBold(
                                  fontSize: Dimens.d22,
                                ),
                              ),
                            ),
                            Dimens.d30.spaceHeight,
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.d20),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1.5,
                                        crossAxisSpacing: 30,
                                        mainAxisSpacing:
                                            30 // Set the aspect ratio as needed
                                        ),
                                itemCount: g.quickAccessList.length,
                                // Total number of items
                                itemBuilder: (BuildContext context, int index) {
                                  // Generating items for the GridView
                                  return GestureDetector(
                                    onTap: () {
                                      if (g.quickAccessList[index]["title"] ==
                                          "motivationalQ") {
                                        Get.to(() => const MotivationScreen())!
                                            .then((value) async {
                                          MotivationalController moti = Get.find<MotivationalController>();
                                          await moti.audioPlayer.dispose();
                                          await moti.audioPlayer.pause();
                                          setState(() {});
                                        });
                                      } else if (g.quickAccessList[index]
                                              ["title"] ==
                                          "transformAudiosQ") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return const TransformPodsScreen();
                                          },
                                        )).then(
                                          (value) {
                                            setState(() {});
                                          },
                                        );
                                      } else if (g.quickAccessList[index]
                                              ["title"] ==
                                          "gratitudeJournalQ") {
                                        Navigator.pushNamed(context,
                                                AppRoutes.myGratitudePage)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else if (g.quickAccessList[index]
                                              ["title"] ==
                                          "positiveMomentsQ") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return const PositiveScreen();
                                          },
                                        )).then(
                                          (value) {
                                            setState(() {});
                                          },
                                        );
                                      } else if (g.quickAccessList[index]
                                              ["title"] ==
                                          "affirmationeQ") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return const MyAffirmationPage();
                                          },
                                        )).then(
                                          (value) {
                                            setState(() {});
                                          },
                                        );
                                      } else {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return BreathScreen(
                                              skip: false,
                                            );
                                          },
                                        )).then(
                                          (value) {
                                            setState(() {});
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: themeController
                                                  .isDarkMode.value
                                              ? ColorConstant.textfieldFillColor
                                              : const Color(0xffD7E2E4)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            g.quickAccessList[index]["icon"],
                                            height: 30,
                                            width: 30,
                                            color: ColorConstant.color5A7681,
                                          ),
                                          Dimens.d5.spaceHeight,
                                          Text(
                                            "${g.quickAccessList[index]["title"]}"
                                                .tr,
                                            style: Style.montserratSemiBold(
                                                fontSize: 8,
                                                color:
                                                    themeController.isDarkMode.isTrue?ColorConstant.white:ColorConstant.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Dimens.d110.spaceHeight,
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
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: SizedBox(height: 2,
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
                  );
                },
              ),
            )),
        Obx(
          () => g.loader.isTrue ? commonLoader() : const SizedBox(),
        ),
      ],
    );
  }

  Widget customDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.d20),
      color: ColorConstant.themeColor.withOpacity(0.2),
      height: 1,
      width: double.infinity,
    );
  }

  Widget topView(String? motivationalMessage) {
    return GestureDetector(
        onTap: () async {
         //  Get.to(()=>const HowFeelingsEvening());

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return HomeMessagePage(
                  motivationalMessage: motivationalMessage ??
                      "Believe in yourself, even when doubt creeps in. Today's progress is a step towards your dreams.");
              },
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  ImageConstant.gratitudeContainer,
                  height: 150,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "“ ${g.getUserModel.data?.motivationalMessage ?? "“ Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.” "}” ",
                    textAlign: TextAlign.center,maxLines: 4,
                    style: Style.gothamLight(
                        fontSize: 15, color: ColorConstant.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 110,left: 200),
                  child: Text("Christian D. Larson",style: Style.nunRegular(fontSize: 12,color: ColorConstant.black),),
                )

              ],
            ),
          ),
        ));
  }

  Widget recentlyView() {
    return GetBuilder<HomeController>(
      id: "home",
      builder: (controller) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(controller.audioData.length ?? 0, ( index) {
              return GestureDetector(
                  onTap: () {
                    if (!controller.audioData[index].isPaid!) {
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
                            audioData: AudioData(
                              id: controller.audioData[index].id,
                              isPaid: controller.audioData[index].isPaid,
                              image: controller.audioData[index].image,
                              rating: controller.audioData[index].rating,
                              description:
                                  controller.audioData[index].description,
                              name: controller.audioData[index].name,
                              isBookmarked:
                                  controller.audioData[index].isBookmarked,
                              isRated: controller.audioData[index].isRated,
                              category: controller.audioData[index].category,
                              createdAt: controller.audioData[index].createdAt,
                              podsBy: controller.audioData[index].podsBy,
                              expertName:
                                  controller.audioData[index].expertName,
                              audioFile: controller.audioData[index].audioFile,
                              isRecommended:
                                  controller.audioData[index].isRecommended,
                              status: controller.audioData[index].status,
                              createdBy: controller.audioData[index].createdBy,
                              updatedAt: controller.audioData[index].updatedAt,
                              v: controller.audioData[index].v,
                              download: false,
                            ),
                          );
                        },
                      ).then((value) {
                        if (themeController.isDarkMode.isTrue) {
                          SystemChrome.setSystemUIOverlayStyle(
                              const SystemUiOverlayStyle(
                                statusBarBrightness: Brightness.dark,
                                statusBarIconBrightness: Brightness.light,
                              ));
                        } else {
                          SystemChrome.setSystemUIOverlayStyle(
                              const SystemUiOverlayStyle(
                                statusBarBrightness: Brightness.light,
                                statusBarIconBrightness: Brightness.dark,
                              ));
                        }
                        Future.delayed(const Duration(seconds: 1)).then(
                              (value) {
                            setState(() {});
                          },
                        );
                      },);
                    }else{
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SubscriptionScreen(
                            skip: false,
                          );
                        },
                      ));
                    }

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: FeelGood(
                      currentLanguage: currentLanguage,
                      audioTime: controller.audioListDuration.length > index ? _formatDuration( controller.audioListDuration[index]) : '8:00',
                      dataList: controller.audioData[index],
                    ),
                  ));
            }),
          ),
        );
      },
    );
  }
  Widget selfHypnotic() {
    return GetBuilder<HomeController>(
      id: "home",
      builder: (controller) {
        return controller.audioDataSelfHypnotic.isEmpty?   Center(
          child: Text("dataNotFound".tr, style: Style.gothamMedium(
              fontSize: 24, fontWeight: FontWeight.w700),),
        ): SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(controller.audioDataSelfHypnotic.length, ( index) {
              return GestureDetector(
                  onTap: () {
                    if (!controller.audioDataSelfHypnotic[index].isPaid!) {
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
                            audioData: AudioData(
                              id: controller.audioDataSelfHypnotic[index].id,
                              isPaid: controller.audioDataSelfHypnotic[index].isPaid,
                              image: controller.audioDataSelfHypnotic[index].image,
                              rating: controller.audioDataSelfHypnotic[index].rating,
                              description:
                              controller.audioDataSelfHypnotic[index].description,
                              name: controller.audioDataSelfHypnotic[index].name,
                              isBookmarked:
                              controller.audioDataSelfHypnotic[index].isBookmarked,
                              isRated: controller.audioDataSelfHypnotic[index].isRated,
                              category: controller.audioDataSelfHypnotic[index].category,
                              createdAt: controller.audioDataSelfHypnotic[index].createdAt,
                              podsBy: controller.audioDataSelfHypnotic[index].podsBy,
                              expertName:
                              controller.audioDataSelfHypnotic[index].expertName,
                              audioFile: controller.audioDataSelfHypnotic[index].audioFile,
                              isRecommended:
                              controller.audioDataSelfHypnotic[index].isRecommended,
                              status: controller.audioDataSelfHypnotic[index].status,
                              createdBy: controller.audioDataSelfHypnotic[index].createdBy,
                              updatedAt: controller.audioDataSelfHypnotic[index].updatedAt,
                              v: controller.audioDataSelfHypnotic[index].v,
                              download: false,
                            ),
                          );
                        },
                      ).then((value) {
                        if (themeController.isDarkMode.isTrue) {
                          SystemChrome.setSystemUIOverlayStyle(
                              const SystemUiOverlayStyle(
                                statusBarBrightness: Brightness.dark,
                                statusBarIconBrightness: Brightness.light,
                              ));
                        } else {
                          SystemChrome.setSystemUIOverlayStyle(
                              const SystemUiOverlayStyle(
                                statusBarBrightness: Brightness.light,
                                statusBarIconBrightness: Brightness.dark,
                              ));
                        }
                        Future.delayed(const Duration(seconds: 1)).then(
                              (value) async {
                                await g.getSelfHypnoticApi();

                                setState(() {});
                          },
                        );
                      },);
                    }else{
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SubscriptionScreen(
                            skip: false,
                          );
                        },
                      ));
                    }

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: SelfHypnoticScreen(
                      currentLanguage: currentLanguage,
                      audioTime: controller.audioListDurationSelf.length > index ? _formatDuration( controller.audioListDurationSelf[index]) : '8:00',
                      dataList: controller.audioDataSelfHypnotic[index],
                    ),
                  ));
            }),
          ),
        );
      },
    );
  }
  Widget recommendation() {
    return GetBuilder<HomeController>(
      id: "home",
      builder: (controller) {
        return (controller.getPersonalDataModel.data??[]).isEmpty?   Center(
          child: Text("dataNotFound".tr, style: Style.gothamMedium(
              fontSize: 24, fontWeight: FontWeight.w700),),
        ):SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(controller.getPersonalDataModel.data?.length ?? 0, ( index) {
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
                          show: true,
                          audioData: AudioData(
                            id: controller.getPersonalDataModel.data![index].id,
                            isPaid: false,
                            image: controller.getPersonalDataModel.data![index].image,
                            rating: 0,
                            description:
                            controller.getPersonalDataModel.data![index].description,
                            name: "",
                            isBookmarked:false,
                            isRated: false,
                            category: "",
                            createdAt: DateTime.now(),
                            podsBy: false,
                            expertName:"",
                            audioFile: controller.getPersonalDataModel.data![index].audioFile,
                            isRecommended:false,
                            status: false,
                            download: false,
                          ),
                        );
                      },
                    ).then((value) {
                      if (themeController.isDarkMode.isTrue) {
                        SystemChrome.setSystemUIOverlayStyle(
                            const SystemUiOverlayStyle(
                              statusBarBrightness: Brightness.dark,
                              statusBarIconBrightness: Brightness.light,
                            ));
                      } else {
                        SystemChrome.setSystemUIOverlayStyle(
                            const SystemUiOverlayStyle(
                              statusBarBrightness: Brightness.light,
                              statusBarIconBrightness: Brightness.dark,
                            ));
                      }
                      Future.delayed(const Duration(seconds: 1)).then(
                            (value) async {
                          await g.getSelfHypnoticApi();

                          setState(() {});
                        },
                      );
                    },);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: RecommendationScreen(dataList: controller.getPersonalDataModel.data![index],
                      currentLanguage: currentLanguage,
                      audioTime: controller.audioListRecommendations.length > index ? _formatDuration( controller.audioListRecommendations[index]) : '8:00',
                    ),
                  ));
            }),
          ),
        );
      },
    );
  }


  Widget recommendationsView(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
      child: controller.audioData.isEmpty
          ? Center(
              child: Text(
                "noPodsRecommendation".tr,
                style: Style.nunRegular(fontSize: Dimens.d15),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:  controller.audioData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if(controller.audioData[index].isPaid!){
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
                            audioData:controller.audioData[index],
                          );
                        },
                      );

                    }else{
                      Get.toNamed(AppRoutes.subscriptionScreen);
                    }


                  },
                  child: Container(
                    height: Dimens.d70,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: themeController.isDarkMode.value
                    ? ColorConstant.textfieldFillColor
                    : Colors.white,
                    ),
              child: Row(children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CachedNetworkImage(
                            height: 58,
                            width: 75,
                            imageUrl: controller.audioData[index].image ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => PlaceHolderCNI(
                        height: Dimens.d80.h,
                        width: Dimens.d80,
                        borderRadius: 10.0,
                      ),
                      errorWidget: (context, url, error) => PlaceHolderCNI(
                        height: Dimens.d80.h,
                        width: Dimens.d80,
                        isShowLoader: false,
                        borderRadius: 8.0,
                      ),
                    ),
                    controller.audioData[index].isPaid!?const SizedBox():Container(
                      margin: const EdgeInsets.all(6.0),
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: Center(
                          child: Image.asset(
                        ImageConstant.lockHome,
                        height: 5,
                        width: 5,
                      )),
                    )
                  ],
                ),
                Dimens.d25.spaceWidth,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                         Dimens.d12.spaceHeight,
                          SizedBox(
                            width: Dimens.d200,
                            child: Text(
                              controller.audioData[index].name ?? "",
                              maxLines: 1,
                              style: Style.gothamLight(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                    Dimens.d5.spaceHeight,

                    SizedBox(
                      width: Dimens.d200,
                      child: Text(
                        controller.audioData[index].description ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                              style: Style.gothamLight(
                                fontSize: 12,
                              ),
                      ),
                    ),
                    Dimens.d7.spaceHeight,

                  ],
                )
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget yourAffirmation() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: Text(
              "today'sAffirmation".tr,
              textAlign: TextAlign.center,
              style: Style.nunitoBold(fontSize: Dimens.d22),
            ),
          ),
          Dimens.d30.spaceHeight,
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: (g.todayAList ?? []).isEmpty
                ? CommonElevatedButton(
                    height: Dimens.d46,
                    textStyle: Style.nunRegular(
                        fontSize: currentLanguage=="en-US"?Dimens.d17:Dimens.d15, color: ColorConstant.white),
                    title: "empowerMindset".tr,
                    onTap: () {
                     Get.to(const AddAffirmationPage(
                       isFromMyAffirmation: true,
                       isEdit: false,))!.then(
                           (value) async {
                         await g.getTodayAffirmation();
                         setState(() {});
                       },
                     );
                    },
                  )
                : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: g.todayAList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              Get.to(()=> const MyAffirmationPage())!.then((value) async {
                                await g.getTodayAffirmation();
                                setState(() {});
                              },);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: themeController.isDarkMode.isTrue
                                      ? ColorConstant.textfieldFillColor
                                      : ColorConstant.backGround,
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  g.todayAList?[index].description ?? "",
                                  maxLines: 3,
                                  style: Style.nunRegular(),
                                ),


                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                      Dimens.d20.spaceHeight,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  StartPracticeAffirmation(
                                id:  g.todayAList?[0].id ,
                              data: g.todayAList!,);
                            },
                          )).then(
                            (value) {
                              if (themeController.isDarkMode.isTrue) {
                                SystemChrome.setSystemUIOverlayStyle(
                                    const SystemUiOverlayStyle(
                                  statusBarBrightness: Brightness.dark,
                                  statusBarIconBrightness: Brightness.light,
                                ));
                              } else {
                                SystemChrome.setSystemUIOverlayStyle(
                                    const SystemUiOverlayStyle(
                                  statusBarBrightness: Brightness.light,
                                  statusBarIconBrightness: Brightness.dark,
                                ));
                              }
                              Future.delayed(const Duration(seconds: 1)).then(
                                (value) {
                                  StartPracticeAffirmationController startC =
                                  Get.put(StartPracticeAffirmationController());
                                  startC.player.pause();
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          height: Dimens.d46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              color: ColorConstant.themeColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(ImageConstant.playGratitude,
                                  height: 20, width: 20),
                              Dimens.d8.spaceWidth,
                              Text(
                                "startPracticing".tr,
                                style: Style.nunRegular(
                                    fontSize: 16, color: ColorConstant.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget yourGratitude() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: Text(
              "today'sGratitude".tr,
              textAlign: TextAlign.center,
              style: Style.nunitoBold(fontSize: Dimens.d22),
            ),
          ),
          Dimens.d20.spaceHeight,
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 27.0,
            ),
            child: (gratitudeModel.data ?? []).isEmpty
                ? CommonElevatedButton(
                    height: Dimens.d46,
                    title: "whatAreGreatFull".tr,
                    textStyle: Style.nunRegular(
                        fontSize: currentLanguage=="en-US"?Dimens.d17:Dimens.d15, color: ColorConstant.white),
                    onTap: () {
                      Navigator.push(context,   MaterialPageRoute(builder: (context) {
                        return  AddGratitudePage( isFromMyGratitude: true,
                          registerUser: false, categoryListAll: [],
                          previous:false,
                          edit: false,);
                      },)).then((value) async {
                        await getGratitude();
                        setState(() {

                        });
                      },);

                    },
                  )
                : Column(
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: gratitudeModel.data?.length??0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: commonContainer(
                                gratitudeList:  gratitudeModel.data,
                                des: gratitudeModel.data?[index].description??"",
                                date: "${index + 1}",
                                day: DateFormat('EEE').format(gratitudeModel.data![index].createdAt!).toUpperCase()),
                          );
                        },
                      ),
                      Dimens.d16.spaceHeight,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return  StartPracticeScreen(gratitudeList: gratitudeModel.data,);
                            },
                          )).then((value) async {


                            if (themeController.isDarkMode.isTrue) {
                              SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                    statusBarBrightness: Brightness.dark,
                                    statusBarIconBrightness: Brightness.light,
                                  ));
                            } else {
                              SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                    statusBarBrightness: Brightness.light,
                                    statusBarIconBrightness: Brightness.dark,
                                  ));
                            }
                            Future.delayed(const Duration(seconds: 1)).then(
                                  (value) async {
                                    StartPracticeController startC = Get.put(StartPracticeController());
                                    await  startC.pause();
                                setState(() {

                                });
                              },
                            );
                          },);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          height: Dimens.d46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              color: ColorConstant.themeColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(ImageConstant.playGratitude,
                                  height: 20, width: 20),
                              Dimens.d8.spaceWidth,
                              Text(
                                "startPracticing".tr,
                                style: Style.nunRegular(
                                    fontSize: 16, color: ColorConstant.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  Widget commonContainer({String? date, String? day, String? des,List<GratitudeData>? gratitudeList}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AddGratitudePage(date:  DateFormat("dd/MM/yyyy").format(DateTime.now()),
              categoryList: gratitudeList,
              previous:false,

              isFromMyGratitude: true, categoryListAll: [],
              registerUser: false,
              edit: true,
            );
          },
        )).then(
          (value) async {
            await getGratitude();
            setState(() {});
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: themeController.isDarkMode.isTrue
                ? ColorConstant.textfieldFillColor
                : ColorConstant.backGround,
            borderRadius: BorderRadius.circular(18)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 63,
              width: 63,
              decoration: BoxDecoration(
                  color: ColorConstant.themeColor,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Dimens.d3.spaceHeight,
                  Text(
                    day ?? "",
                    style: Style.gothamLight(
                        fontSize: 10, color: ColorConstant.white),
                  ),
                  Text(
                    date ?? "",
                    style: Style.gothamMedium(
                        fontSize: 30, color: ColorConstant.white),
                  ),
                ],
              ),
            ),
            Dimens.d13.spaceWidth,
            Expanded(
                child: Text(
                  "“$des”",
              style: Style.nunRegular(
                  height: 2, fontSize: 11, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      ),
    );
  }
}

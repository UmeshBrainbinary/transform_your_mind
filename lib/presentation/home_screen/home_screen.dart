import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/service/method_channal_alarm.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/home_controller.dart';
import 'package:transform_your_mind/presentation/home_screen/home_message_page.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/home_widget.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_screen.dart';
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

  HomeController g = Get.put(HomeController());
  ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    _setGreetingBasedOnTime();
    _lottieBgController = AnimationController(vsync: this);

    scrollController.addListener(() {
      //scroll listener
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });
    g.getMotivationalMessage();
    g.getUSer();
    g.getPodApi();
    g.getBookMarkedList();
    g.getTodayGratitude();
    g.getTodayAffirmation();
    g.getRecentlyList();

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
    setState(() {});
    super.initState();
  }

  String greeting = "";

  void _setGreetingBasedOnTime() {
    greeting = _getGreetingBasedOnTime();
   setState(() {

   });
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
  final audioPlayerController = Get.find<NowPlayingController>();

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

  void _setAlarm() {
    AlarmService.setAlarm(
        selectedTime.hour, selectedTime.minute+1, "Flutter Alarm");
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: ValueListenableBuilder(
          valueListenable: showScrollTop,
          builder: (context, value, child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 700), //show/hide animation
              opacity: showScrollTop.value
                  ? 1.0
                  : 0.0, //set opacity to 1 on visible, or hide
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstant.themeColor,
                ),
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  elevation: 0.0,
                  onPressed: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    );
                  },
                  backgroundColor: ColorConstant.themeColor,
                  child: SvgPicture.asset(
                    ImageConstant.icUpArrow,
                    fit: BoxFit.fill,
                    height: Dimens.d20.h,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        backgroundColor: themeController.isDarkMode.isTrue
            ? ColorConstant.darkBackground
            : ColorConstant.themeColor.withOpacity(0.1),
        body: GetBuilder<HomeController>(
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
                      Dimens.d17.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Center(
                          child: Text(
                            "TransformYourMind",
                            style: Style.montserratRegular(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Dimens.d50.spaceHeight,

                      //__________________________ top view ____________________
                      topView(controller
                              .getUserModel.data?.motivationalMessage ??
                          "Believe in yourself, even when doubt creeps in. Today's progress is a step towards your dreams."),
                      Dimens.d36.spaceHeight,

                      Dimens.d16.spaceHeight,
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Dimens.d20),
                        child: Text(
                          "${greeting.tr}, ${PrefService.getString(PrefKey.name).toString()}",
                          textAlign: TextAlign.center,
                          style: Style.montserratRegular(fontSize: 22),
                        ),
                      ),
                      Dimens.d16.spaceHeight,

                      //______________________________ Recently Played _______________________
                      recentlyView(),

                      Dimens.d20.spaceHeight,

                      yourGratitude(),
                      Dimens.d40.spaceHeight,
                      yourAffirmation(),
                      Dimens.d30.spaceHeight,

                      //______________________________ yourDaily Recommendations _______________________

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Dimens.d20),
                        child: Text(
                          "yourRecommendations".tr,
                          textAlign: TextAlign.center,
                          style: Style.montserratRegular(fontSize: Dimens.d22),
                        ),
                      ),
                      Dimens.d20.spaceHeight,
                      recommendationsView(controller),

                      Dimens.d20.spaceHeight,
                      controller.bookmarkedModel.data == null
                          ? const SizedBox()
                          : controller.bookmarkedModel.data!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimens.d20),
                                  child: Text(
                                    "yourBookmarks".tr,
                          textAlign: TextAlign.center,
                          style: Style.montserratRegular(fontSize: Dimens.d22),
                        ),
                                )
                              : const SizedBox(),
                      Dimens.d20.spaceHeight,

                      bookmarkViw(controller),
                      controller.bookmarkedModel.data == null
                          ? const SizedBox()
                          : Dimens.d30.spaceHeight,

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Dimens.d20),
                        child: Text(
                          "quickAccess".tr,
                          textAlign: TextAlign.center,
                          style: Style.montserratRegular(fontSize: Dimens.d22),
                        ),
                      ),
                      Dimens.d30.spaceHeight,
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Dimens.d20),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  // 3 items per row
                                  childAspectRatio: 1.2,
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
                                    "motivational") {
                                  Navigator.pushNamed(context,
                                          AppRoutes.motivationalMessageScreen)
                                      .then((value) {
                                    setState(() {});
                                  });
                                } else if (g.quickAccessList[index]["title"] ==
                                    "transformPods") {

                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const TransformPodsScreen();
                                    },
                                  )).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                } else if (g.quickAccessList[index]["title"] ==
                                    "gratitudeJournal") {

                                  Navigator.pushNamed(
                                          context, AppRoutes.myGratitudePage)
                                      .then((value) {
                                    setState(() {});
                                  });
                                } else if (g.quickAccessList[index]["title"] ==
                                    "positiveMoments") {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const PositiveScreen();
                                    },
                                  )).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                } else if (g.quickAccessList[index]["title"] ==
                                    "affirmation") {

                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const MyAffirmationPage();
                                    },
                                  )).then(
                                    (value) {
                                      setState(() {});
                                    },
                                  );
                                } else {

                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return  BreathScreen(skip: false,);
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
                                    borderRadius: BorderRadius.circular(9),
                                    color: themeController.isDarkMode.value
                                        ? ColorConstant.textfieldFillColor
                                        : g.quickAccessList[index]["color"]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      g.quickAccessList[index]["icon"],
                                      height: 30,
                                      width: 30,
                                      color: ColorConstant.themeColor,
                                    ),
                                    Dimens.d12.spaceHeight,
                                    Text(
                                      "${g.quickAccessList[index]["title"]}".tr,
                                      style:
                                          Style.montserratSemiBold(fontSize: 8,color: ColorConstant.themeColor),
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
                Obx(
                  () => controller.loader.isTrue
                      ? commonLoader()
                      : const SizedBox(),
                ),
                Obx(() {
                  if (!audioPlayerController.isVisible.value) {
                    return const SizedBox.shrink();
                  }

                  final currentPosition =
                      audioPlayerController.positionStream.value ??
                          Duration.zero;
                  final duration = audioPlayerController.durationStream.value ??
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
                        height: 87,
                        width: Get.width,
                        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
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
                          children: [
                            Row(
                              children: [
                                CommonLoadImage(borderRadius: 6.0,
                                    url:audioDataStore!.image!,
                                    width: 47,
                                    height: 47),
                                Dimens.d12.spaceWidth,
                                GestureDetector(
                                    onTap: () async {
                                      if (isPlaying) {
                                        await audioPlayerController.pause();
                                      } else {
                                        await audioPlayerController.play();
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
                                    style: Style.montserratRegular(
                                        fontSize: 12, color: ColorConstant.white),
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
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                ColorConstant.white.withOpacity(0.2),
                                inactiveTrackColor: ColorConstant.color6E949D,
                                trackHeight: 1.5,
                                thumbColor: ColorConstant.transparent,
                                thumbShape: SliderComponentShape.noThumb,
                                overlayColor:
                                ColorConstant.backGround.withAlpha(32),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius:
                                    16.0), // Customize the overlay shape and size
                              ),
                              child: Slider(
                                thumbColor: Colors.transparent,
                                activeColor: ColorConstant.backGround,
                                value: currentPosition.inMilliseconds.toDouble(),
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  audioPlayerController.seekForMeditationAudio(
                                      position:
                                      Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ));
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
        onTap: () {

          _setAlarm();

          /*Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return HomeMessagePage(
                  motivationalMessage: motivationalMessage ??
                      "Believe in yourself, even when doubt creeps in. Today's progress is a step towards your dreams.");
              },
          ));*/

        },
        child: Container(
          height: 174,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
             image: DecorationImage(image: AssetImage( ImageConstant.homeBack,))),
          child:     Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0,right: 30.0),
              child: AutoSizeText(
                "“$motivationalMessage”",
                wrapWords: false,
                maxLines: 4,
                style: Style.gothamLight(
                    height: 1.8,
                    fontSize: Dimens.d18,
                    color: ColorConstant.black),
              ),
            ),
          ),
        )

        );
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
            children: List.generate(controller.recentlyModel.data?.length ?? 0,
                (index) {
              return GestureDetector(
                  onTap: () {
                    if(controller.recentlyModel.data![index].isPaid!){
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
                              id: controller.recentlyModel.data![index].id,
                              isPaid: controller.recentlyModel.data![index].isPaid,
                              image: controller.recentlyModel.data![index].image,
                              rating: controller.recentlyModel.data![index].rating,
                              description: controller.recentlyModel.data![index].description,
                              name: controller.recentlyModel.data![index].name,
                              isBookmarked: controller.recentlyModel.data![index].isBookmarked,
                              isRated: controller.recentlyModel.data![index].isRated,
                              category:controller.recentlyModel.data![index].category,
                              createdAt: controller.recentlyModel.data![index].createdAt,
                              podsBy: controller.recentlyModel.data![index].podsBy,
                              expertName: controller.recentlyModel.data![index].expertName,
                              audioFile: controller.recentlyModel.data![index].audioFile,
                              isRecommended: controller.recentlyModel.data![index].isRecommended,
                              status: controller.recentlyModel.data![index].status,
                              createdBy: controller.recentlyModel.data![index].createdBy,
                              updatedAt: controller.recentlyModel.data![index].updatedAt,
                              v: controller.recentlyModel.data![index].v,
                              download: false,
                            ),
                          );
                        },
                      );
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
                    child: RecentlyPlayed(
                      dataList: controller.recentlyModel.data![index],
                    ),
                  ));
            }),
          ),
        );
      },
    );
  }

  Widget bookmarkViw(HomeController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.bookmarkedModel.data?.length ?? 0, (index) {
              return GestureDetector(
                  onTap: () {
                    if(controller.bookmarkedModel.data![index].isPaid!){
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
                              id: controller.bookmarkedModel.data![index].id,
                              isPaid: controller.bookmarkedModel.data![index].isPaid,
                              image: controller.bookmarkedModel.data![index].image,
                              rating: controller.bookmarkedModel.data![index].rating,
                              description: controller.bookmarkedModel.data![index].description,
                              name: controller.bookmarkedModel.data![index].name,
                              isBookmarked: controller.bookmarkedModel.data![index].isBookmarked,
                              isRated: controller.bookmarkedModel.data![index].isRated,
                              category:controller.bookmarkedModel.data![index].category,
                              createdAt: controller.bookmarkedModel.data![index].createdAt,
                              podsBy: controller.bookmarkedModel.data![index].podsBy,
                              expertName: controller.bookmarkedModel.data![index].expertName,
                              audioFile: controller.bookmarkedModel.data![index].audioFile,
                              isRecommended: controller.bookmarkedModel.data![index].isRecommended,
                              status: controller.bookmarkedModel.data![index].status,
                              createdBy: controller.bookmarkedModel.data![index].createdBy,
                              updatedAt: controller.bookmarkedModel.data![index].updatedAt,
                              v: controller.bookmarkedModel.data![index].v,
                              download: false,
                            ),
                          );
                        },
                      );
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
                    child: BookmarkListTile(
                      dataList: controller.bookmarkedModel.data![index],
                    ),
                  ));
            }),
          ),
        ),
        // Dimens.d80.spaceHeight,
      ],
    );
  }

  Widget recommendationsView(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
      child: controller.audioData.isEmpty
          ? Center(
              child: Text(
                "noPodsRecommendation".tr,
                style: Style.montserratRegular(fontSize: Dimens.d15),
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
                          const Spacer(),
                          SizedBox(
                            width: Dimens.d200,
                            child: Text(
                              controller.audioData[index].name ?? "",
                              maxLines: 1,
                              style: Style.gothamLight(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Spacer(),
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
                          const Spacer(),
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
              style: Style.montserratRegular(fontSize: Dimens.d22),
            ),
          ),
          Dimens.d30.spaceHeight,
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: themeController.isDarkMode.value
                    ? ColorConstant.textfieldFillColor
                    : ColorConstant.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.black.withOpacity(0.1),
                    offset: const Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 0, // Specify the spread radius
                  )
                ]),
            child: (g.todayAList ?? []).isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Dimens.d10.spaceHeight,
                        Text(
                          g.todayAffirmation.message??"noDataFound".tr,
                          textAlign: TextAlign.center,
                          style: Style.montserratRegular(
                              fontSize: 14,
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.white
                                  : ColorConstant.black),
                        ),
                        Dimens.d20.spaceHeight,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CommonElevatedButton(
                            height: Dimens.d46,
                            textStyle: Style.montserratRegular(
                                fontSize: Dimens.d17,
                                color: ColorConstant.white),
                            title: "addNew".tr,
                            onTap: () {
                              Get.toNamed(AppRoutes.myAffirmationPage)!.then(
                                (value) async {
                                  await g.getTodayAffirmation();
                                  setState(() {
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        Dimens.d10.spaceHeight,
                      ],
                    ),
                  )
                : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: g.todayAList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await g.updateTodayData(g.todayAList![index].id,
                                  "update-affirmation");
                              g.affirmationCheckList[index] = true;
                              Future.delayed(const Duration(milliseconds: 500))
                                  .then(
                                (value) async {
                                  g.todayAList!.removeAt(index);

                                  await g.getTodayAffirmation();
                                  setState(() {});
                                },
                              );
                              setState(() {});
                            },
                            child: ListTile(
                              subtitle: Text(
                                g.todayAList?[index].description ?? "",
                                maxLines: 3,
                                style: Style.montserratRegular(),
                              ),
                              title: Text(
                                g.todayAList?[index].name ?? "",
                                style: Style.montserratSemiBold(),
                              ),
                              trailing: g.affirmationCheckList.isNotEmpty
                                  ? g.affirmationCheckList[index]
                                      ? Container(
                                          height: 40,
                                          width: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstant.themeColor),
                                      child: Center(
                                          child: SvgPicture.asset(
                                              ImageConstant.checkBox)),
                                        )
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: ColorConstant
                                                      .themeColor)),
                                        )
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: ColorConstant.themeColor)),
                                    ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                      Dimens.d20.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonElevatedButton(
                          height: Dimens.d46,
                          title: "addNew".tr,
                          textStyle: Style.montserratRegular(
                              fontSize: Dimens.d17, color: ColorConstant.white),
                          onTap: () {
                            Get.toNamed(AppRoutes.myAffirmationPage)!.then(
                              (value) async {
                                await g.getTodayAffirmation();

                                setState(() {
                                });
                              },
                            );
                          },
                        ),
                      ),
                      Dimens.d20.spaceHeight,
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
              style: Style.montserratRegular(fontSize: Dimens.d22),
            ),
          ),
          Dimens.d30.spaceHeight,
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: themeController.isDarkMode.value
                    ? ColorConstant.textfieldFillColor
                    : ColorConstant.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.black.withOpacity(0.1),
                    offset: const Offset(0, 0),
                    blurRadius: 4,
                    spreadRadius: 0, // Specify the spread radius
                  )
                ]),
            child: (g.todayGList ?? []).isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Dimens.d10.spaceHeight,
                        Text(
                          g.todayGratitude.message??"noDataFound".tr,
                          textAlign: TextAlign.center,
                          style: Style.montserratRegular(
                              fontSize: 14,
                              color: themeController.isDarkMode.value
                                  ? ColorConstant.white
                                  : ColorConstant.black),
                        ),
                        Dimens.d20.spaceHeight,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CommonElevatedButton(
                            height: Dimens.d46,
                            title: "addNew".tr,
                            textStyle: Style.montserratRegular(
                                fontSize: Dimens.d17,
                                color: ColorConstant.white),
                            onTap: () {
                              Get.toNamed(AppRoutes.myGratitudePage)!.then(
                                (value) async {
                                  await g.getTodayGratitude();
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                        Dimens.d10.spaceHeight,
                      ],
                    ),
                  )
                : Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: g.todayGList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              await g.updateTodayData(
                                  g.todayGList![index].id,
                                  "update-gratitude");
                              g.gratitudeCheckList[index] = true;
                              Future.delayed(
                                  const Duration(milliseconds: 500))
                                  .then(
                                    (value)  async {


                                  g.todayGList!.removeAt(index);

                                  await g.getTodayGratitude();
                                  setState(() {});
                                },
                              );
                              setState(() {


                              });
                            },
                            child: ListTile(
                              subtitle: Text(
                                g.todayGList?[index].description ?? "",
                                maxLines: 3,
                                style: Style.montserratRegular(),
                              ),
                              title: Text(
                                g.todayGList?[index].name ?? "",
                                style: Style.montserratSemiBold(),
                              ),
                              trailing: g.gratitudeCheckList.isNotEmpty
                                  ? g.gratitudeCheckList[index] == true
                                      ? Container(
                                          height: 40,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstant.themeColor),
                                      child: Center(
                                          child: SvgPicture.asset(
                                              ImageConstant.checkBox)),
                                        )
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: ColorConstant
                                                      .themeColor)),
                                        )
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: ColorConstant.themeColor)),
                                    ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                      Dimens.d20.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonElevatedButton(
                          height: Dimens.d46,
                          title: "addNew".tr,
                          textStyle: Style.montserratRegular(
                              fontSize: Dimens.d17, color: ColorConstant.white),
                          onTap: () {
                            Get.toNamed(AppRoutes.myGratitudePage)!.then(
                              (value) async {
                                await g.getTodayGratitude();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                      Dimens.d20.spaceHeight,
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

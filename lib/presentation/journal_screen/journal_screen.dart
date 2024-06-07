import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/common_gradiant_container.dart';
import 'package:transform_your_mind/core/common_widget/screen_info_widget.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

import '../../core/utils/style.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  List<JournalData> journalList = [
    JournalData(
      title: "gratitudeJournal".tr,
      lottie: ImageConstant.lottieSquare,
      route: AppRoutes.myGratitudePage,
    ),
    JournalData(
      title: "affirmation".tr,
      lottie: ImageConstant.lottieCircle,
      route: AppRoutes.myAffirmationPage,
    ),
    JournalData(
      title: "affirmationAlarms".tr,
      lottie: ImageConstant.lottieStarOcean,
      route: AppRoutes.affirmationAlarmScreen,
    ),
    JournalData(
      title: "motivational".tr,
      lottie: ImageConstant.lottieHexagon,
      route: AppRoutes.motivationalMessageScreen,
    ),
    JournalData(
      title: "positiveMoments".tr,
      lottie: ImageConstant.lottieSquircle,
      route: AppRoutes.positiveScreen,
    ),
  ];
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  int gratitudeAddedCount = 0;
  late AnimationController _controller;
  ScrollController scrollController = ScrollController();
  bool _isScrollingOrNot = false;
  ValueNotifier<bool> info = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  bool ratingView = false;
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int initialRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "selfDevelopment".tr,
          action: Row(
            children: [
              Dimens.d10.h.spaceWidth,
              GestureDetector(
                onTap: () async {
                  setState(() {
                    if (info.value == false) {
                      info.value = true;
                    } else {
                      info.value = false;
                    }
                    ratingView = false;
                  });
                  isTutorialVideoVisible.value = !isTutorialVideoVisible.value;
                  if (isTutorialVideoVisible.value) {
                    _controller.forward();
                  } else {
                    //videoKeys[0].currentState?.pause();
                    _controller.reverse();
                  }
                },
                child: SvgPicture.asset(
                  height: 25.h,
                  ImageConstant.information,
                ),
              ),
              Dimens.d10.h.spaceWidth,
              GestureDetector(
                onTap: () async {},
                child: SvgPicture.asset(
                  height: 25.h,
                  ImageConstant.notification,
                ),
              ),
              Dimens.d20.h.spaceWidth,
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Dimens.d30.spaceHeight,
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Dimens.d40),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Use our Self Development feature to practice the art of gratitude, clear unwanted feelings from your life, set goals & help you feel more calm & content.",
                        style: Style.montserratRegular(fontSize: 13),
                      ),
                    ),
                    Dimens.d21.spaceHeight,
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
                                            crossAxisSpacing: Dimens.d20,
                                            mainAxisSpacing: Dimens.d20,
                                            mainAxisExtent: 210,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  journalList[index].route ??
                                                      "",
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          Dimens.d12.paddingAll,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white,
                                                        borderRadius: Dimens
                                                            .d19.radiusAll,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius:
                                                                Dimens.d8,
                                                          )
                                                        ],
                                                      ),
                                                      child: Lottie.asset(
                                                          journalList[index]
                                                              .lottie,
                                                          height: 180,
                                                          width: 180,

                                                      ),
                                                    ),
                                                  ),
                                                  Dimens.d12.spaceHeight,
                                                  Text(
                                                    journalList[index].title,
                                                    style: Style
                                                        .montserratRegular(),
                                                  )
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
              info.value
                  ? Padding(
                      padding: EdgeInsets.only(top: Dimens.d10.h),
                      child: Container(
                        child: ScreenInfoWidget(
                          controller: _controller,
                          info: info,
                          isTutorialVideoVisible: isTutorialVideoVisible,
                          screenTitle: "welcomeToJournal".tr,
                          screenHeading:
                              "Use this self reflection fetaure to pratice the art of gratitude, clear unwanted fellings from your life, set goals and help you feel more clam and contect." ??
                                  '',
                          screenDesc:
                              "Use this self reflection fetaure to pratice the art of gratitude," ??
                                  '',
                          onVideoViewTap: () {},
                        ),
                      ),
                    )
                  : const SizedBox(),
              /*  ratingView
                  ? Padding(
                padding: EdgeInsets.only(top: Dimens.d110),
                child: AddRatingsView(
                  onRatingChanged: (p0) {
                    initialRating = p0;
                    _exploreBloc.add(AddFeatureRatingEvent(
                        addFeatureRatingRequestModel:
                        AddFeatureRatingRequestModel(
                            contentType: 4, rating: p0)));
                  },
                  initialRating: initialRating,
                  screenTitle: "Give your rating!",
                  screenHeading:
                  'We genuinely value your input and strive to continuously improve our services.',
                  screenDesc:
                  'Please take a moment to rate your experience with Shoorah Journal.',
                ),
              )
                  : const SizedBox(),
              (tutorialVideoData?.sId != null)
                  ? ratingView
                  ? const SizedBox()
                  : Padding(
                padding: EdgeInsets.only(top: Dimens.d110.h),
                child: SizedBox(
                  child: ScreenInfoWidget(
                    videoStateKey: videoKeys[0],
                    controller: _controller,
                    isTutorialVideoVisible: isTutorialVideoVisible,
                    tutorialVideoData:
                    tutorialVideoData ?? TutorialVideoData(),
                    screenTitle: i10n.welcomeToJournal,
                    screenHeading: tutorialVideoData?.heading ?? '',
                    screenDesc: tutorialVideoData?.subHeading ?? '',
                    onVideoViewTap: () {
                      SharedPrefUtils.setValue(
                          SharedPrefUtilsKeys.journalAddedCount, 5);
                    },
                  ),
                ),
              )
                  : const SizedBox(),*/
            ],
          ),
        ));
  }
}

class JournalData {
  final String lottie;
  final String title;
  final String? route;

  JournalData({
    this.route,
    required this.title,
    required this.lottie,
  });
}

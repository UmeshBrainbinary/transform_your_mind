import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/common_gradiant_container.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_controller.dart';
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
  ValueNotifier<bool> isTutorialVideoVisible = ValueNotifier(false);
  int gratitudeAddedCount = 0;
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
                      style: Style.nunRegular(fontSize: 13,color:themeController.isDarkMode.isTrue?ColorConstant.colorBFBFBF: ColorConstant.color747474),
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
                                            onTap: () {

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
                                                      journalList[index].title,
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

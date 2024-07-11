import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/common_widget/common_gradiant_container.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
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
      img: ImageConstant.heartGratitude,
      title: "gratitudeJournal".tr,
      lottie: ImageConstant.lottieSquare,
      route: AppRoutes.myGratitudePage,
    ),
    JournalData(
      img: ImageConstant.checkCircle,

      title: "affirmation".tr,
      lottie: ImageConstant.lottieCircle,
      route: AppRoutes.myAffirmationPage,
    ),

    JournalData(
      img: ImageConstant.motivational,

      title: "motivational".tr,
      lottie: ImageConstant.lottieHexagon,
      route: AppRoutes.motivationalMessageScreen,
    ),
    JournalData(
      img: ImageConstant.positiveBulb,

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int initialRating = 0;

  @override
  Widget build(BuildContext context) {
    /*statusBarSet(themeController);*/
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
                  Dimens.d30.spaceHeight,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.d20),
                    child: Text(
                      textAlign: TextAlign.center,
                      "useSelfDevelopment".tr,
                      style: Style.nunLight(fontSize: 13,color: ColorConstant.color747474),
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
                                                (value) {
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

                                                    Image.asset( journalList[index].img!,height: Dimens.d60,width: Dimens.d60,),
                                                    Dimens.d15.spaceHeight,
                                                    Text(
                                                      journalList[index].title,
                                                      style: Style
                                                          .nunLight(),
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

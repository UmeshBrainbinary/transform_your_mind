import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/cleanse_button.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/home_widget.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/todays_gratitude.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/todays_rituals.dart';
import 'package:transform_your_mind/widgets/bg_oval_custom_painter.dart';
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
  String _greeting = "";
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  int? totalCountCleanse = 0;
  List<Map<String, dynamic>> quickAccessList = [
    {"title": "Meditation", "icon": ImageConstant.calendar},
    {"title": "Sleep", "icon": ImageConstant.calendar},
    {"title": "Transfrom Pods", "icon": ImageConstant.calendar},
    {"title": "Journal", "icon": ImageConstant.calendar},
    {"title": "My Badges", "icon": ImageConstant.calendar},
  ];

  @override
  void initState() {
    _lottieBgController = AnimationController(vsync: this);
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        _setGreetingBasedOnTime();
      },
    );
    scrollController.addListener(() {
      //scroll listener
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _lottieBgController.dispose();
    super.dispose();
  }

  void _setGreetingBasedOnTime() {
    setState(() {
      _greeting = _getGreetingBasedOnTime();
    });
  }

  String _getGreetingBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
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
      backgroundColor: ColorConstant.themeColor.withOpacity(0.1),
      body: CustomScrollViewWidget(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //__________________________ top view ____________________
                topView(),
                Dimens.d36.spaceHeight,
                //___________________________ add share view  ______________
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          ImageConstant.icAddRounded,
                          width: Dimens.d46,
                          height: Dimens.d46,
                          color: ColorConstant.themeColor,
                        ),
                      ),
                      Dimens.d15.spaceWidth,
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: ColorConstant.themeColor,
                          radius: Dimens.d23,
                          child: SvgPicture.asset(
                            ImageConstant.icShareWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Dimens.d16.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: Text(
                    "$_greeting, RK!",
                    textAlign: TextAlign.center,
                    style: Style.cormorantGaramondMedium(fontSize: 22),
                  ),
                ),
                Dimens.d16.spaceHeight,

                //______________________________ TrendingThings _______________________
                trendingView(),

                Dimens.d30.spaceHeight,
                customDivider(),
                Dimens.d30.spaceHeight,
                //______________________________ ToDays Gratitude _______________________
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TodaysGratitude(),
                ),
                //______________________________ yourDaily Recommendations _______________________

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: Text(
                    "Your Recommendations",
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(fontSize: Dimens.d22),
                  ),
                ),
                Dimens.d20.spaceHeight,
                recommendationsView(),
                Dimens.d20.spaceHeight,
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorConstant.themeColor,
                    ),
                    child: Center(
                      child: Text(
                        "Refresh Daily Recommendations",
                        style: Style.montserratRegular(
                            fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Dimens.d30.spaceHeight,
                //______________________________ Today's Cleanse _______________________

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: Text(
                    "Today's Cleanse",
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(fontSize: Dimens.d22),
                  ),
                ),
                Dimens.d30.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CleanseButton(
                    totalCount: totalCountCleanse ?? 0,
                  ),
                ),
                Dimens.d50.spaceHeight,
                //______________________________ yourDailyRituals _______________________
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(vertical: 27),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TodaysRituals(
                    type: "Your Daily Rituals",
                  ),
                ),
                Dimens.d20.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: Text(
                    "Your Bookmarks",
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(fontSize: Dimens.d22),
                  ),
                ),
                Dimens.d20.spaceHeight,

                trendingView(),
                Dimens.d30.spaceHeight,
                customDivider(),
                Dimens.d30.spaceHeight,

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: Text(
                    "Quick Access",
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(fontSize: Dimens.d22),
                  ),
                ),
                Dimens.d30.spaceHeight,

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
                  child: SizedBox(
                    height: 250,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              // 3 items per row
                              childAspectRatio: 1.6,
                              crossAxisSpacing: 30,
                              mainAxisSpacing:
                                  30 // Set the aspect ratio as needed
                              ),
                      itemCount: quickAccessList.length,
                      // Total number of items
                      itemBuilder: (BuildContext context, int index) {
                        // Generating items for the GridView
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color:
                                    ColorConstant.themeColor.withOpacity(0.21)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  quickAccessList[index]["icon"],
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  quickAccessList[index]["title"],
                                  // Displaying item index
                                  style: Style.montserratRegular(
                                      fontSize: 8, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Dimens.d50.spaceHeight,
              ],
            ),
          ],
        ),
      ),
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

  Widget topView() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: Dimens.d300,
          child: Lottie.asset(
            ImageConstant.homeScreenMeshLottie,
            controller: _lottieBgController,
            height: MediaQuery.of(context).size.height / 3,
            fit: BoxFit.fill,
            onLoaded: (composition) {
              _lottieBgController
                ..duration = composition.duration
                ..repeat();
            },
          ),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              ImageConstant.imgTransformSemi,
              fit: BoxFit.cover,
              color: ColorConstant.themeColor.withOpacity(0.5),
            ),
            Positioned(
              left: Dimens.d50,
              right: Dimens.d50,
              top: Dimens.d40.h,
              bottom: Dimens.d15,
              child: Center(
                child: AutoSizeText(
                  "sdfhdsfhdsfgdsfhwefgerfdwfvdwghcfgewdiu,fcdwjdueilw" ?? '',
                  textAlign: TextAlign.center,
                  wrapWords: false,
                  maxLines: 4,
                  style: Style.cormorantGaramondMedium(fontSize: Dimens.d60),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget trendingView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(10, (index) {
              return GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: BookmarkListTile(),
                  ));
            }),
          ),
        ),
        // Dimens.d80.spaceHeight,
      ],
    );
  }

  Widget recommendationsView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        //itemCount:yourDailyRecommendations.length,
        itemCount: 5,

        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Container(
              height: Dimens.d100.h,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 0),
                    // Specify the offset of the shadow
                    blurRadius: 4,
                    // Specify the blur radius
                    spreadRadius: 0, // Specify the spread radius
                  ),
                ],
              ),
              child: Row(children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CachedNetworkImage(
                      height: Dimens.d80.h,
                      width: Dimens.d80,
                      imageUrl: "https://picsum.photos/250?image=9",
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
                    Container(
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
                    Text(
                      "Meditation Min",
                      style: Style.montserratRegular(
                          fontSize: 8, color: Colors.black),
                    ),
                    Dimens.d7.spaceHeight,
                    SizedBox(
                      width: Dimens.d200,
                      child: Text(
                        "cormorant Medium",
                        maxLines: 2,
                        style: Style.montserratRegular(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Dimens.d7.spaceHeight,
                    Text(
                      "Ravi Khunt",
                      style: Style.montserratRegular(
                          fontSize: 8, color: Colors.black),
                    ),
                  ],
                )
              ]),
            ),
          );
        },
      ),
    );
  }
}

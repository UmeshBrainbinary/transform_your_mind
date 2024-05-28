import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/explore_screen/widget/home_app_bar.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> with TickerProviderStateMixin  {
  late final AnimationController _lottieBgController;

  List<Map<String, dynamic>> menuItems = [
    {
      "title": "Self Development",
      "desc":"Self Development Description",
      // "buttonTitle": i10n.selfDevelopment,
      "buttonTitle": "Start Today!",
      "icon": ImageConstant.journalIcon
    },
    {
      "title": "transform Pods",
      "desc":"Self Development Description",
      // "buttonTitle": i10n.listenNow,
      "buttonTitle": "Listen & Grow!",
      "icon": ImageConstant.transformPodIcon
    },
    {
      "title": "Rituals",
      "desc":"Self Development Description",
      //"buttonTitle": i10n.ritualNow,
      "buttonTitle": "Begin Today!",
      "icon": ImageConstant.ritualIcon
    },

  ];
@override
  void initState() {
  _lottieBgController = AnimationController(vsync: this);

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: Dimens.d375,
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
              const Positioned(
                top: Dimens.d15,
                left: Dimens.d0,
                right: Dimens.d10,
                child: HomeAppBar(back: false,
                  fromHomeTab: false,
                  showMeIcon: false,
                  downloadShown: true,
                  downloadWidget: SizedBox(),
                  title: "Tools",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.d90,
                ),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Welcome to your\nTransform tool-kit",
                        style: Style.montserratRegular(fontSize: Dimens.d18),
                        children: [
                          TextSpan(
                            text: " RK!",
                            style: Style.montserratRegular(
                              fontSize: Dimens.d18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                    ),
                    Dimens.d25.spaceHeight,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: AutoSizeText(
                        "Your Transform tool-kit is a all in one collection of self development tools to help you on your mental health journey. Use the journaling feature to help clear your mind, listen to podcasts from our experts, explore meditations and sleep sounds and create daily habits to enhance your well being.",
                        textAlign: TextAlign.center,
                        wrapWords: false,
                        maxLines: 3,
                        style: Style.montserratRegular(fontSize: Dimens.d16),
                      ),
                    ),
                    Dimens.d50.spaceHeight,
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.centerLeft,
                          key: ValueKey(menuItems[index]),
                          children: [
                            GestureDetector(
                              key: ValueKey(menuItems[index]),
                              onTap: () {
                                if (menuItems[index]["title"] ==
                                    "Self Development") {
                                  Navigator.pushNamed(
                                      context, AppRoutes.journalScreen)
                                      .then((value) {
                                    setState(() {});
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 50, left: 30, right: 30),
                                child: Stack(
                                  key: ValueKey(menuItems[index]),
                                  // Use ValueKey for reordering
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(25.0),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.2))),
                                      padding: const EdgeInsets.only(
                                        left: 140,
                                        top: 10,
                                        bottom: 10,
                                        right: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Dimens.d10.spaceHeight,
                                          AutoSizeText(
                                            menuItems[index]["title"],
                                            style: Style.montserratMedium(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          Dimens.d10.spaceHeight,
                                          AutoSizeText(
                                            menuItems[index]["desc"],
                                            style: Style.montserratRegular(
                                                fontSize: 12.0,
                                                color: Colors.black),
                                          ),
                                          Dimens.d15.spaceHeight,
                                          CommonElevatedButton(
                                            title: menuItems[index]
                                            ["buttonTitle"],
                                         onTap: () {

                                         },
                                            height: 26.0,

                                            textStyle:
                                            Style.montserratRegular(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Dimens.d10.spaceHeight,
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      bottom: -10,
                                      width: 120,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                25.0),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.2))),
                                        padding: const EdgeInsets.all(20),
                                        child: IconButton(
                                          onPressed: null,
                                          iconSize: 40.0,
                                          icon: SvgPicture.asset(
                                            menuItems[index]["icon"],
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 15),
                                        child: SvgPicture.asset(
                                          ImageConstant.menueIcon,
                                          color: Colors.black,
                                          height: 15,
                                          width: 15,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item = menuItems.removeAt(oldIndex);
                          menuItems.insert(newIndex, item);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

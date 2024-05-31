import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/bg_oval_custom_painter.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/me_screen/me_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {

  String _greeting = "";

  int tabIndex = 0;
  int tabIndexMeSection = 1;
  int tabIndexMeSectionHistory = 0;

  MeController meController = Get.put(MeController());




  String _getGreetingBasedOnTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'goodMorning'.tr;
    } else if (hour >= 12 && hour < 17) {
      return 'goodAfternoon'.tr;
    } else if (hour >= 17 && hour < 21) {
      return 'goodEvening'.tr;
    } else {
      return 'goodNight'.tr;
    }
  }

  void _setGreetingBasedOnTime() {
    setState(() {
      _greeting = _getGreetingBasedOnTime();
    });
  }

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 100),
          () {
        _setGreetingBasedOnTime();
      },
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: CustomAppBar(
          title: "me".tr,
          showBack: false,
          action: Row(
            children: [
             GestureDetector(
               onTap: (){
                 Get.toNamed(AppRoutes.settingScreen);
               },
                 child: Image.asset(ImageConstant.setting, height: Dimens.d20, width: Dimens.d20, color: ColorConstant.themeColor)),
              Dimens.d20.spaceWidth
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                  padding: Dimens.d20.paddingHorizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Dimens.d8.spaceHeight,
                    Center(
                      child: Text(
                        "$_greeting, Test!",
                        textAlign: TextAlign.center,
                        style: Style.cormorantGaramondBold(fontSize: 20),
                      ),
                    ),
                    Dimens.d15.spaceHeight,
                    Center(
                      child: Text(
                        "everyoneU".tr,
                        textAlign: TextAlign.center,
                        style: Style.montserratMedium(
                          height: Dimens.d1_4,
                        ),
                      ),
                    ),



                  ],
                ),
              ),
              Dimens.d30.spaceHeight,

              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      tabIndexMeSection = 1;
                      setState(() {});
                    },
                    child: Container(
                      height: 28,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                          tabIndexMeSection == 1
                              ? 20
                              : 0),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(50),
                        color: tabIndexMeSection == 1
                            ? ColorConstant.color3d5157
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          "myHub".tr,
                          textAlign: TextAlign.center,
                          style: Style.cormorantGaramondBold(
                            height: Dimens.d1_4,
                            fontSize: 12,
                            color: tabIndexMeSection == 1
                                ? ColorConstant.white
                                : ColorConstant.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      tabIndexMeSection = 2;
                      setState(() {});
                    },
                    child: Container(
                      height: 28,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                          tabIndexMeSection == 2
                              ? 20
                              : 0),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(50),
                        color: tabIndexMeSection == 2
                            ? ColorConstant.color3d5157
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          "myLibrary".tr,
                          textAlign: TextAlign.center,
                          style: Style.cormorantGaramondBold(
                            height: Dimens.d1_4,
                            fontSize: 12,
                            color: tabIndexMeSection == 2
                                ? ColorConstant.white
                                : ColorConstant.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      tabIndexMeSection = 3;
                      setState(() {});
                    },
                    child: Container(
                      height: 28,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                          tabIndexMeSection == 3
                              ? 20
                              : 0),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(50),
                        color: tabIndexMeSection == 3
                            ? ColorConstant.color3d5157
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          "myHistory".tr,
                          textAlign: TextAlign.center,
                          style: Style.cormorantGaramondBold(
                            height: Dimens.d1_4,
                            fontSize: 12,
                            color: tabIndexMeSection == 3
                                ? ColorConstant.white
                                : ColorConstant.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),

              Dimens.d25.spaceHeight,
              tabIndexMeSection == 1
                  ? myHub()
                  : tabIndexMeSection == 2
                  ? myLibrary()
                  : myHistory(),
            ],
          ),
        )
      ),
    );
  }

  Widget myHub(){
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
              bottom: 50.h, top: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstant.color3d5157,
            border: Border.all(
                color:
                Colors.transparent),
          ),
          margin:
          EdgeInsets.only(top: 27.h),
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.only(
                  top: 15.0,
                  right: 30,
                  left: 30,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          "thoughtOfTheDay".tr,
                          textAlign:
                          TextAlign
                              .center,
                          style: Style.cormorantGaramondBold(
                              fontSize:
                              18,
                              color: ColorConstant.white),
                        ),
                        Dimens.d10
                            .spaceHeight,
                        Text(
                          "The journey of a thousand miles begins with one step. - Lao Tzu",
                          style: Style.montserratRegular(
                              height: Dimens
                                  .d1_4,
                              fontSize:
                              12,
                              color: ColorConstant.white),
                        ),
                      ],
                    ),
                    Dimens.d40.spaceHeight,
                    Text(
                      "yourInsights".tr,
                      textAlign: TextAlign
                          .center,
                      style: Style.cormorantGaramondBold(
                          fontSize: 18,
                          color: ColorConstant.white),
                    ),
                    Dimens
                        .d35.spaceHeight,
                    // Row(
                    //   mainAxisAlignment:
                    //   MainAxisAlignment
                    //       .spaceBetween,
                    //   children: [
                    //     Column(
                    //       children: [
                    //         Container(
                    //           width: MediaQuery.of(context)
                    //               .size
                    //               .width *
                    //               0.35,
                    //           padding: const EdgeInsets
                    //               .only(
                    //               top: 19,
                    //               bottom:
                    //               19),
                    //           decoration:
                    //           BoxDecoration(
                    //             /*     boxShadow: [
                    //                                     BoxShadow(
                    //                                         color: const Color(0xff707070).withOpacity(
                    //                                             0.18),
                    //                                         blurRadius:
                    //                                             6,
                    //                                         spreadRadius:
                    //                                             1)
                    //                                   ],*/
                    //             borderRadius:
                    //             BorderRadius.circular(
                    //                 25),
                    //             color: themeManager
                    //                 .meContainer,
                    //           ),
                    //           child:
                    //           Column(
                    //             crossAxisAlignment:
                    //             CrossAxisAlignment
                    //                 .center,
                    //             children: [
                    //               Text(
                    //                 i10n.daysSpent,
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.workSansRegular(
                    //                     fontSize: 11,
                    //                     color: Colors.white.withOpacity(0.4)),
                    //               ),
                    //               Dimens
                    //                   .d8
                    //                   .spaceHeight,
                    //               Stack(
                    //                 alignment:
                    //                 Alignment.center,
                    //                 children: [
                    //                   Image.asset(
                    //                     AppAssets.icC,
                    //                     height: 40,
                    //                     width: 40,
                    //                     color: Colors.white,
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(top: 5),
                    //                     child: Text(
                    //                       "${insightData.daysUsage ?? '0'}",
                    //                       textAlign: TextAlign.center,
                    //                       style: Style.mockinacBold(fontSize: 22, color: themeManager.colorTextWhite),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Dimens.d10
                    //             .spaceHeight,
                    //         Container(
                    //           width: MediaQuery.of(context)
                    //               .size
                    //               .width *
                    //               0.35,
                    //           padding: const EdgeInsets
                    //               .only(
                    //               top: 17,
                    //               bottom:
                    //               17),
                    //           decoration:
                    //           BoxDecoration(
                    //             /*   boxShadow: [
                    //                                     BoxShadow(
                    //                                         color: const Color(0xff707070).withOpacity(
                    //                                             0.18),
                    //                                         blurRadius:
                    //                                             5,
                    //                                         spreadRadius:
                    //                                             1)
                    //                                   ],*/
                    //             borderRadius:
                    //             BorderRadius.circular(
                    //                 25),
                    //             color: themeManager
                    //                 .meContainer,
                    //           ),
                    //           child:
                    //           Column(
                    //             crossAxisAlignment:
                    //             CrossAxisAlignment
                    //                 .center,
                    //             children: [
                    //               Text(
                    //                 i10n.totalHourSpent,
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.workSansRegular(
                    //                     fontSize: 11,
                    //                     color: Colors.white.withOpacity(0.4)),
                    //               ),
                    //               Dimens
                    //                   .d15
                    //                   .spaceHeight,
                    //               Text(
                    //                 "${insightData.appDuration ?? '0'}",
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.mockinacBold(
                    //                     fontSize: 22,
                    //                     color: themeManager.colorTextWhite),
                    //               ),
                    //               // Text(
                    //               //   "(hours)",
                    //               //   textAlign: TextAlign.center,
                    //               //   style: Style.mockinacBold(
                    //               //       fontSize: 14,
                    //               //       color: themeManager.colorTextWhite),
                    //               // ),
                    //               Dimens
                    //                   .d5
                    //                   .spaceHeight,
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     Column(
                    //       children: [
                    //         Container(
                    //           width: MediaQuery.of(context)
                    //               .size
                    //               .width *
                    //               0.43,
                    //           padding: const EdgeInsets
                    //               .only(
                    //               left:
                    //               15,
                    //               top: 10,
                    //               bottom:
                    //               9),
                    //           decoration:
                    //           BoxDecoration(
                    //             /*     boxShadow: [
                    //                                  BoxShadow(
                    //                                      color: const Color(0xff707070).withOpacity(
                    //                                             0.18),
                    //                                         blurRadius:
                    //                                             5,
                    //                                         spreadRadius:
                    //                                             1)
                    //                               ],*/
                    //             borderRadius:
                    //             BorderRadius.circular(
                    //                 25),
                    //             color: themeManager
                    //                 .meContainer,
                    //           ),
                    //           child:
                    //           Column(
                    //             crossAxisAlignment:
                    //             CrossAxisAlignment
                    //                 .start,
                    //             children: [
                    //               Text(
                    //                 i10n.minutesListened,
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.workSansRegular(
                    //                     fontSize: 11,
                    //                     color: Colors.white.withOpacity(0.4)),
                    //               ),
                    //               Dimens
                    //                   .d7
                    //                   .spaceHeight,
                    //               Text(
                    //                 "${insightData.listenDuration ?? '0'}",
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.mockinacBold(
                    //                     fontSize: 19,
                    //                     color: themeManager.colorTextWhite),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Dimens.d6
                    //             .spaceHeight,
                    //         Container(
                    //           width: MediaQuery.of(context)
                    //               .size
                    //               .width *
                    //               0.43,
                    //           padding: const EdgeInsets
                    //               .only(
                    //               left:
                    //               15,
                    //               top: 10,
                    //               bottom:
                    //               9),
                    //           decoration:
                    //           BoxDecoration(
                    //             /*      boxShadow: [
                    //                                 BoxShadow(
                    //                                     color: const Color(0xff707070).withOpacity(
                    //                                             0.18),
                    //                                         blurRadius:
                    //                                             5,
                    //                                         spreadRadius:
                    //                                             1)
                    //                               ],*/
                    //             borderRadius:
                    //             BorderRadius.circular(
                    //                 25),
                    //             color: themeManager
                    //                 .meContainer,
                    //           ),
                    //           child:
                    //           Column(
                    //             crossAxisAlignment:
                    //             CrossAxisAlignment
                    //                 .start,
                    //             children: [
                    //               Text(
                    //                 i10n.totalJournalsInput,
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.workSansRegular(
                    //                     fontSize: 11,
                    //                     color: Colors.white.withOpacity(0.4)),
                    //               ),
                    //               Dimens
                    //                   .d7
                    //                   .spaceHeight,
                    //               Text(
                    //                 "${insightData.journalCounts ?? '0'}",
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.mockinacBold(
                    //                     fontSize: 19,
                    //                     color: themeManager.colorTextWhite),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         Dimens.d6
                    //             .spaceHeight,
                    //         Container(
                    //           width: MediaQuery.of(context)
                    //               .size
                    //               .width *
                    //               0.43,
                    //           padding: const EdgeInsets
                    //               .only(
                    //               left:
                    //               15,
                    //               top: 10,
                    //               bottom:
                    //               9),
                    //           decoration:
                    //           BoxDecoration(
                    //             /*    boxShadow: [
                    //                                 BoxShadow(
                    //                                     color: const Color(0xff707070).withOpacity(
                    //                                             0.18),
                    //                                         blurRadius:
                    //                                             5,
                    //                                         spreadRadius:
                    //                                             1)
                    //                               ],*/
                    //             borderRadius:
                    //             BorderRadius.circular(
                    //                 25),
                    //             color: themeManager
                    //                 .meContainer,
                    //           ),
                    //           child:
                    //           Column(
                    //             crossAxisAlignment:
                    //             CrossAxisAlignment
                    //                 .start,
                    //             children: [
                    //               Text(
                    //                 i10n.currentStreak,
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.workSansRegular(
                    //                     fontSize: 11,
                    //                     color: Colors.white.withOpacity(0.4)),
                    //               ),
                    //               Dimens
                    //                   .d7
                    //                   .spaceHeight,
                    //               Text(
                    //                 "${insightData.streakCounts ?? '0'}",
                    //                 textAlign:
                    //                 TextAlign.center,
                    //                 style: Style.mockinacBold(
                    //                     fontSize: 19,
                    //                     color: themeManager.colorTextWhite),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // Dimens
                    //     .d35.spaceHeight,
                    // const YourFocuses(),
                    // Dimens
                    //     .d35.spaceHeight,
                    // const YourAffirmationFocuses(),
                  ],
                ),
              ),
              // Stack(
              //   children: [
              //     /*    BackGroundContainer(
              //                         image: themeManager.homeBgGratitude,
              //                         isLeft: false,
              //                         top: Dimens.d200,
              //                         height: Dimens.d330,
              //                       ),
              //                       BackGroundContainer(
              //                         image: themeManager.homeBgBookmarks,
              //                         isLeft: true,
              //                         top: Dimens.d731,
              //                         height: Dimens.d100,
              //                       ),*/
              //     LayoutContainer(
              //       vertical: Dimens.d0,
              //       child: Column(
              //         mainAxisSize:
              //         MainAxisSize
              //             .min,
              //         crossAxisAlignment:
              //         CrossAxisAlignment
              //             .start,
              //         children: [
              //           Dimens.d30
              //               .spaceHeight,
              //           const YourGoals(),
              //           const MyBadgesPage(),
              //           Padding(
              //             padding: Dimens
              //                 .d60
              //                 .paddingVertical,
              //             child:
              //             Container(
              //               decoration:
              //               BoxDecoration(
              //                 color: Colors
              //                     .white,
              //                 borderRadius:
              //                 BorderRadius.circular(
              //                     Dimens.d16),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors
              //                         .black
              //                         .withOpacity(0.08),
              //                     blurRadius:
              //                     Dimens.d177,
              //                   ),
              //                 ],
              //               ),
              //               child:
              //               SettingListItem(
              //                 prefixIcon:
              //                 AppAssets
              //                     .lottieSettings,
              //                 title: i10n
              //                     .settings,
              //                 suffixIcon:
              //                 themeManager
              //                     .lottieRightArrow,
              //                 onTap: () {
              //                   Navigator
              //                       .pushNamed(
              //                     context,
              //                     SettingsPage
              //                         .settings,
              //                   );
              //                 },
              //                 isSettings:
              //                 false,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        CustomPaint(
          painter: BgOvalCustomPainter(),
          size: Size(double.infinity,
              Dimens.d28.h),
        ),
      ],
    );
  }

  Widget myLibrary(){
    return Stack(
      children: [
        Container(
          padding:
          EdgeInsets.only(
              bottom: 50.h,
              top: 8),
          width: double.infinity,
          decoration:
          BoxDecoration(
            color: ColorConstant.color3d5157,
            border: Border.all(
                color: Colors
                    .transparent),
          ),
          margin: EdgeInsets.only(
              top: 27.h),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets
                        .only(
                        right:
                        25,
                        left:
                        25,
                        top:
                        20),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "recentlyPlayed".tr,
                          textAlign:
                          TextAlign.center,
                          style: Style.montserratMedium(
                              fontSize:
                              18,
                              color: ColorConstant.white
                          ),
                        ),
                        InkWell(
                          onTap:
                              () {

                          },
                          child:
                          Container(
                            alignment:
                            Alignment.centerRight,
                            width:
                            100,
                            height:
                            20,
                            child:
                            Text(
                              "seeAll".tr,
                              textAlign:
                              TextAlign.center,
                              style:
                              Style.montserratMedium(fontSize: 10, color: Colors.white.withOpacity(0.4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Dimens.d20
                      .spaceHeight,
                  // (allRecentlyPlayedData.isNotEmpty)
                  //     ?
                  SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal,
                    child:
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children:
                      List.generate(
                        meController.recentlyPlayed.length,
                            (index) =>
                            GestureDetector(
                              onTap: ()  {},
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  width: Dimens.d120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 130,
                                        width: 140,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            image: DecorationImage(
                                              // image: NetworkImage(
                                              //   allRecentlyPlayedData[index].image ?? allRecentlyPlayedData[index].expertImage ?? '',
                                              // ),
                                              image: AssetImage(meController.recentlyPlayed[index]["image"]),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      Dimens.d6.spaceHeight,
                                      Text(
                                        "meditation",
                                        style: Style.montserratRegular(fontSize: Dimens.d12, color: ColorConstant.white).copyWith(
                                          letterSpacing: -Dimens.d0_16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Dimens.d7.spaceHeight,
                                      Text(
                                        meController.recentlyPlayed[index]["title"],
                                        style: Style.montserratRegular().copyWith(letterSpacing: Dimens.d0_48, fontSize: Dimens.d12, color: ColorConstant.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  )
                  /// when list empty
                  //     : Container(
                  //   margin:
                  //   const EdgeInsets.only(
                  //     right:
                  //     25,
                  //     left:
                  //     25,
                  //   ),
                  //   width: MediaQuery.of(context)
                  //       .size
                  //       .width,
                  //   padding:
                  //   const EdgeInsets.symmetric(
                  //     vertical:
                  //     Dimens.d24,
                  //     horizontal:
                  //     Dimens.d20,
                  //   ),
                  //   decoration:
                  //   BoxDecoration(
                  //     color:
                  //     themeManager.meContainer,
                  //     borderRadius:
                  //     BorderRadius.circular(Dimens.d16),
                  //     /*   boxShadow: [
                  //                                           BoxShadow(
                  //                                               color: const Color(0xff707070).withOpacity(0.18),
                  //                                               blurRadius: 6,
                  //                                               spreadRadius: 1)
                  //                                         ],*/
                  //   ),
                  //   child:
                  //   Column(
                  //     mainAxisSize:
                  //     MainAxisSize.min,
                  //     crossAxisAlignment:
                  //     CrossAxisAlignment.center,
                  //     children: [
                  //       Image.asset(
                  //         AppAssets.circleClock,
                  //         height: 30.r,
                  //         width: 30.r,
                  //       ),
                  //       Dimens.d10.spaceHeight,
                  //       Text(
                  //         i10n.noHistoryYet,
                  //         style: Style.mockinacLight(fontSize: 16, color: Colors.white.withOpacity(0.5)),
                  //       ),
                  //       Dimens.d10.spaceHeight,
                  //       Text(
                  //         i10n.startMeditation,
                  //         textAlign: TextAlign.center,
                  //         style: Style.mockinacLight(fontSize: 12, color: Colors.white.withOpacity(0.4)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              Dimens
                  .d5.spaceHeight,
              Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets
                        .only(
                        right:
                        25,
                        left:
                        25,
                        top:
                        20),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "yourBookmarks".tr,
                          textAlign:
                          TextAlign.center,
                          style: Style.montserratMedium(
                              fontSize:
                              18,
                              color: ColorConstant.white),
                        ),
                        InkWell(
                          onTap:
                              () {

                          },
                          child:
                          Container(
                            alignment:
                            Alignment.centerRight,
                            width:
                            100,
                            height:
                            20,
                            child:
                            Text(
                              "seeAll".tr,
                              textAlign:
                              TextAlign.center,
                              style:
                              Style.montserratMedium(fontSize: 10, color: Colors.white.withOpacity(0.4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Dimens.d20.spaceHeight,
                  // (listOfBookmarks.length != 0)
                  //     ?
                  SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal,
                    child:
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children:
                      List.generate(
                        meController.recentlyPlayed.length,
                            (index) =>
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  width: Dimens.d120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 130,
                                        width: 140,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  meController.recentlyPlayed[index]["image"]
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      Dimens.d6.spaceHeight,
                                      Text(
                                        "meditation",
                                        style: Style.montserratRegular(fontSize: Dimens.d12, color: ColorConstant.white).copyWith(
                                          letterSpacing: -Dimens.d0_16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Dimens.d7.spaceHeight,
                                      Text(
                                        meController.recentlyPlayed[index]["title"],
                                        style: Style.montserratRegular().copyWith(letterSpacing: Dimens.d0_48, fontSize: Dimens.d12, color: ColorConstant.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  )
                  /// when list empty
                  //     : Container(
                  //   margin:
                  //   const EdgeInsets.only(
                  //     right:
                  //     25,
                  //     left:
                  //     25,
                  //   ),
                  //   width: MediaQuery.of(context)
                  //       .size
                  //       .width,
                  //   padding:
                  //   const EdgeInsets.symmetric(
                  //     vertical:
                  //     Dimens.d24,
                  //     horizontal:
                  //     Dimens.d20,
                  //   ),
                  //   decoration:
                  //   BoxDecoration(
                  //     color:
                  //     themeManager.meContainer,
                  //     borderRadius:
                  //     BorderRadius.circular(Dimens.d16),
                  //     /*      boxShadow: [
                  //                                           BoxShadow(
                  //                                               color: const Color(0xff707070).withOpacity(0.18),
                  //                                               blurRadius: 6,
                  //                                               spreadRadius: 1)
                  //                                         ],*/
                  //   ),
                  //   child:
                  //   Column(
                  //     mainAxisSize:
                  //     MainAxisSize.min,
                  //     crossAxisAlignment:
                  //     CrossAxisAlignment.center,
                  //     children: [
                  //       SvgPicture.asset(
                  //         height: 28.h,
                  //         width: 28.h,
                  //         AppAssets.bookmark,
                  //       ),
                  //       Dimens.d10.spaceHeight,
                  //       Text(
                  //         i10n.noBookmark,
                  //         style: Style.mockinacLight(fontSize: 16, color: Colors.white.withOpacity(0.5)),
                  //       ),
                  //       Dimens.d10.spaceHeight,
                  //       Text(
                  //         i10n.bookmarkYourFav,
                  //         textAlign: TextAlign.center,
                  //         style: Style.mockinacLight(fontSize: 12, color: Colors.white.withOpacity(0.4)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              Dimens.d35.spaceHeight,


              /// my download yet
              Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets
                        .only(
                        right:
                        25,
                        left:
                        25,
                        top:
                        20),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Text(
                          "myDownloads".tr,
                          textAlign:
                          TextAlign.center,
                          style: Style.montserratMedium(
                              fontSize:
                              18,
                              color: ColorConstant.white),
                        ),
                        InkWell(
                          onTap:
                              () {

                          },
                          child:
                          Container(
                            width:
                            100,
                            height:
                            20,
                            alignment:
                            Alignment.centerRight,
                            child:
                            Text(
                              "seeAll".tr,
                              textAlign:
                              TextAlign.center,
                              style:
                              Style.montserratRegular(fontSize: 10, color: Colors.white.withOpacity(0.4)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Dimens.d20
                      .spaceHeight,
                  (meController.downloadList.isNotEmpty)
                      ? SingleChildScrollView(
                    scrollDirection:
                    Axis.horizontal,
                    child:
                    Row(
                      children:
                      List.generate(
                        meController.recentlyPlayed.length,
                            (index) =>
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  width: Dimens.d120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 130,
                                        width: 140,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  meController.recentlyPlayed[index]["image"]
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      Dimens.d6.spaceHeight,
                                      Text(
                                        "meditation",
                                        style: Style.montserratRegular(fontSize: Dimens.d12, color: ColorConstant.white).copyWith(
                                          letterSpacing: -Dimens.d0_16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Dimens.d7.spaceHeight,
                                      Text(
                                        meController.recentlyPlayed[index]["title"],
                                        style: Style.montserratRegular().copyWith(letterSpacing: Dimens.d0_48, fontSize: Dimens.d12, color: ColorConstant.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ).toList(),
                    ),
                  )
                      : Container(
                    margin:
                    const EdgeInsets.only(
                      right:
                      25,
                      left:
                      25,
                    ),
                    width: MediaQuery.of(context)
                        .size
                        .width,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical:
                      Dimens.d24,
                      horizontal:
                      Dimens.d20,
                    ),
                    decoration:
                    BoxDecoration(
                      color: ColorConstant.black.withOpacity(0.2),
                      borderRadius:
                      BorderRadius.circular(Dimens.d16),
                      /*   boxShadow: [
                                              BoxShadow(
                                                  color: const Color(0xff707070).withOpacity(0.18),
                                                  blurRadius: 6,
                                                  spreadRadius: 1)
                                            ],*/
                    ),
                    child:
                    Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          height: 28.h,
                          width: 28.h,
                          color: Colors.grey.withOpacity(0.35),
                          ImageConstant.download,
                        ),
                        Dimens.d10.spaceHeight,
                        Text(
                          "noDownloadYet".tr,
                          style: Style.cormorantGaramondBold(fontSize: 16, color: Colors.white.withOpacity(0.5)),
                        ),
                        Dimens.d10.spaceHeight,
                        Text(
                          "downloadYourFavouriteContentToSaveThemHereForQuickAccess".tr,
                          textAlign: TextAlign.center,
                          style: Style.montserratMedium(fontSize: 12, color: Colors.white.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        CustomPaint(
          painter:
          BgOvalCustomPainter(),
          size: Size(
              double.infinity,
              Dimens.d28.h),
        ),
      ],
    );
  }

  Widget myHistory(){
    return Stack(
      children: [
        Container(
          padding:
          EdgeInsets.only(
              bottom: 50.h),
          width: double.infinity,
          decoration:
          BoxDecoration(
            color: ColorConstant.color3d5157,
            border: Border.all(
                color: Colors
                    .transparent),
          ),
          margin: EdgeInsets.only(
              top: 27.h),
          child: Padding(
            padding:
            const EdgeInsets
                .all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start,
              children: [

                // Text(
                //   i10n.myCalender,
                //   textAlign:
                //   TextAlign
                //       .center,
                //   style: Style.mockinacBold(
                //       fontSize:
                //       18,
                //       color: themeManager
                //           .colorTextWhite),
                // ),
                // Dimens.d20
                //     .spaceHeight,
                // SizedBox(
                //     height: Dimens
                //         .d420,
                //     child:
                //     CalenderPage(
                //         dates:
                //         _historyDates,
                //         onDateSelected:
                //             (selectedDate) {
                //           setState(() {
                //             debugPrint('selection dates ------ $selectedDate');
                //             tabIndexMeSectionHistory = 0;
                //             var dateFormatter = DateFormat('yyyy-MM-dd');
                //             var strDate = dateFormatter.format(selectedDate);
                //             calenderDate = selectedDate;
                //             moodBloc.add(GetHistoryDataEvent(sDate: strDate));
                //           });
                //         })),
                //
                // Text(
                //   DateFormat(
                //       'MMMM d, yyyy')
                //       .format(
                //       calenderDate),
                //   style: Style.mockinacBold(
                //       fontSize:
                //       18,
                //       color: themeManager
                //           .colorTextWhite),
                // ),
                // Dimens.d15
                //     .spaceHeight,
                // //________________________________________________________ my history List ____________________
                //
                // SingleChildScrollView(
                //   scrollDirection:
                //   Axis.horizontal,
                //   child: Row(
                //     children: List.generate(
                //         _historyDataForAll.length,
                //             (index) => ((_historyDataForAll[index]['data'].length != 0))
                //             ? GestureDetector(
                //           onTap: () {
                //             tabIndexMeSectionHistory = index;
                //             setState(() {});
                //           },
                //           child: Container(
                //             height: 28,
                //             padding: EdgeInsets.symmetric(horizontal: tabIndexMeSectionHistory == index ? 20 : 10),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(50),
                //               color: tabIndexMeSectionHistory == index ? themeManager.colorThemed5 : Colors.transparent,
                //             ),
                //             child: Center(
                //               child: Text(
                //                 _historyDataForAll[index]['type'].toString().capitalize(),
                //                 textAlign: TextAlign.center,
                //                 style: Style.mockinacLight(
                //                   height: Dimens.d1_4,
                //                   fontSize: 12,
                //                   color: tabIndexMeSectionHistory == index ? AppColors.white : themeManager.colorTextWhite,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         )
                //             : const SizedBox()).toList(),
                //   ),
                // ),
                //
                // Column(
                //   crossAxisAlignment:
                //   CrossAxisAlignment
                //       .start,
                //   children: [
                //     Dimens.d20
                //         .spaceHeight,
                //     (_historyDataForAll[tabIndexMeSectionHistory]['data']
                //         .length !=
                //         0)
                //         ? Column(
                //       crossAxisAlignment:
                //       CrossAxisAlignment.start,
                //       mainAxisAlignment:
                //       MainAxisAlignment.center,
                //       children: List.generate(
                //           _historyDataForAll[tabIndexMeSectionHistory]['data'].length,
                //               (i) => Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               InkWell(
                //                 onTap: () async {
                //                   if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "CLEANSES") {
                //                     Navigator.of(context).pushNamed(
                //                       '/myCleanse',
                //                     );
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "GOALS") {
                //                     Navigator.of(context).pushNamed('/myGoals', arguments: {
                //                       AppConstants.fromNotification: false,
                //                     });
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "NOTES") {
                //                     Navigator.of(context).pushNamed(
                //                       '/myNotes',
                //                     );
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "AFFIRMATIONS") {
                //                     Navigator.of(context).pushNamed(
                //                       '/myAffirmation',
                //                     );
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "GRATITUDE") {
                //                     Navigator.of(context).pushNamed('/myGratitude', arguments: {
                //                       AppConstants.fromNotification: false,
                //                     });
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "MEDITATION HISTORY") {
                //                     dataToPass = null;
                //                     setState(() {
                //                       loader = true;
                //                     });
                //                     restoreBloc.add(
                //                       FetchRestoreAudioDetailsEvent(
                //                         contentType: 3,
                //                         contentId: _historyDataForAll[tabIndexMeSectionHistory]['data'][i]['contentId'],
                //                       ),
                //                     );
                //                     await Future.delayed(const Duration(seconds: 3), () {});
                //                     setState(() {
                //                       loader = false;
                //                     });
                //                     if (dataToPass != null) {
                //                       _onMeditationTap(tabIndexMeSectionHistory, context, dataToPass);
                //                       setState(() {
                //                         loader = false;
                //                       });
                //                     }
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "SLEEP HISTORY") {
                //                     dataToPass = null;
                //                     setState(() {
                //                       loader = true;
                //                     });
                //                     restoreBloc.add(
                //                       FetchRestoreAudioDetailsEvent(
                //                         contentType: 4,
                //                         contentId: _historyDataForAll[tabIndexMeSectionHistory]['data'][i]['contentId'],
                //                       ),
                //                     );
                //                     await Future.delayed(const Duration(seconds: 3), () {});
                //                     setState(() {
                //                       loader = false;
                //                     });
                //                     if (dataToPass != null) {
                //                       _onSleepTap(tabIndexMeSectionHistory, context, dataToPass);
                //                       setState(() {
                //                         loader = false;
                //                       });
                //                     }
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "PODS HISTORY") {
                //                     dataToPass = null;
                //                     setState(() {
                //                       loader = true;
                //                     });
                //                     restoreBloc.add(
                //                       FetchRestoreAudioDetailsEvent(
                //                         contentType: 5,
                //                         contentId: _historyDataForAll[tabIndexMeSectionHistory]['data'][i]['contentId'],
                //                       ),
                //                     );
                //                     await Future.delayed(const Duration(seconds: 3), () {});
                //                     setState(() {
                //                       loader = false;
                //                     });
                //                     if (dataToPass != null) {
                //                       setState(() {
                //                         _onPodsTap(tabIndexMeSectionHistory, context, dataToPass);
                //                         loader = false;
                //                       });
                //                     }
                //                   } else if (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "SHURU CHAT HISTORY") {
                //                     final ShuruMood mood = shuruMoods.firstWhere((ShuruMood e) => e.moodId.toString() == _historyDataForAll[tabIndexMeSectionHistory]['data'][i].mood, orElse: () => ShuruMood.content);
                //                     setState(() {
                //                       sessionId = _historyDataForAll[tabIndexMeSectionHistory]['data'][i].id;
                //                       messageMood = mood;
                //                     });
                //                     getChatMessageBloc.add(
                //                       GetSessionMessages(
                //                         request: GetSessionMessagesRequest(
                //                           chatId: _historyDataForAll[tabIndexMeSectionHistory]['data'][i].id,
                //                           pageNumber: 1,
                //                           limit: 200,
                //                         ),
                //                       ),
                //                     );
                //                     //Navigator.of(context).pushNamed('/myShuruProfile',);
                //                   } else {}
                //                 },
                //                 child: SizedBox(
                //                   child: Row(
                //                     mainAxisSize: MainAxisSize.min,
                //                     crossAxisAlignment: CrossAxisAlignment.start,
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "SHURU CHAT HISTORY" || _historyDataForAll[tabIndexMeSectionHistory]['data'][i]['imageUrl'] == '' || _historyDataForAll[tabIndexMeSectionHistory]['data'][i]['imageUrl'] == null)
                //                           ? Stack(
                //                         alignment: Alignment.center,
                //                         children: [
                //                           Container(
                //                             height: 100.r,
                //                             width: 100.r,
                //                             alignment: Alignment.center,
                //                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: themeManager.colorThemed7),
                //                           ),
                //                           Positioned(
                //                             bottom: 0,
                //                             right: 0,
                //                             left: 40,
                //                             child: ClipRRect(
                //                               borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                //                               child: Image.asset(
                //                                 AppAssets.imgExploreAffirmation,
                //                                 fit: BoxFit.contain,
                //                                 color: themeManager.colorThemed2.withOpacity(0.6),
                //                               ),
                //                             ), //imgExploreAffirmation
                //                           ),
                //                           _historyDataForAll[tabIndexMeSectionHistory]['type'] == "SHURU CHAT HISTORY"
                //                               ? Lottie.asset(
                //                             shuruMoods[int.parse(_historyDataForAll[tabIndexMeSectionHistory]['data'][i].mood)].lottieImage,
                //                             repeat: true,
                //                             animate: true,
                //                             onWarning: log,
                //                             height: 80,
                //                             width: 80,
                //                             frameRate: FrameRate.max,
                //                             controller: _lottieController,
                //                             onLoaded: (composition) {
                //                               _lottieController
                //                                 ..duration = composition.duration
                //                                 ..reset()
                //                                 ..repeat()
                //                                 ..forward();
                //                             },
                //                           )
                //                               : const SizedBox(),
                //                         ],
                //                       )
                //                           : Container(
                //                         height: 100.r,
                //                         width: 100.r,
                //                         alignment: Alignment.center,
                //                         decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(16),
                //                             image: DecorationImage(
                //                               image: NetworkImage(
                //                                 _historyDataForAll[tabIndexMeSectionHistory]['data'][i]['imageUrl'] ?? '',
                //                               ),
                //                               fit: BoxFit.cover,
                //                             )),
                //                       ),
                //                       Dimens.d10.spaceWidth,
                //                       Column(
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             timeAgo(calenderDate),
                //                             style: Style.workSansRegular(fontSize: Dimens.d12, color: themeManager.colorTextWhite).copyWith(
                //                               letterSpacing: -Dimens.d0_16,
                //                             ),
                //                             maxLines: 1,
                //                             overflow: TextOverflow.ellipsis,
                //                           ),
                //                           Dimens.d4.spaceHeight,
                //                           SizedBox(
                //                             width: 200,
                //                             child: Text(
                //                               (_historyDataForAll[tabIndexMeSectionHistory]['type'] == "SHURU CHAT HISTORY") ? _historyDataForAll[tabIndexMeSectionHistory]['data'][i].title : "${_historyDataForAll[tabIndexMeSectionHistory]['data'][i]['title'] ?? ''}",
                //                               overflow: TextOverflow.ellipsis,
                //                               style: Style.mockinacRegular().copyWith(letterSpacing: Dimens.d0_23, color: themeManager.colorTextWhite),
                //                               maxLines: 1,
                //                             ),
                //                           ),
                //                           Dimens.d4.spaceHeight,
                //                           Text(
                //                             "Shoorah ${_historyDataForAll[tabIndexMeSectionHistory]['type'].toString().toLowerCase()}",
                //                             style: Style.workSansRegular(fontSize: Dimens.d12, color: themeManager.colorTextWhite).copyWith(
                //                               letterSpacing: -Dimens.d0_16,
                //                             ),
                //                             maxLines: 1,
                //                             overflow: TextOverflow.ellipsis,
                //                           ),
                //                         ],
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //               Dimens.d10.spaceHeight,
                //             ],
                //           )).toList(),
                //     )
                //         : Center(
                //       child:
                //       Text(
                //         "No Data Found",
                //         style:
                //         TextStyle(fontSize: 12, color: themeManager.colorTextWhite),
                //       ),
                //     ),
                //     Dimens.d20
                //         .spaceHeight,
                //   ],
                // ),
              ],
            ),
          ),
        ),
        CustomPaint(
          painter:
          BgOvalCustomPainter(),
          size: Size(
              double.infinity,
              Dimens.d28.h),
        ),
      ],
    );
  }
}

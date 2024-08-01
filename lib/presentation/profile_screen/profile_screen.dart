import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/app_confirmation_dialog.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  ProfileController profileController = Get.put(ProfileController());
  ThemeController themeController = Get.find<ThemeController>();
  bool progressCall = false;
  List dList = ["monthly", "annually", "weekly"];
  String? selectedMonth = "monthly".tr;
  final audioPlayerController = Get.find<NowPlayingController>();
  int _selectedIndex = 0;
  String currentLanguage = PrefService.getString(PrefKey.language);

  final List<String> _tabs = ['progressTracking', 'mood', 'sleep', 'stress'];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    checkInternet();

    super.initState();
  }


  checkInternet() async {
    if (await isConnected()) {
      profileController.getUserDetail();
      profileController.getGuide();
      profileController.getPrivacy();
      profileController.getProgress("isLastMonth");
      profileController.getMoodChart();
      profileController.getSleepChart();
      profileController.getStressChart();
      setState(() {});
    } else {
      showSnackBarError(context, "noInternet".tr);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.textfieldFillColor
          : ColorConstant.colorBFD0D4,
      appBar: CustomAppBar(centerTitle: true,
        title: "profile".tr,
        showBack: false,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              const Spacer(),
              Dimens.d40.spaceHeight,
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: Get.height - 220,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: themeController.isDarkMode.value
                            ? ColorConstant.darkBackground
                            : ColorConstant.backGround,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Dimens.d300),
                        child: SvgPicture.asset(themeController.isDarkMode.isTrue
                            ? ImageConstant.profile1Dark
                            : ImageConstant.profile1),
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Dimens.d62),
                        child: SvgPicture.asset(themeController.isDarkMode.isTrue
                            ? ImageConstant.profile2Dark
                            : ImageConstant.profile2),
                      )),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Dimens.d30.spaceHeight,
                GetBuilder<ProfileController>(
                  builder: (controller) {
                    return controller.image.isEmpty
                        ? Container(
                            height: Dimens.d120,
                            width: Dimens.d120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(ImageConstant.userProfile),
                          )
                        : Container(
                            height: Dimens.d120,
                            width: Dimens.d120,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: ColorConstant.themeColor)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: CommonLoadImage(
                                height: Dimens.d120,
                                width: Dimens.d120,
                                url: controller.image.value,
                              ),
                            ),
                          );
                  },
                ),
                Dimens.d12.spaceHeight,
                Text(
                  profileController.name?.value ??
                      "melissapeters@gmail.com",
                  style: Style.montserratBold(
                    fontSize: Dimens.d14,
                  ),
                ),
                Dimens.d2.spaceHeight,
                Obx(
                  () => Text(
                    profileController.mail?.value ??
                        "melissapeters@gmail.com",
                    style: Style.nunRegular(
                      fontSize: Dimens.d11,
                    ),
                  ),
                ),
                Dimens.d40.spaceHeight,
                SizedBox(
                  height: 50,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 7),
                        height: 1,
                        color: Colors.white,
                        width: Get.width,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(_tabs.length, (index) {
                          return GestureDetector(
                            onTap: () => _onTabSelected(index),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _tabs[index].tr,
                                  style: Style.nunRegular(
                                    fontSize: 14,
                                  ),
                                ),
                                Dimens.d17.spaceHeight,
                                if (_selectedIndex == index)
                                  Container(
                                      height: 1,
                                      width: index == 0 ? 130 : 60,
                                      color: ColorConstant.themeColor)
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Dimens.d10.spaceHeight,
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                      color: themeController.isDarkMode.isTrue
                          ? ColorConstant.textfieldFillColor
                          : ColorConstant.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      _selectedIndex == 0
                          ? const SizedBox()
                          : Dimens.d13.spaceHeight,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _selectedIndex == 0
                              ? const SizedBox()
                              : Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedIndex == 1
                                          ? ColorConstant.color2E2EFF
                                          : _selectedIndex == 2
                                              ? ColorConstant.color008000
                                              : ColorConstant.colorFF0000),
                                ),
                          Dimens.d3.spaceWidth,
                          _selectedIndex == 0
                              ? const SizedBox()
                              : Text(
                                  _selectedIndex == 0
                                      ? "Progress tracking"
                                      : _selectedIndex == 1
                                          ? "Mood"
                                          : _selectedIndex == 2
                                              ? "Sleep"
                                              : "Stress"
                                                  "",
                                  style: Style.nunRegular(fontSize: 10),
                                ),
                          Dimens.d10.spaceWidth,
                        ],
                      ),
                      Dimens.d10.spaceHeight,
                      _selectedIndex == 0
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  children: [
                                    GetBuilder<ProfileController>(
                                      id: "update",
                                      builder: (controller) {
                                        return SizedBox(
                                          height: Dimens.d140,
                                          width: Dimens.d140,
                                          child: PieChart(
                                            PieChartData(
                                              sections: getSections(
                                                gValue: controller.progressModel
                                                        .data?.gratitudeCount
                                                        ?.toDouble() ??
                                                    1.0,
                                                aValue: controller.progressModel
                                                        .data?.affirmationCount
                                                        ?.toDouble() ??
                                                    10.0,
                                                pValue: controller
                                                        .progressModel
                                                        .data
                                                        ?.positiveMomentCount
                                                        ?.toDouble() ??
                                                    10.0,
                                                good: controller
                                                        .progressModel
                                                        .data
                                                        ?.positiveMomentCount
                                                        ?.toDouble() ??
                                                    10.0,
                                              ),
                                              centerSpaceRadius: 40,
                                              sectionsSpace: 0,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Dimens.d40.spaceWidth,
                                    Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  progressCall = !progressCall;
                                                });
                                              },
                                              child: Container(
                                                width: 127,
                                                height: 26,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                    color: ColorConstant
                                                        .themeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      selectedMonth!.tr,
                                                      style: Style.nunRegular(
                                                          fontSize: 12,
                                                          color: ColorConstant
                                                              .white),
                                                    ),
                                                    const Spacer(),
                                                    SvgPicture.asset(
                                                        ImageConstant
                                                            .downArrowSetting)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Dimens.d12.spaceHeight,
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorConstant
                                                        .color769AA3,
                                                  ),
                                                ),
                                                Dimens.d6.spaceWidth,
                                                Text(
                                                  "completedGratitude".tr,
                                                  style: Style.nunRegular(
                                                    fontSize: currentLanguage=="en-US"?Dimens.d9:Dimens.d8,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Dimens.d12.spaceHeight,
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorConstant
                                                        .colorBFD0D4,
                                                  ),
                                                ),
                                                Dimens.d6.spaceWidth,
                                                Text(
                                                  "positiveMoment".tr,
                                                  style: Style.nunRegular(
                                                    fontSize: currentLanguage=="en-US"?Dimens.d9:Dimens.d8,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Dimens.d12.spaceHeight,
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorConstant
                                                        .color3D5459,
                                                  ),
                                                ),
                                                Dimens.d6.spaceWidth,
                                                Text(
                                                  "completedAffirmations".tr,
                                                  style: Style.nunRegular(
                                                    fontSize: currentLanguage=="en-US"?Dimens.d9:Dimens.d8,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Dimens.d12.spaceHeight,
                                            Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorConstant
                                                        .color5A7681,
                                                  ),
                                                ),
                                                Dimens.d6.spaceWidth,
                                                Text(
                                                  "goodFeel".tr,
                                                  style: Style.nunRegular(
                                                    fontSize: currentLanguage=="en-US"?Dimens.d9:Dimens.d8,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Dimens.d12.spaceHeight,
                                          ],
                                        ),
                                        progressCall
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    top: 25),
                                                height: Dimens.d80,
                                                width: 127,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        offset:
                                                            const Offset(0, 4),
                                                        color: themeController
                                                                .isDarkMode
                                                                .value
                                                            ? ColorConstant
                                                                .transparent
                                                            : ColorConstant
                                                                .themeColor
                                                                .withOpacity(
                                                                    0.4),
                                                        blurRadius: 21.0,
                                                        spreadRadius: 0.0,
                                                      ),
                                                    ],
                                                    color: themeController
                                                            .isDarkMode.isTrue
                                                        ? ColorConstant
                                                            .darkBackground
                                                        : const Color(
                                                            0xffF3FDFD),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ListView.builder(
                                                  itemCount: dList.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          String selectedData = "${dList[index]}"
                                                                      .tr ==
                                                                  "monthly".tr
                                                              ? "isLastMonth"
                                                              : "${dList[index]}"
                                                                          .tr ==
                                                                      "weekly"
                                                                          .tr
                                                                  ? "isLastWeek"
                                                                  : "isLastYear";
                                                          await profileController
                                                              .getProgress(
                                                                  selectedData);

                                                          setState(() {
                                                selectedMonth =
                                                dList[index];
                                                progressCall =
                                                false;
                                              });
                                                        },
                                                        child: Text(
                                                          "${dList[index]}".tr,
                                                          style:
                                                              Style.nunRegular(
                                                                  fontSize: 10),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : GetBuilder<ProfileController>(
                              builder: (controller) {
                                return Container(
                                  height: 131,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(labelStyle: Style.nunitoSemiBold(fontSize:11,color:ColorConstant.color949494  ),
                                  majorGridLines:
                                          const MajorGridLines(width: 0),
                                    ),
                                    primaryYAxis: NumericAxis(
                                  labelStyle: Style.nunitoSemiBold(fontSize:11,color:ColorConstant.color949494  ),
                                  majorGridLines:
                                          const MajorGridLines(width: 0),
                                    ),
                                    legend: Legend(isVisible: false ),plotAreaBorderColor: Colors.transparent,

                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <LineSeries<MoodData, String>>[
                                  LineSeries<MoodData, String>(
                                    color: _selectedIndex == 1
                                        ? ColorConstant.color2E2EFF
                                        : _selectedIndex == 2
                                                ? ColorConstant.color008000
                                                : ColorConstant.colorFF0000,
                                        dataSource: _selectedIndex == 1
                                            ? getMoodData(
                                                mon: controller.moodChartModel
                                                        .data?[0].averageFeeling
                                                        ?.toDouble() ??
                                                    0.0,
                                                tue: controller.moodChartModel
                                                        .data?[1].averageFeeling
                                                        ?.toDouble() ??
                                                    0.0,
                                                wed: controller.moodChartModel
                                                        .data?[2].averageFeeling
                                                        ?.toDouble() ??
                                                    0.0,
                                                thu: controller.moodChartModel
                                                        .data?[3].averageFeeling
                                                        ?.toDouble() ??
                                                    0.0,
                                                fri: controller.moodChartModel
                                                        .data?[4].averageFeeling
                                                        ?.toDouble() ??
                                                    0.0,
                                                sat: controller.moodChartModel
                                                        .data?[5].averageFeeling
                                                        ?.toDouble() ??
                                                    0.0,
                                                sun: controller.moodChartModel
                                                        .data?[6].averageFeeling
                                                        ?.toDouble() ??
                                                    0.0,
                                              )
                                            : _selectedIndex == 2
                                                ? getMoodData(
                                                    mon: controller
                                                            .sleepChartModel
                                                            .data?[0]
                                                            .averageSleep
                                                            ?.toDouble() ??
                                                        0.0,
                                                    tue: controller
                                                            .sleepChartModel
                                                            .data?[1]
                                                            .averageSleep
                                                            ?.toDouble() ??
                                                        0.0,
                                                    wed: controller
                                                            .sleepChartModel
                                                            .data?[2]
                                                            .averageSleep
                                                            ?.toDouble() ??
                                                        0.0,
                                                    thu: controller
                                                            .sleepChartModel
                                                            .data?[3]
                                                            .averageSleep
                                                            ?.toDouble() ??
                                                        0.0,
                                                    fri: controller
                                                            .sleepChartModel
                                                            .data?[4]
                                                            .averageSleep
                                                            ?.toDouble() ??
                                                        0.0,
                                                    sat: controller
                                                            .sleepChartModel
                                                            .data?[5]
                                                            .averageSleep
                                                            ?.toDouble() ??
                                                        0.0,
                                                    sun: controller
                                                            .sleepChartModel
                                                            .data?[6]
                                                            .averageSleep
                                                            ?.toDouble() ??
                                                        0.0,
                                                  )
                                                : getMoodData(
                                                    mon: controller
                                                            .stressChartModel
                                                            .data?[0]
                                                            .averageStress
                                                            ?.toDouble() ??
                                                        0.0,
                                                    tue: controller
                                                            .stressChartModel
                                                            .data?[1]
                                                            .averageStress
                                                            ?.toDouble() ??
                                                        0.0,
                                                    wed: controller
                                                            .stressChartModel
                                                            .data?[2]
                                                            .averageStress
                                                            ?.toDouble() ??
                                                        0.0,
                                                    thu: controller
                                                            .stressChartModel
                                                            .data?[3]
                                                            .averageStress
                                                            ?.toDouble() ??
                                                        0.0,
                                                    fri: controller
                                                            .stressChartModel
                                                            .data?[4]
                                                            .averageStress
                                                            ?.toDouble() ??
                                                        0.0,
                                                    sat: controller
                                                            .stressChartModel
                                                            .data?[5]
                                                            .averageStress
                                                            ?.toDouble() ??
                                                        0.0,
                                                    sun: controller
                                                            .stressChartModel
                                                            .data?[6]
                                                            .averageStress
                                                            ?.toDouble() ??
                                                        0.0,
                                                  ),
                                        xValueMapper: (MoodData mood, _) =>
                                            mood.day,
                                        yValueMapper: (MoodData mood, _) =>
                                            mood.value,
                                        name: 'Mood',
                                        width: 1,
                                        dataLabelSettings: const DataLabelSettings(
                                        isVisible: false),
                                  )
                                ],
                              ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
                Dimens.d25.spaceHeight,
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.settingScreen)!.then((value) {
                      profileController.getUserDetail();
                      setState(() {
                      });
                    },);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode.value
                          ? ColorConstant.textfieldFillColor
                          : ColorConstant.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.d10,
                      vertical: Dimens.d5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Dimens.d12.spaceWidth,
                        Expanded(
                          child: Text(
                            "settings".tr,
                            style: Style.nunMedium().copyWith(
                              fontSize: 13,
                              letterSpacing: Dimens.d0_16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                              ImageConstant.settingArrowRight,
                              color: themeController.isDarkMode.value
                                  ? ColorConstant.white
                                  : ColorConstant.black),
                        )
                      ],
                    ),
                  ),
                ),
                Dimens.d29.spaceHeight,
                GestureDetector(
                  onTap: () {
                    showAppConfirmationDialog(themeController: themeController,
                      context: context,
                      message: "areYouSureWantToLogout?".tr,
                      primaryBtnTitle: "no".tr,
                      secondaryBtnTitle: "yes".tr,
                      secondaryBtnAction: () {
                        RegisterController registerController =
                            Get.put(RegisterController());
                        registerController.nameController.clear();
                        registerController.emailController.clear();
                        registerController.passwordController.clear();
                        registerController.dobController.clear();
                        registerController.genderController.clear();
                        registerController.imageFile.value = null;

                        if (PrefService.getBool(PrefKey.isRemember) ==
                            false) {
                          LoginController loginController =
                              Get.put(LoginController());
                          loginController.emailController.clear();
                          loginController.passwordController.clear();
                          loginController.rememberMe.value = false;
                        }

                        Get.offAllNamed(AppRoutes.loginScreen);
                        PrefService.setValue(
                            PrefKey.isLoginOrRegister, false);
                      },
                    );
                  },
                  child: Container(
                    height: Dimens.d40,
                    width: 176,
                    decoration: BoxDecoration(
                        color: ColorConstant.themeColor,
                        borderRadius: BorderRadius.circular(85)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(ImageConstant.logOut),
                        Dimens.d10.spaceWidth,
                        Text(
                          "logout".tr,
                          style: Style.nunMedium(
                              fontSize: 13, color: ColorConstant.white),
                        )
                      ],
                    ),
                  ),
                ),
                Dimens.d50.spaceHeight,
              ],
            ),
          ),
          Obx(() {
            if (!audioPlayerController.isVisible.value) {
              return const SizedBox.shrink();
            }

            final currentPosition =
                audioPlayerController.positionStream.value ?? Duration.zero;
            final duration =
                audioPlayerController.durationStream.value ?? Duration.zero;
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
                );              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 72,
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
                              style: Style.nunRegular(
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
                      Dimens.d8.spaceHeight,
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor:
                          ColorConstant.white.withOpacity(0.2),
                          inactiveTrackColor: ColorConstant.color6E949D,
                          trackHeight: 1.5,
                          thumbColor: ColorConstant.transparent,
                          thumbShape: SliderComponentShape.noThumb,
                          overlayColor: ColorConstant.backGround.withAlpha(32),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius:
                              16.0), // Customize the overlay shape and size
                        ),
                        child: SizedBox(
                          height: 2,
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
                      ),
                      Dimens.d5.spaceHeight,
                    ],
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  List<MoodData> getMoodData({
    double? mon,
    double? tue,
    double? wed,
    double? thu,
    double? fri,
    double? sat,
    double? sun,
  }) {
    return [
      MoodData('MON', mon!),
      MoodData('TUE', tue!),
      MoodData('WED', wed!),
      MoodData('THU', thu!),
      MoodData('FRI', fri!),
      MoodData('SAT', sat!),
      MoodData('SUN', sun!),
      /*   MoodData('MON',_selectedIndex == 1?   7.0:_selectedIndex == 2?6.9:7.0),
      MoodData('TUE',_selectedIndex == 1?   6.3:_selectedIndex == 2?6.2:6.2),
      MoodData('WED', _selectedIndex == 1?  6.7:_selectedIndex == 2?6.3:6.3),
      MoodData('THU', _selectedIndex == 1?  6.2:_selectedIndex == 2?6.4:6.4),
      MoodData('FRI', _selectedIndex == 1?  6.5:_selectedIndex == 2?6.5:6.5),
      MoodData('SAT',_selectedIndex == 1?   6.1:_selectedIndex == 2?6.6:6.6),
      MoodData('SUN', _selectedIndex == 1?  6.8:_selectedIndex == 2?6.7:6.2),*/
    ];
  }
}

List<PieChartSectionData> getSections(
    {double? gValue, double? pValue, double? aValue, double? good}) {
  return [
    PieChartSectionData(
      color: ColorConstant.color769AA3,

        value: gValue==0.0?0.2:gValue,
        title: '$gValue',
        radius: 40,
        titleStyle:  Style.montserratBold(
            fontSize: 12,
            color: ColorConstant.black),
      ),
      PieChartSectionData(
        color: ColorConstant.colorBFD0D4,
        value: pValue==0.0?0.2:pValue,
        title: '$pValue',
        radius: 40,
        titleStyle:  Style.montserratBold(
    fontSize: 12,
    color: ColorConstant.black),
      ),
      PieChartSectionData(
        color: ColorConstant.color3D5459,
        value:aValue==0.0?0.2:aValue,
        title: '$aValue',
        radius: 40,
        titleStyle:  Style.montserratBold(
            fontSize: 12,
            color: ColorConstant.black),
      ),
      PieChartSectionData(
        color: ColorConstant.color5A7681,
        value:good==0.0?0.2:good,
        title: '$good',
        radius: 40,
        titleStyle:  Style.montserratBold(
            fontSize: 12,
            color: ColorConstant.black),
      ),
    ];
  }

class MoodData {
  MoodData(this.day, this.value);

  final String day;
  final double value;
}
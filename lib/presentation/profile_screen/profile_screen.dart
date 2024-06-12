import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/app_confirmation_dialog.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController = Get.put(ProfileController());
  ThemeController themeController = Get.find<ThemeController>();
  bool progressCall = false;
  List dList = ["Monthly", "Annually", "Weekly"];
  String? selectedMonth = "Monthly";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorBFD0D4,
      appBar: CustomAppBar(
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
                            ? ColorConstant.textfieldFillColor
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
                        child: SvgPicture.asset(ImageConstant.profile1),
                      )),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Dimens.d62),
                        child: SvgPicture.asset(ImageConstant.profile2),
                      )),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: Dimens.d30),
                  height: Dimens.d120,
                  width: Dimens.d120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://picsum.photos/250?image=9")),
                      border: Border.all(
                          color: ColorConstant.themeColor, width: 2)),
                ),
                Dimens.d12.spaceHeight,
                Text(
                  "Melissa peters",
                  style: Style.montserratBold(
                    fontSize: Dimens.d14,
                  ),
                ),
                Dimens.d2.spaceHeight,
                Obx(
                  () => Text(
                    profileController.mail?.value ??
                        "melissapeters@gmail.com",
                    style: Style.montserratRegular(
                      fontSize: Dimens.d10,
                    ),
                  ),
                ),
                Dimens.d40.spaceHeight,
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "progressTracking".tr,
                      style: Style.montserratRegular(
                        fontSize: Dimens.d20,
                      ),
                    ),
                  ),
                ),
                Dimens.d25.spaceHeight,
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 30),
                  decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            height: Dimens.d140,
                            width: Dimens.d140,
                            child: PieChart(
                              dataMap: const {
                                "Total Hours Spent": 50.0,
                                "journal entries": 20.0,
                                "Completed Affirmations": 30.0,
                              },
                              animationDuration:
                                  const Duration(milliseconds: 800),
                              colorList: const [
                                ColorConstant.colorBFD0D4,
                                ColorConstant.themeColor,
                                ColorConstant.color3D5459,
                                ColorConstant.colorBDDBE5,
                              ],
                              initialAngleInDegree: 20,
                              chartType: ChartType.ring,
                              ringStrokeWidth: 40,
                              legendOptions: LegendOptions(
                                showLegendsInRow: false,
                                // legendPosition: LegendPosition.right,
                                showLegends: false,
                                legendShape: BoxShape.circle,
                                legendTextStyle: Style.montserratRegular(
                                  fontSize: Dimens.d9,
                                ),
                              ),
                              chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: false,
                                  showChartValues: false,
                                  chartValueStyle: Style.montserratRegular(
                                      fontSize: Dimens.d15,
                                      color: ColorConstant.black),
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 0,
                                  chartValueBackgroundColor:
                                      Colors.transparent),
                            ),
                          ),
                          Dimens.d40.spaceWidth,
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: ColorConstant.themeColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            selectedMonth!,
                                            style: Style.montserratRegular(
                                                fontSize: 12,
                                                color: ColorConstant.white),
                                          ),
                                          const Spacer(),
                                          SvgPicture.asset(
                                              ImageConstant.downArrowSetting)
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
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstant.colorBFD0D4,
                                        ),
                                      ),
                                      Dimens.d6.spaceWidth,
                                      Text(
                                        "Completed Gratitude".tr,
                                        style: Style.montserratRegular(
                                          fontSize: Dimens.d9,
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
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstant.color3D5459,
                                        ),
                                      ),
                                      Dimens.d6.spaceWidth,
                                      Text(
                                        "journalEntries".tr,
                                        style: Style.montserratRegular(
                                          fontSize: Dimens.d9,
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
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstant.colorBDDBE5,
                                        ),
                                      ),
                                      Dimens.d6.spaceWidth,
                                      Text(
                                        "completedAffirmations".tr,
                                        style: Style.montserratRegular(
                                          fontSize: Dimens.d9,
                                        ),
                                      )
                                    ],
                                  ),
                                  Dimens.d12.spaceHeight,
                                ],
                              ),
                              progressCall
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      height: Dimens.d80,
                                      width: 127,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? ColorConstant.transparent
                                                  : ColorConstant.color8BA4E5
                                                      .withOpacity(0.25),
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                          color: const Color(0xffF3FDFD),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListView.builder(
                                        itemCount: dList.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                            child: GestureDetector( onTap: () {
                                              setState(() {
                                                selectedMonth =  dList[index];
                                                progressCall = false;
                                              });
                                            },
                                              child: Text(
                                                dList[index],
                                                style: Style.montserratRegular(
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
                  ),
                ),
                Dimens.d25.spaceHeight,
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.settingScreen);
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
                            style: Style.montserratMedium().copyWith(
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
                    showAppConfirmationDialog(
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
                    width: Dimens.d170,
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
                          style: Style.montserratMedium(
                              fontSize: 12, color: ColorConstant.white),
                        )
                      ],
                    ),
                  ),
                ),
                Dimens.d50.spaceHeight,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

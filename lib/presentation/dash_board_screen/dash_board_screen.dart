import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_screen.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_controller.dart';
import 'package:transform_your_mind/presentation/home_screen/home_screen.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_screen.dart';
import 'package:transform_your_mind/presentation/search_screen/search_screen.dart';
import 'package:transform_your_mind/presentation/tools_screen/tools_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  DashBoardController dashBoardController = Get.put(DashBoardController());
  ThemeController themeController = Get.put(ThemeController());
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if(index != 2) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const ToolsScreen(),
    Container(),
    const AudioContentScreen(),
    const ProfileScreen(),
  ];
  @override
  void initState() {
/*    if (themeController.isDarkMode.isTrue) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ));
    }*/
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return false;
      },
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: FloatingActionButton(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SearchScreen();
              },));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  ImageConstant.floatting,
                  height: 100,
                  width: 100,
                ),
                SvgPicture.asset(
                  ImageConstant.sFloatting,
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color:themeController.isDarkMode.value ? ColorConstant.textfieldFillColor :ColorConstant.white ,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color:themeController.isDarkMode.value ?Colors.transparent: ColorConstant.themeColor.withOpacity(0.8),
                blurRadius: Dimens.d28,
                offset: const Offset(1, 1),
                spreadRadius: 1,
              ),
            ],
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkHomeDeselected:ImageConstant.homeUnSelected,
                  height: Dimens.d20,
                  width: Dimens.d20,
                ),
                label: 'home'.tr,
                activeIcon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkHomeSelected: ImageConstant.homeSelected,
                  height: Dimens.d20,
                  width: Dimens.d20,
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkToolDeSelected: ImageConstant.toolsUnSelected,
                  height: Dimens.d20,
                  width: Dimens.d20,
                ),
                label: 'tools'.tr,
                activeIcon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkToolSelected: ImageConstant.toolsSelected,
                  height: Dimens.d20,
                  width: Dimens.d20,
                ),
              ),
              BottomNavigationBarItem(
                icon: Visibility(
                  visible: false,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: SvgPicture.asset(
                    ImageConstant.toolsUnSelected,
                    height: Dimens.d20,
                    width: Dimens.d20,
                  ),
                ),
                label: ''.tr,
                activeIcon: Visibility(
                  visible: false,
                  maintainState: true,
                  maintainSize: true,
                  maintainAnimation: true,
                  child: SvgPicture.asset(
                    ImageConstant.toolsSelected,
                    height: Dimens.d20,
                    width: Dimens.d20,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkExploreDeselected:ImageConstant.exploreDeSelected,
                  height: Dimens.d20,
                  width: Dimens.d20,
                ),
                label: 'audioContent'.tr,
                activeIcon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkExploreSelected: ImageConstant.exploreSelected,
                  height: Dimens.d20,
                  width: Dimens.d20,
                  fit: BoxFit.fill,
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkMeDeselected:ImageConstant.meSelected,
                  height: Dimens.d20,
                  width: Dimens.d20,
                ),
                label: 'me'.tr,
                activeIcon: SvgPicture.asset(
                  themeController.isDarkMode.isTrue?ImageConstant.darkMeSelected: ImageConstant.profileIcon,
                  height: Dimens.d20,
                  width: Dimens.d20,
                  fit: BoxFit.fill,
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedIconTheme: const IconThemeData(color: Colors.black),
            unselectedIconTheme: const IconThemeData(color: Colors.black),
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            selectedFontSize: Dimens.d12,
            unselectedFontSize: Dimens.d12,
            selectedLabelStyle: Style.montserratSemiBold(
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.white
                  : ColorConstant.black,
              fontSize: Dimens.d10,
            ),
            showUnselectedLabels: true,
            unselectedLabelStyle: Style.montserratRegular(
              color: themeController.isDarkMode.isTrue
                  ? ColorConstant.white
                  : ColorConstant.black,
              fontSize: Dimens.d10,
            ),
            onTap: (v){
              if(v !=2)
                {
                  _onItemTapped(v);
                }
            },
            showSelectedLabels: true,
            useLegacyColorScheme: false,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_controller.dart';
import 'package:transform_your_mind/presentation/explore_screen/explore_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/home_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/me_screen.dart';
import 'package:transform_your_mind/presentation/tools_screen/tools_screen.dart';

class DashBoardScreen extends StatefulWidget {
   DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  DashBoardController dashBoardController = Get.put(DashBoardController());

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  final List<Widget> pages = [
    const HomeScreen(),
    const ToolsScreen(),
     ExploreScreen(),
    const MeScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.13),
                  blurRadius: Dimens.d28,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.13),
                    blurRadius: Dimens.d28,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                items: [
                  BottomNavigationBarItem(backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      ImageConstant.homeSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                    ),
                    label: 'Home',
                    activeIcon: SvgPicture.asset(
                      ImageConstant.homeSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      ImageConstant.toolsSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                    ),
                    label: 'Tools',
                    activeIcon: SvgPicture.asset(
                      ImageConstant.toolsSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      ImageConstant.exploreSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                    ),
                    label: 'Explore',
                    activeIcon: SvgPicture.asset(
                      ImageConstant.exploreSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                      fit: BoxFit.fill,
                    ),
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      ImageConstant.meSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                    ),
                    label: 'Me',
                    activeIcon: SvgPicture.asset(
                      ImageConstant.meSelected,
                      height: Dimens.d20,
                      width: Dimens.d20,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedIconTheme: const IconThemeData(color: Colors.black),
                unselectedIconTheme: const IconThemeData(color: Colors.black),
                selectedItemColor:Colors.black,
                unselectedItemColor: Colors.grey,
                selectedFontSize: Dimens.d12,
                unselectedFontSize: Dimens.d12,
                selectedLabelStyle: Style.cormorantGaramondMedium(
                  color: Colors.black,
                  fontSize: Dimens.d12,
                ),
                showUnselectedLabels: true,
                unselectedLabelStyle: Style.cormorantGaramondMedium(
                  color: Colors.black,
                  fontSize: Dimens.d12,
                ),
                onTap: _onItemTapped,
                showSelectedLabels: true,useLegacyColorScheme: false,
                type: BottomNavigationBarType.fixed,

              ),
            ),
          ),
          backgroundColor: ColorConstant.white,
          body: Column(
            children: [
              Expanded(
                child: pages[_selectedIndex],
              ),
            ],
          ),
        ), );
  }
}

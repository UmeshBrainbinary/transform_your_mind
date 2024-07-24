import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [

          Dimens.d320.spaceHeight,
          Text(
            "dailyMindfulness".tr,
            style: Style.gothamMedium(
              fontWeight: FontWeight.w600,
              fontSize: Dimens.d28,
              color: ColorConstant.black,
            ),
          ),
          Dimens.d30.spaceHeight,
          Text(
            "yourKey".tr,
            style: Style.gothamLight(
                fontSize: Dimens.d19,
                color: ColorConstant.black,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          Dimens.d320.spaceHeight,
          Text(
            "scienceConfirms".tr,
            style: Style.gothamMedium(
              fontWeight: FontWeight.w600,
              fontSize: Dimens.d28,
              color: ColorConstant.black,
            ),
          ),
          Dimens.d30.spaceHeight,
          Text(
            "studiesSuggest".tr,
            style: Style.gothamLight(
                fontSize: Dimens.d19,
                color: ColorConstant.black,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          Dimens.d320.spaceHeight,
          Text(
            "happyWake".tr,
            style: Style.gothamMedium(
              fontWeight: FontWeight.w600,
              fontSize: Dimens.d28,
              color: ColorConstant.black,
            ),
          ),
          Dimens.d30.spaceHeight,
          Text(
            "boostDay".tr,
            style: Style.gothamLight(
                fontSize: Dimens.d19,
                color: ColorConstant.black,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          Dimens.d320.spaceHeight,
          Text(
            "transformationSubconscious".tr,
            textAlign: TextAlign.center,
            style: Style.gothamMedium(
              fontWeight: FontWeight.w600,
              fontSize: Dimens.d28,
              color: ColorConstant.black,
            ),
          ),
          Dimens.d30.spaceHeight,
          Text(
            "unleashYour".tr,
            style: Style.gothamLight(
                fontSize: Dimens.d19,
                color: ColorConstant.black,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        children: [
          Dimens.d320.spaceHeight,
          Text(
            "21Days".tr,
            textAlign: TextAlign.center,
            style: Style.gothamMedium(
              fontWeight: FontWeight.w600,
              fontSize: Dimens.d28,
              color: ColorConstant.black,
            ),
          ),
          Dimens.d30.spaceHeight,
          Text(
            "thereAreNumerous".tr,
            style: Style.gothamLight(
                fontSize: Dimens.d19,
                color: ColorConstant.black,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
    Get.toNamed(AppRoutes.loginPreviewScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.topCenter,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Image.asset(ImageConstant.descriptionImage,height: 254,width: 300,),
          ),

          Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Dimens.d130),
                  child: DotsIndicator(
                    position: _currentPage,
                    dotsCount: _pages.length, // Number of pages
                    decorator: DotsDecorator(
                      color: ColorConstant.colorD9D9D9,
                      size: const Size.square(9.0),
                      activeSize: const Size(40.0, 8.0),
                      activeColor: ColorConstant.themeColor,
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),

                      spacing: const EdgeInsets.only(
                          right: 5.0), // Adjust spacing between dots (optional)
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 36),
                  child: CommonElevatedButton(title: "next".tr, onTap: _onNext),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_preview_view.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/personalisations_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  PersonalizationController personalizationController =
      Get.put(PersonalizationController());
  List _images = [];
  String currentLanguage = PrefService.getString(PrefKey.language);

  void _onNext() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const LoginPreviewView();
        },
      ));
    }
  }

  void _onSkip() {


    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const LoginPreviewView();
      },
    ));
  }

  bool checkInternetCheck = false;
  @override
  void initState() {
    checkInternet();
    super.initState();
  }



  checkInternet() async {
    if (await isConnected()) {
      await personalizationController.getScreen();

      setState(() {
        checkInternetCheck = true;
      });

      setState(() {
        if(currentLanguage == "en-US"|| currentLanguage == ""){
          _images = [
            {
              "title":  personalizationController.getScreenModel.data?[1].quote
                  .toString()??"",
              "img": personalizationController.getScreenModel.data?[1].image ?? "",
              "authName":  personalizationController
                  .getScreenModel.data?[1].authorName ?? "",
            },
            {
              "title": personalizationController.getScreenModel.data?[2].quote,
              "img": personalizationController.getScreenModel.data?[2].image ?? "",
              "authName":  personalizationController
                  .getScreenModel.data?[2].authorName ?? "",
            },
            {
              "title": personalizationController.getScreenModel.data?[3].quote,
              "img": personalizationController.getScreenModel.data?[3].image ?? "",
              "authName":  personalizationController
                  .getScreenModel.data?[3].authorName ?? "",
            },
          ];
        }else{
          _images = [
            {
              "title":  personalizationController.getScreenModel.data![1].gQuote
                  .toString(),
              "img": personalizationController.getScreenModel.data?[1].image ?? "",
              "authName":  personalizationController
                  .getScreenModel.data?[1].gAuthorName ?? "",
            },
            {
              "title": personalizationController.getScreenModel.data?[2].gQuote,
              "img": personalizationController.getScreenModel.data?[2].image ?? "",
              "authName":  personalizationController
                  .getScreenModel.data?[2].gAuthorName ?? "",
            },
            {
              "title": personalizationController.getScreenModel.data?[3].gQuote,
              "img": personalizationController.getScreenModel.data?[3].image ?? "",
              "authName":  personalizationController
                  .getScreenModel.data?[3].gAuthorName ?? "",
            },
          ];
        }

      });
    } else {
      setState(() {
        checkInternetCheck = false;
        _images = [
          {"title": "toBeSuccessful", "img": 'assets/images/intro1.png'},
          {"title": "theSecret", "img": 'assets/images/intro2.png'},
          {"title": "peopleWithGoals", "img": 'assets/images/intro3.png'},
        ];
      });
      showSnackBarError(Get.context!, "noInternet".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              ///__________________________ close auto scroll _____________________
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  checkInternetCheck
                      ? Image.network(
                          _images[index]["img"],
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Image.asset(
                          _images[index]["img"],
                          fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 36, right: 36, top: Get.height * 0.51),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_images[index]["title"]}".tr,
                          textAlign: TextAlign.center,
                          style: Style.nunitoBold(
                              fontSize: currentLanguage.isNotEmpty?19:22, color: ColorConstant.white),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                           _images[index]["authName"] ??
                                "",
                            textAlign: TextAlign.center,
                            style: Style.nunitoSemiBold(
                                fontSize: 13, color: ColorConstant.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _onSkip,
              child:  Text(
                'Skip',
                style: Style.nunMedium(
                    fontSize: Dimens.d16,color: ColorConstant.black),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 36),
              child: CommonElevatedButton(
                  title: "next".tr, onTap:_onNext),
            ),
          ),
        ],
      ),
    );
  }
}

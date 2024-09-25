import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/http_service.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/week_data_model.dart';
import 'package:transform_your_mind/presentation/start_pratice_affirmation/start_practice_affirmation_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';

class AffirmationGreatWork extends StatefulWidget {
  String? theme;
   AffirmationGreatWork({super.key,this.theme});

  @override
  State<AffirmationGreatWork> createState() => _AffirmationGreatWorkState();
}

class _AffirmationGreatWorkState extends State<AffirmationGreatWork> {
  StartPracticeAffirmationController startController =
      Get.put(StartPracticeAffirmationController());
  late ConfettiController _controllerCenter;
  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerTopCenter;
  late ConfettiController _controllerBottomCenter;
  List<WeekDataList>? weekList = [];

  @override
  void initState() {
    checkInternet();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    _controllerCenter.play();

    super.initState();
  }
  checkInternet() async {
    if (await isConnected()) {
      await getWeeklyData();
    } else {
    showSnackBarError(context, "noInternet".tr);
    }
  }
  WeekDataModel weekDataModel = WeekDataModel();
  getWeeklyData() async {
    try{
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              '${EndPoints.weeklyAffirmation}${PrefService.getString(PrefKey.userId)}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        weekDataModel = weekDataModelFromJson(responseBody);
        weekList =weekDataModel.data;

        setState(() {

        });

    }
    else {
        debugPrint(response.reasonPhrase);
    }

    }catch(e){
      debugPrint(e.toString());
    }
  }
  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body:
      ConfettiWidget(
        blastDirectionality: BlastDirectionality.explosive,

        createParticlePath: (size) {
          final random = Random();
          return random.nextBool() ? _starPath(size) : _ribbonPath(size); // Randomly choose between star and ribbon
        },
        emissionFrequency: 0.05,
        numberOfParticles: 10,
        colors: const [
          Color(0xffB8860B),
          Color(0xffC0C0C0),
          Color(0xffD3D3D3)],
        confettiController: _controllerCenter,
        child:
        GestureDetector(
          onTap: () {},
          child: Stack(
            children: [
              //_________________________________ background Image _______________________
              Stack(
                children: [
                  CachedNetworkImage(
                    height: Get.height,
                    width: Get.width,
                    imageUrl:
                    widget.theme??"https://transformyourmind.s3.eu-north-1.amazonaws.com/1719464225736-Rectangle 5781.png",
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
                      height: Get.height,
                      width: Get.width,
                      borderRadius: 10.0,
                    ),
                    errorWidget: (context, url, error) => PlaceHolderCNI(
                      height: Get.height,
                      width: Get.width,
                      isShowLoader: false,
                      borderRadius: 8.0,
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    // Adjust the sigmaX and sigmaY values to control the blur intensity
                    child: Container(
                      height: Get.height,
                      width: Get.width,
                      color: Colors.black.withOpacity(
                          0.5), // Adjust the opacity to your preference
                    ),
                  ),
                ],
              ),

              //_________________________________ close button  _______________________

              Positioned(
                top: Dimens.d70,
                left: 16,
                child: GestureDetector(
                  onTap: () async {
                    await startController.player.pause();
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: ColorConstant.white.withOpacity(0.15)),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              //_________________________________ theme Change button  _______________________

              Positioned(
                  top: Dimens.d140,

                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        "greatWork".tr,
                        style: Style.nunitoBold(
                            fontSize: 30, color: ColorConstant.white),
                      )),
                      Dimens.d8.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(width: Get.width-50,
                          child: Text(
                            "YouCompleted".tr,
                            textAlign: TextAlign.center,
                            style: Style.nunRegular(
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                color: ColorConstant.white),
                          ),
                        ),
                      ),

                      Dimens.d40.spaceHeight,
                      Container(
                        width: 300,
                        height: 1,
                        color: ColorConstant.white,
                      ),
                      Dimens.d60.spaceHeight,
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: SizedBox(
                          height: 120,
                          width: Get.width-25,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: weekList!.length,
                            itemBuilder: (context, index) {
                              bool isToday = startController.currentDayIndex == index + 1;
                              bool isPast = index < startController.currentDayIndex - 1;
                              bool isFuture = index > startController.currentDayIndex - 1;
                              return Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  children: [
                                    isToday
                                        ? Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                        : isPast&&weekList![index].isCompleted!? Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ):isFuture?Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white)),
                                    ):Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorConstant.themeColor),
                                    ),
                                    Dimens.d6.spaceHeight,
                                    Text(
                                      weekList![index].day!,
                                      style: Style.nunRegular(
                                          fontSize: 14, color: ColorConstant.white),
                                    ),
                                    startController.currentDayIndex == index + 1
                                        ? Container(
                                      height: 4,
                                      width: 4,
                                      decoration: const BoxDecoration(
                                          color: ColorConstant.themeColor,
                                          shape: BoxShape.circle),
                                    )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )),

            ],
          ),
        ), // Your widget here
      ),
    );
  }

  commonText(text) {
    return Text(
      text,
      style: Style.nunRegular(
          fontSize: 14, color: ColorConstant.white.withOpacity(0.5)),
    );
  }

  commonTextTitle(text) {
    return Text(
      text,
      style: Style.nunRegular(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: ColorConstant.white),
    );
  }

  Path _starPath(Size size) {
    final path = Path();
    const points = 5; // Number of points on the star
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < points * 2; i++) {
      final isOuter = i % 2 == 0;
      final angle = (i * 360 / (points * 2)) * (3.1415927 / 180);
      final radiusOffset = isOuter ? radius : radius * 0.5;
      final x = center.dx + radiusOffset * cos(angle);
      final y = center.dy + radiusOffset * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _ribbonPath(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final ribbonWidth = width / 6;

    // Draw a ribbon-like shape
    path.moveTo(0, height / 2);
    path.lineTo(width, height / 2);
    path.lineTo(width - ribbonWidth, height / 2 + ribbonWidth);
    path.lineTo(ribbonWidth, height / 2 + ribbonWidth);
    path.close();

    return path;
  }

}

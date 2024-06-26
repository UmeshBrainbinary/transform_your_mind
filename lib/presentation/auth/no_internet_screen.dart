import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/downloaded_pods_screen/downloaded_pods_screen.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: ColorConstant.backGround,
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dimens.d30.spaceHeight,
            GestureDetector(onTap: () {
           Get.to(const DownloadedPodsScreen());
            },child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Align(alignment: Alignment.topRight,child: SvgPicture.asset(ImageConstant.download)),
            )),
            const Spacer(),
            Image.asset(ImageConstant.noInternet,color: ColorConstant.themeColor,scale: 4.5,),
            const SizedBox(height: 25,),
            Text("Whoops".tr,style:Style.montserratRegular(fontSize: 15)),
            const SizedBox(height: 20,),
            Text("noInternet".tr,textAlign: TextAlign.center,style: Style.montserratRegular(fontSize: 18)),
            const SizedBox(height: 25,),
            InkWell(
                onTap: onTap,
                child: Text("tryAgain".tr,style: Style.montserratRegular(fontSize: 24)),),
            const Spacer(),

          ],
        ),
      ),
    );
  }
}

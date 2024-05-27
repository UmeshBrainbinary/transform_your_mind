import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';


class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: Stack(
          children: [
           Container(
             height: 100,
             width: 100,
             decoration: BoxDecoration(
               color: Colors.amber,
               borderRadius: BorderRadius.circular(30),
             ),
           ),
           Align(
             alignment: Alignment.bottomCenter,
             child:  ClipPath(
               clipper: BgSemiCircleClipPath(),
               child: Container(
                 height: Get.height * 0.7,
                 decoration: BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage(ImageConstant.bgImagePlaying),
                         fit: BoxFit.cover
                     )
                 ),
               ),
             ),
           ),
            Container(
              height: Dimens.d100,
              padding: EdgeInsets.only(top:  Dimens.d30),
              child: CustomAppBar(
                title: "Now Playing",
                leading: Icon(Icons.close),
                action: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {

                      },
                      child: SvgPicture.asset(
                        height: 20.h,
                        ImageConstant.share,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {

                      },
                      child: SvgPicture.asset(
                        height: 20.h,
                        ImageConstant.bookmark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}


class BgSemiCircleClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    final gap = size.height / 12;

    path.lineTo(0.0, gap);
    var firstControlPoint = Offset(size.width / 2, -gap / 2);
    var firstPoint = Offset(size.width, gap);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstPoint.dx,
      firstPoint.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


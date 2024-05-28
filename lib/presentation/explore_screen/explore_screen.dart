import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/explore_screen/explore_controller.dart';
import 'package:transform_your_mind/presentation/explore_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/explore_screen/widget/home_app_bar.dart';

import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_image_view.dart';

class ExploreScreen extends StatelessWidget {
   ExploreScreen({super.key});

   final ExploreController exploreController = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        floatingActionButton: ValueListenableBuilder(
          valueListenable: exploreController.showScrollTop,
          builder: (context, value, child) {
            return InkWell(
              onTap: (){
                exploreController.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                );


                  exploreController.isScrollingOrNot.value = false;

              },
              child: Container(
                height: Dimens.d60,
                width: Dimens.d60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstant.colorBFD0D4,
                ),
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstant.themeColor,
                  ),
                  child: Transform.scale(
                    scale: 0.35,
                    child: SvgPicture.asset(
                      ImageConstant.upArrow,
                      height: Dimens.d20.h,
                      color: ColorConstant.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        body: Stack(
          children: [

            Align(
              alignment: Alignment(1,0),
              child: SvgPicture.asset(ImageConstant.bgVector, height: Dimens.d230.h),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: constraint.maxHeight),
                    child:  IntrinsicHeight(
                      child: Column(
                        children: [
                          Dimens.d30.h.spaceHeight,
                          HomeAppBar(
                            title: "explore".tr,
                          ),
                          Dimens.d30.h.spaceHeight,
                          ShoorahRitualsButton(),
                          Dimens.d20.h.spaceHeight,
                         Expanded(
                             child: GridView.builder(
                               controller: exploreController.scrollController,
                                 padding: const EdgeInsets.only(bottom: Dimens.d20),
                                 physics: const BouncingScrollPhysics(),
                                 gridDelegate:
                                 const SliverGridDelegateWithFixedCrossAxisCount(
                                   childAspectRatio: 0.71,
                                   crossAxisCount: 2, // Number of columns
                                   crossAxisSpacing: 20, // Spacing between columns
                                   mainAxisSpacing: 20, // Spacing between rows
                                 ),
                                 itemCount: 6,
                                 itemBuilder: (context, index){
                                   return GestureDetector(
                                     onTap: (){
                                       _onTileClick(index, context);
                                     },
                                     child: Column(
                                       children: [
                                         Stack(
                                           alignment: Alignment.topRight,
                                           children: [
                                             CustomImageView(
                                               imagePath: ImageConstant.staticImage,
                                               height: Dimens.d135,
                                               radius: BorderRadius.circular(10),
                                               fit: BoxFit.cover,
                                             ),
                                             Align(
                                               alignment: Alignment.topRight,
                                               child: Padding(
                                                 padding: EdgeInsets.only(right: 10, top: 10),
                                                 child: SvgPicture.asset(ImageConstant.play),
                                               ),
                                             )
                                           ],
                                         ),
                                         Dimens.d10.spaceHeight,
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Text(
                                               "Meditation",
                                               style: Style.montserratMedium(
                                                 fontSize: Dimens.d12,
                                               ),
                                             ),

                                             const CircleAvatar(
                                               radius: 2,
                                               backgroundColor: ColorConstant.colorD9D9D9,
                                             ),

                                             Text(
                                               "12:00" ?? '',
                                               style: Style.montserratMedium(
                                                 fontSize: Dimens.d12,
                                               ),
                                             ),

                                             SvgPicture.asset(ImageConstant.downloadCircle, height: Dimens.d25, width: Dimens.d25)
                                           ],
                                         ),
                                         Dimens.d7.spaceHeight,
                                         Text(
                                           "Your Way Out Of Addication - Ep 4 H...",
                                           maxLines: Dimens.d2.toInt(),
                                           style: Style.montserratMedium(fontSize: Dimens.d14),
                                           overflow: TextOverflow.ellipsis,
                                         ),
                                       ],
                                     ),
                                   );
                                 })
                         ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

   void _onTileClick(int index, BuildContext context) {
     showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: ColorConstant.white,
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.vertical(
           top: Radius.circular(
             Dimens.d24,
           ),
         ),
       ),
       builder: (BuildContext context) {
         return NowPlayingScreen();
       },
     );
   }
}

class ShoorahRitualsButton extends StatelessWidget {
  const ShoorahRitualsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: IntrinsicHeight(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ColorConstant.color545454,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.d16)),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(Dimens.d16),
                    bottomRight: Radius.circular(Dimens.d16)),
                child: SvgPicture.asset(
                  ImageConstant.ellipseRituals,
                  fit: BoxFit.cover,
                  // height: 80.h,

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImageConstant.ritualsRight,
                    ),
                    Dimens.d12.spaceWidth,
                    Text(
                      "rituals".tr,
                      style: Style.montserratMedium(
                          fontSize: Dimens.d20, color: ColorConstant.white),
                    ),
                    const Spacer(),
                    CommonElevatedButton(
                        title: "startNow".tr,
                        textStyle: Style.montserratMedium(color: ColorConstant.themeColor),
                        buttonColor: ColorConstant.white,
                        height: 30,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        onTap: () {

                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

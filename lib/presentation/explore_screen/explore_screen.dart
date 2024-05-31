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
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_image_view.dart';

class ExploreScreen extends StatefulWidget {
  ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ExploreController exploreController = Get.put(ExploreController());
  late final AnimationController _lottieBgController;
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);

  @override
  void initState() {
    _lottieBgController = AnimationController(vsync: this);

    scrollController.addListener(() {
      //scroll listener
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _lottieBgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        floatingActionButton: ValueListenableBuilder(
          valueListenable: showScrollTop,
          builder: (context, value, child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 700), //show/hide animation
              opacity: showScrollTop.value
                  ? 1.0
                  : 0.0, //set opacity to 1 on visible, or hide
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstant.colorBFD0D4,
                ),
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    );
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
                ),
              ),
            );
          },
        ),
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(1, 0),
              child: SvgPicture.asset(ImageConstant.bgVector,
                  height: Dimens.d230.h),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Dimens.d30.h.spaceHeight,
                          HomeAppBar(
                            onInfoTap: (){},
                            isInfo: false,
                            back: false,
                            title: "explore".tr,
                          ),
                          Dimens.d30.h.spaceHeight,
                          const TransFormRitualsButton(),
                          Dimens.d20.h.spaceHeight,
                          Expanded(
                              child: GridView.builder(
                                  controller: scrollController,
                                  padding:
                                      const EdgeInsets.only(bottom: Dimens.d20),
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.71,
                                    crossAxisCount: 2,
                                    // Number of columns
                                    crossAxisSpacing: 20,
                                    // Spacing between columns
                                    mainAxisSpacing: 20, // Spacing between rows
                                  ),
                                  itemCount: exploreController.exploreList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        _onTileClick(index, context);
                                      },
                                      child: Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              CustomImageView(
                                                imagePath:
                                                exploreController.exploreList[index]['image'],
                                                height: Dimens.d135,
                                                radius:
                                                    BorderRadius.circular(10),
                                                fit: BoxFit.cover,
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, top: 10),
                                                  child: SvgPicture.asset(
                                                      ImageConstant.play),
                                                ),
                                              )
                                            ],
                                          ),
                                          Dimens.d10.spaceHeight,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Meditation",
                                                style: Style.montserratMedium(
                                                  fontSize: Dimens.d12,
                                                ),
                                              ),
                                              const CircleAvatar(
                                                radius: 2,
                                                backgroundColor:
                                                    ColorConstant.colorD9D9D9,
                                              ),
                                              Text(
                                                "12:00" ?? '',
                                                style: Style.montserratMedium(
                                                  fontSize: Dimens.d12,
                                                ),
                                              ),
                                              SvgPicture.asset(
                                                  ImageConstant.downloadCircle,
                                                  height: Dimens.d25,
                                                  width: Dimens.d25)
                                            ],
                                          ),
                                          Dimens.d7.spaceHeight,
                                          Text(
                                            exploreController.exploreList[index]['title'],
                                            maxLines: Dimens.d2.toInt(),
                                            style: Style.montserratMedium(
                                                fontSize: Dimens.d14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
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

class TransFormRitualsButton extends StatelessWidget {
  const TransFormRitualsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: IntrinsicHeight(
        child: Container(
          height: Dimens.d56,
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
                        textStyle: Style.montserratMedium(
                            color: ColorConstant.themeColor),
                        buttonColor: ColorConstant.white,
                        height: 30,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        onTap: () {})
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

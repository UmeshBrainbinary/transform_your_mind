import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/backgroud_container.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/get_pods_model.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_controller.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class DownloadedPodsScreen extends StatefulWidget {
  const DownloadedPodsScreen({super.key});

  @override
  State<DownloadedPodsScreen> createState() => _DownloadedPodsScreenState();
}

class _DownloadedPodsScreenState extends State<DownloadedPodsScreen> {
  late ScrollController scrollController = ScrollController();
  AudioContentController audioContentController =
      Get.put(AudioContentController());
ThemeController themeController = Get.find<ThemeController>();
  @override
  void initState() {
    audioContentController.getDownloadedList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    statusBarSet(themeController);

    return SafeArea(bottom: false,
      child: Scaffold(backgroundColor:themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.backGround,
          appBar: CustomAppBar(
            title: "Downloads".tr,
            showBack: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Dimens.d30.h.spaceHeight,
                GetBuilder<AudioContentController>(
                  id: 'update',
                  builder: (controller) {
                    return Expanded(
                      child: controller.audioDataDownloaded.isNotEmpty
                          ? GridView.builder(
                              controller: scrollController,
                              padding:
                                  const EdgeInsets.only(bottom: Dimens.d20),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.78,
                                crossAxisCount: 2,
                                // Number of columns
                                crossAxisSpacing: 20,
                                // Spacing between columns
                                mainAxisSpacing: 20, // Spacing between rows
                              ),
                              itemCount: controller.audioDataDownloaded.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _onTileClick(
                                      context: context,
                                      index: index,
                                      audioContent:
                                          controller.audioDataDownloaded[index],
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          CommonLoadImage(
                                            borderRadius: 10,
                                            url: controller
                                                    .audioDataDownloaded[index]
                                                    .image ??
                                                "",
                                            width: Dimens.d156,
                                            height: Dimens.d113,
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
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
                                          SizedBox(
                                            width: 90,
                                            child: Text(
                                              controller
                                                  .audioDataDownloaded[index]
                                                  .name
                                                  .toString(),
                                              // "Motivational",
                                              style: Style.montserratMedium(
                                                fontSize: Dimens.d12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          const CircleAvatar(
                                            radius: 2,
                                            backgroundColor:
                                                ColorConstant.colorD9D9D9,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                ImageConstant.rating,
                                                color:
                                                    ColorConstant.colorFFC700,
                                                height: 10,
                                                width: 10,
                                              ),
                                              Text(
                                                "${controller.audioDataDownloaded[index].rating.toString()}.0" ??
                                                    '',
                                                style: Style.montserratMedium(
                                                  fontSize: Dimens.d12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          controller.audioDataDownloaded[index].download == true
                                              ? GestureDetector(
                                                  onTap: () async {

                                                    await controller
                                                        .removeData(index);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    height: 22,
                                                    width: 22,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 1.5)),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                      Dimens.d7.spaceHeight,
                                      Text(
                                        controller.audioDataDownloaded[index]
                                            .description
                                            .toString(),
                                        maxLines: Dimens.d2.toInt(),
                                        style: Style.montserratMedium(
                                            fontSize: Dimens.d14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: Dimens.d120),
                          child: SizedBox(
                            height: Get.height,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  themeController.isDarkMode.isTrue?ImageConstant.darkData:ImageConstant
                                      .noData,height: 158,width: 200,),
                                Text(
                                  "dataNotFound".tr,
                                  style: Style.montserratBold(fontSize: 24),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  void _onTileClick(
      {int? index, BuildContext? context, required AudioData audioContent}) {
    showModalBottomSheet(
      context: context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Dimens.d24,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return NowPlayingScreen(
          d: true,
          audioData: audioContent,
        );
      },
    );
  }
}

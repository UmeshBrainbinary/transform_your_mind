import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_load_image.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AudioList extends StatefulWidget {
  const AudioList({super.key});

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {
  ThemeController themeController = Get.find<ThemeController>();
  List audioList = [
    {
      "img":
      "https://i.pinimg.com/736x/45/ce/29/45ce2986d79fc7cd05014bd522a88834.jpg",
      "name": "Remedy",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg"
    },
    {
      "img":
      "https://images.unsplash.com/photo-1547483238-2cbf881a559f?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MXw1MDI3OTF8fGVufDB8fHx8fA%3D%3D",

      "name": "Giant",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/win.ogg"
    },
    {
      "img":
      "https://w0.peakpx.com/wallpaper/233/89/HD-wallpaper-blue-sky-beautiful-clouds-life-love-nature-stars-sunset.jpg",

      "name": "Safe House",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg"
    },
    {
      "img":
      "https://1.bp.blogspot.com/-4iulinQP-Bo/YOBwMdwSlII/AAAAAAAAQmk/wfv9P_KGa7MKzC-7MEc7TGHhqD6jg0mtgCLcBGAsYHQ/s0/V1-SIMPLE-LANDSCAPE-HD.png",
      "name": "Can’t Sleep",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.ogg"
    },
    {
      "img":
      "https://i.pinimg.com/736x/45/ce/29/45ce2986d79fc7cd05014bd522a88834.jpg",
      "name": "Remedy",
      "des": "Remedy",
      "url":
          "https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"
    },
  ];
  List playPause = [];
  int currentIndex = -1;
  final AudioPlayer player = AudioPlayer();
  int currentIndexSelected = 0;
  @override
  void initState() {
    List.generate(
      audioList.length,
      (index) => playPause.add(false),
    );
    super.initState();
  }

  Future<void> _playPause(int index) async {
    if (player.playing) {
      await player.stop();
      setState(() {
        playPause[index] = false;
      });
    } else {
      setState(() {
        playPause[index] = true;
      });
      await player.setUrl(audioList[index]["url"]);

      await player.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue?ColorConstant.darkBackground:ColorConstant.backGround,
      appBar: CustomAppBar(title: "AudioList".tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Dimens.d20.spaceHeight,
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: audioList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(onTap: () {
                    setState(() {
                      currentIndexSelected =index;
                    });
                  },
                    child: Container(
                      height: Dimens.d70,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: currentIndexSelected==index?ColorConstant.themeColor:ColorConstant.transparent,width: 1),
                        borderRadius: BorderRadius.circular(15),
                        color: themeController.isDarkMode.value
                            ? ColorConstant.textfieldFillColor
                            : Colors.white,
                      ),
                      child: Row(children: [
                        CachedNetworkImage(
                          height: 58,
                          width: 75,
                          imageUrl: audioList[index]["img"] ?? "",
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
                            height: Dimens.d80.h,
                            width: Dimens.d80,
                            borderRadius: 10.0,
                          ),
                          errorWidget: (context, url, error) => PlaceHolderCNI(
                            height: Dimens.d80.h,
                            width: Dimens.d80,
                            isShowLoader: false,
                            borderRadius: 8.0,
                          ),
                        ),
                        Dimens.d20.spaceWidth,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Text(
                                audioList[index]["name"] ?? "",
                                style: Style.nunMedium(
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: Dimens.d200,
                                child: Text(
                                  audioList[index]["des"] ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Style.gothamLight(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _playPause(index),
                          child: SvgPicture.asset(
                            playPause[index]
                                ? ImageConstant.breathPause
                                : ImageConstant.breathPlay,
                          ),
                        ),
                        Dimens.d9.spaceWidth,
                      ]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

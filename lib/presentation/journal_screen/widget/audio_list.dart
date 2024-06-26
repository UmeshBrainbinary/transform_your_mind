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
      "name": "Remedy",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg"
    },
    {
      "name": "Giant",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/win.ogg"
    },
    {
      "name": "Safe House",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/music/menu.ogg"
    },
    {
      "name": "Can’t Sleep",
      "des": "Remedy",
      "url":
          "https://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.ogg"
    },
    {
      "name": "Remedy",
      "des": "Remedy",
      "url":
          "https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3"
    },
  ];
  List playPause = [];
  bool isPlaying = false; // Track play/pause state
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    List.generate(
      audioList.length,
      (index) => playPause.add(false),
    );
    super.initState();
  }

  int currentIndex = -1;
   _playPause(int index) async {
    if (player.playing) {
      await player.pause();
      setState(() {
        playPause[index] = false;
      });
    } else {
      await player.setUrl(audioList[index]["url"]);
      await player.play();
      setState(() {
        playPause[index] = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backGround,
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
                  return Container(
                    height: Dimens.d70,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: themeController.isDarkMode.value
                          ? ColorConstant.textfieldFillColor
                          : Colors.white,
                    ),
                    child: Row(children: [
                      CachedNetworkImage(
                        height: 58,
                        width: 75,
                        imageUrl: audioList[index]["name"] ?? "",
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
                      Dimens.d25.spaceWidth,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              audioList[index]["name"] ?? "",
                              style: Style.cormorantGaramondBold(
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
                          onTap: () async {
                            // Handle audio play for tapped item
                            if (isPlaying) {

                              playPause[index] = false;
                              player.pause();
                              setState(() {
                                isPlaying = false;
                              });
                            } else {
                              playPause[index] = true;
                              await player.setUrl(audioList[index]["url"]);

                              player.play();
                              setState(() {
                                isPlaying = true;
                              });
                            }

                          },
                          child: SvgPicture.asset(playPause[index]
                              ? ImageConstant.breathPause
                              : ImageConstant.breathPlay)),
                      Dimens.d9.spaceWidth,
                    ]),
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

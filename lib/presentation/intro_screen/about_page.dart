import 'package:flutter/material.dart';

import 'package:transform_your_mind/core/common_widget/bg_semi_circle_texture_painter.dart';
import 'package:transform_your_mind/core/common_widget/common_text_button.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/rituals_screen/rituals_screen.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  void initState() {
    super.initState();
   /* tutorialVideoData = BlocProvider.of<DashboardBloc>(context)
        .tutorialVideoData
        ?.firstWhereOrNull((element) =>
            element.contentType == TutorialContentType.about.value);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "About Transform",
          action: CommonTextButton(
            text: "Next",
            textStyle: Style.montserratRegular(color: ColorConstant.themeColor),
            onTap: () {
              //videoKeys[4].currentState?.pause();
              //Navigator.pushNamed(context, ChooseThemePage.chooseTheme,
              //    arguments: {AppConstants.fromAbout: true});
            },
          ),
        ),
        body: Stack(
          children: [
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              BgSemiCircleTexture(
                  topAlign: MediaQuery.of(context).size.height * Dimens.d1_02),
            if (MediaQuery.of(context).orientation == Orientation.portrait)
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Image.asset(
                        ImageConstant.imgAboutShapes,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            LayoutContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Dimens.d10.spaceHeight,
                  SizedBox(
                      height: getHeight(MediaQuery.of(context).size.width),
                 /*     child: VideoThumbWidget(
                          key: videoKeys[4],
                          tutorialVideoData:
                              tutorialVideoData ?? TutorialVideoData(),
                          onTap: () {})*/),

                  /// to prevent overflow issues when video player in full screen mode
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait) ...[
                    Dimens.d32.spaceHeight,
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "About Transform",
                                style: Style.montserratRegular(
                                    color: ColorConstant.textWhiteTransform,
                                    fontSize: Dimens.d18,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "Transform is a fresh and comprehensive wellbeing app that helps you support your mental health and nourish your wellbeing through a range of wellness tools. It’s a place for you to look after YOU.\n\nJoin the Transform community to lift your mood, improve your sleep, feel more calm, boost your energy, manage anxiety, reduce stress and create more joyful moments in your life.. \n\Transform is for the mind, body and soul. It allows you to hold your wellness in your hands and access transformational wellbeing tools wherever you are, whether its meditation, breathwork, journalling, ‘cleansing’, creating affirmations, or practicing gratitude.\n\nThis app is perfect for everyone, no matter where you are on your wellbeing journey. \n\nWhether you know what you ‘should’ be doing but simply don’t have the time, for whether you’re embarking on your journey of self-discovery for the first time, Shoorah is here to help.\n\nShoorah provides a simple, on the go tool to keep you on track & abundant, making it easier to prioritise your mental health without having to create more hours in the day. \n\nShoorah was created by industry leading experts, and all of its tools and techniques are tried and tested, and used daily by the team behind the app. \n\nWe want to help people reach their optimum state, find a sense of peace and flow in their lives and celebrate joyful Transform moments regularly. \n\Transform is the ultimate self-work mobile app to build the life you desire…..let’s get started.",
                                style: Style.montserratRegular(
                                    color: ColorConstant.textWhiteTransform,
                                    fontSize: Dimens.d14,
                                    height: Dimens.d_1_6,
                                    ),
                              ),
                              Dimens.d34.spaceHeight,
                              Text(
                                "Transform is a fresh and comprehensive wellbeing app that helps you support your mental health and nourish your wellbeing through a range of wellness tools. It’s a place for you to look after YOU.\n\nJoin the Transform community to lift your mood, improve your sleep, feel more calm, boost your energy, manage anxiety, reduce stress and create more joyful moments in your life.. \n\Transform is for the mind, body and soul. It allows you to hold your wellness in your hands and access transformational wellbeing tools wherever you are, whether its meditation, breathwork, journalling, ‘cleansing’, creating affirmations, or practicing gratitude.\n\nThis app is perfect for everyone, no matter where you are on your wellbeing journey. \n\nWhether you know what you ‘should’ be doing but simply don’t have the time, for whether you’re embarking on your journey of self-discovery for the first time, Shoorah is here to help.\n\nShoorah provides a simple, on the go tool to keep you on track & abundant, making it easier to prioritise your mental health without having to create more hours in the day. \n\nShoorah was created by industry leading experts, and all of its tools and techniques are tried and tested, and used daily by the team behind the app. \n\nWe want to help people reach their optimum state, find a sense of peace and flow in their lives and celebrate joyful Transform moments regularly. \n\Transform is the ultimate self-work mobile app to build the life you desire…..let’s get started.",
                                style: Style.montserratRegular(
                                  color: ColorConstant.textWhiteTransform,
                                  fontSize: Dimens.d14,
                                  height: Dimens.d_1_6,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "About Restore",
                                style: Style.montserratRegular(
                                  color: ColorConstant.textWhiteTransform,
                                  fontSize: Dimens.d16,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "Transform is a fresh and comprehensive wellbeing app that helps you support your mental health and nourish your wellbeing through a range of wellness tools. It’s a place for you to look after YOU.\n\nJoin the Transform community to lift your mood, improve your sleep, feel more calm, boost your energy, manage anxiety, reduce stress and create more joyful moments in your life.. \n\Transform is for the mind, body and soul. It allows you to hold your wellness in your hands and access transformational wellbeing tools wherever you are, whether its meditation, breathwork, journalling, ‘cleansing’, creating affirmations, or practicing gratitude.\n\nThis app is perfect for everyone, no matter where you are on your wellbeing journey. \n\nWhether you know what you ‘should’ be doing but simply don’t have the time, for whether you’re embarking on your journey of self-discovery for the first time, Shoorah is here to help.\n\nShoorah provides a simple, on the go tool to keep you on track & abundant, making it easier to prioritise your mental health without having to create more hours in the day. \n\nShoorah was created by industry leading experts, and all of its tools and techniques are tried and tested, and used daily by the team behind the app. \n\nWe want to help people reach their optimum state, find a sense of peace and flow in their lives and celebrate joyful Transform moments regularly. \n\Transform is the ultimate self-work mobile app to build the life you desire…..let’s get started.",
                                style: Style.montserratRegular(
                                  color: ColorConstant.textWhiteTransform,
                                  fontSize: Dimens.d14,
                                  height: Dimens.d_1_6,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "About journal",
                                style: Style.montserratRegular(
                                  color: ColorConstant.textWhiteTransform,
                                  fontSize: Dimens.d16,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "Transform is a fresh and comprehensive wellbeing app that helps you support your mental health and nourish your wellbeing through a range of wellness tools. It’s a place for you to look after YOU.\n\nJoin the Transform community to lift your mood, improve your sleep, feel more calm, boost your energy, manage anxiety, reduce stress and create more joyful moments in your life.. \n\Transform is for the mind, body and soul. It allows you to hold your wellness in your hands and access transformational wellbeing tools wherever you are, whether its meditation, breathwork, journalling, ‘cleansing’, creating affirmations, or practicing gratitude.\n\nThis app is perfect for everyone, no matter where you are on your wellbeing journey. \n\nWhether you know what you ‘should’ be doing but simply don’t have the time, for whether you’re embarking on your journey of self-discovery for the first time, Shoorah is here to help.\n\nShoorah provides a simple, on the go tool to keep you on track & abundant, making it easier to prioritise your mental health without having to create more hours in the day. \n\nShoorah was created by industry leading experts, and all of its tools and techniques are tried and tested, and used daily by the team behind the app. \n\nWe want to help people reach their optimum state, find a sense of peace and flow in their lives and celebrate joyful Transform moments regularly. \n\Transform is the ultimate self-work mobile app to build the life you desire…..let’s get started.",
                                style: Style.montserratRegular(
                                  color: ColorConstant.textWhiteTransform,
                                  fontSize: Dimens.d14,
                                  height: Dimens.d_1_6,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "About Rituals",
                                style: Style.montserratRegular(
                                    color: ColorConstant.textWhiteTransform,
                                    fontSize: Dimens.d16,
                                    ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "Transform is a fresh and comprehensive wellbeing app that helps you support your mental health and nourish your wellbeing through a range of wellness tools. It’s a place for you to look after YOU.\n\nJoin the Transform community to lift your mood, improve your sleep, feel more calm, boost your energy, manage anxiety, reduce stress and create more joyful moments in your life.. \n\Transform is for the mind, body and soul. It allows you to hold your wellness in your hands and access transformational wellbeing tools wherever you are, whether its meditation, breathwork, journalling, ‘cleansing’, creating affirmations, or practicing gratitude.\n\nThis app is perfect for everyone, no matter where you are on your wellbeing journey. \n\nWhether you know what you ‘should’ be doing but simply don’t have the time, for whether you’re embarking on your journey of self-discovery for the first time, Shoorah is here to help.\n\nShoorah provides a simple, on the go tool to keep you on track & abundant, making it easier to prioritise your mental health without having to create more hours in the day. \n\nShoorah was created by industry leading experts, and all of its tools and techniques are tried and tested, and used daily by the team behind the app. \n\nWe want to help people reach their optimum state, find a sense of peace and flow in their lives and celebrate joyful Transform moments regularly. \n\Transform is the ultimate self-work mobile app to build the life you desire…..let’s get started.",
                                style: Style.montserratRegular(
                                  color: ColorConstant.textWhiteTransform,
                                  fontSize: Dimens.d14,
                                  height: Dimens.d_1_6,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "About Explore",
                                style: Style.montserratRegular(
                                    color: ColorConstant.textWhiteTransform,
                                    fontSize: Dimens.d16,
                                ),
                              ),
                              Dimens.d16.spaceHeight,
                              Text(
                                "Transform is a fresh and comprehensive wellbeing app that helps you support your mental health and nourish your wellbeing through a range of wellness tools. It’s a place for you to look after YOU.\n\nJoin the Transform community to lift your mood, improve your sleep, feel more calm, boost your energy, manage anxiety, reduce stress and create more joyful moments in your life.. \n\Transform is for the mind, body and soul. It allows you to hold your wellness in your hands and access transformational wellbeing tools wherever you are, whether its meditation, breathwork, journalling, ‘cleansing’, creating affirmations, or practicing gratitude.\n\nThis app is perfect for everyone, no matter where you are on your wellbeing journey. \n\nWhether you know what you ‘should’ be doing but simply don’t have the time, for whether you’re embarking on your journey of self-discovery for the first time, Shoorah is here to help.\n\nShoorah provides a simple, on the go tool to keep you on track & abundant, making it easier to prioritise your mental health without having to create more hours in the day. \n\nShoorah was created by industry leading experts, and all of its tools and techniques are tried and tested, and used daily by the team behind the app. \n\nWe want to help people reach their optimum state, find a sense of peace and flow in their lives and celebrate joyful Transform moments regularly. \n\Transform is the ultimate self-work mobile app to build the life you desire…..let’s get started.",
                                style: Style.montserratRegular(
                                  color: ColorConstant.textWhiteTransform,
                                  fontSize: Dimens.d14,
                                  height: Dimens.d_1_6,
                                ),
                              ),
                            ]),
                      ),
                    )
                  ]
                ],
              ),
            )
          ],
        ));
  }
}

import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';


/// this widget used for showing information of particular screen with it's text
/// and video from API
class ScreenInfoWidget extends StatefulWidget {
  final ValueNotifier<bool> isTutorialVideoVisible;
  final ValueNotifier<bool> info;
  final VoidCallback onVideoViewTap;
  final AnimationController controller;
  final String screenTitle;
  final String screenHeading;
  final String screenDesc;
  final bool showVideoIcon;

  const ScreenInfoWidget({
    required this.isTutorialVideoVisible,

    required this.onVideoViewTap,

    required this.controller,
    required this.screenTitle,
    required this.screenHeading,
    required this.screenDesc,
    this.showVideoIcon = true,
    Key? key, required this.info,
  }) : super(key: key);

  @override
  State<ScreenInfoWidget> createState() => _ScreenInfoWidgetState();
}

class _ScreenInfoWidgetState extends State<ScreenInfoWidget>
    with TickerProviderStateMixin {
  ValueNotifier<bool> isTextVisible = ValueNotifier(true);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    widget.isTutorialVideoVisible.addListener(() {
      if (!widget.isTutorialVideoVisible.value) {
        isTextVisible.value = true;
      }
    });
    if (widget.isTutorialVideoVisible.value) {
      _controller.forward();
      _controller.addListener(() {
        if (_controller.value == 0.0) {
          isTextVisible.value = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ValueListenableBuilder(
            valueListenable: widget.isTutorialVideoVisible,
            builder: (BuildContext context, value, Widget? child) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: _controller.status == AnimationStatus.forward ||
                      widget.isTutorialVideoVisible.value
                      ? 20
                      : 0.0,
                  left: 20,
                  right: 20,
                ),
                child: SizeTransition(
                  sizeFactor: _controller,
                  child: SizedBox(
                    //height: getHeight(MediaQuery.of(context).size.width),
                    child: ValueListenableBuilder(
                      builder: (context, value, child) {
                        return value ? tutorialTextView() : child!;
                      },
                      valueListenable: isTextVisible,
                      child: const SizedBox(),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 15,
            top: -5,
            child: GestureDetector(
              onTap: () {
                widget.isTutorialVideoVisible.value =
                !widget.isTutorialVideoVisible.value;
                widget.info.value = !widget.info.value;
                if (widget.isTutorialVideoVisible.value) {
                  _controller.forward();
                } else {
                  //widget.videoStateKey.currentState?.pause();
                  isTextVisible.value = true;
                  _controller.reverse();
                }
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return _controller.value == 0
                      ? const SizedBox.shrink()
                      : child!;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstant.colorThemed4,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    ImageConstant.icClose,
                    color: Colors.white,
                    height: Dimens.d18.h,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tutorialTextView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AutoSizeText(
                  widget.screenTitle,
                  maxLines: 1,
                  style: Style.montserratRegular(fontSize: Dimens.d20),
                ),

                if (widget.showVideoIcon) ...[
                  Dimens.d10.spaceWidth,
                  /*(widget.tutorialVideoData.videoUrl != null)?*/ GestureDetector(
                    onTap: () {
                      isTextVisible.value = !isTextVisible.value;
                    },
                    child: SvgPicture.asset(
                      ImageConstant.playIcon,
                      height: Dimens.d24.h,
                      width: Dimens.d24.h,
                    ),
                  )/*:const SizedBox()*/
                ]
              ],
            ),
            Dimens.d6.spaceHeight,
            AutoSizeText(
              widget.screenHeading,
              maxLines: 4,
              style: Style.montserratRegular(
                fontSize: Dimens.d16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Dimens.d6.spaceHeight,
            AutoSizeText(
              widget.screenDesc,
              style: Style.montserratRegular(
                fontSize: Dimens.d13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AddRatingsView extends StatefulWidget {
  final String screenTitle;
  final String screenHeading;
  final String screenDesc;
  final bool showVideoIcon;
  final int initialRating;
  final Function(int) onRatingChanged;
  const AddRatingsView({super.key,
    required this.screenTitle,
    required this.screenHeading,
    required this.screenDesc,
    this.showVideoIcon = true,
    this.initialRating=0,
    required this.onRatingChanged});

  @override
  State<AddRatingsView> createState() => _AddRatingsViewState();
}

class _AddRatingsViewState extends State<AddRatingsView>   with TickerProviderStateMixin {
  ValueNotifier<bool> isTextVisible = ValueNotifier(true);
  int? _currentRating ;

  @override
  void initState() {
    super.initState();

    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: 0.0,
              left: 20,
              right: 20,
            ),
            child:SizedBox(
              //height: getHeight(MediaQuery.of(context).size.width),
                child: tutorialTextView()
            ),
          ),

        ],
      ),
    );
  }

  Widget tutorialTextView() {
    return Container(
      height: Dimens.d190.h,
      decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.20)),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Dimens.d5.spaceHeight,

          AutoSizeText(
            widget.screenTitle,
            maxLines: 1,
            style: Style.montserratRegular(fontSize: Dimens.d15),
          ),
          Dimens.d8.spaceHeight,
          Text(
            widget.screenHeading,
            maxLines: 4,
            style: Style.montserratRegular(
              fontSize: 11,color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w300,
            ),
          ),
          Dimens.d8.spaceHeight,
          Text(
            widget.screenDesc,
            maxLines: 3,
            style: Style.montserratRegular(
              fontSize: 9,
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w200,
            ),
          ),
          Dimens.d15.spaceHeight,

          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: GestureDetector(
                  onTap: () => _setRating(index + 1,widget.initialRating),
                  child:index < _currentRating! ?SvgPicture.asset(
                    ImageConstant.ratingFillSvg,
                    height: Dimens.d18.h,
                    width: Dimens.d18,
                  ):SvgPicture.asset(
                    ImageConstant.ratingNoFillSvg,
                    height: Dimens.d18.h,
                    width: Dimens.d18,
                  ),
                ),
              );
            }),
          ),
          Dimens.d7.spaceHeight,

        ],
      ),
    );
  }
  void _setRating(int rating, int initialRating) {
    setState(() {
      _currentRating = rating;
      initialRating = _currentRating!;

    });
    widget.onRatingChanged(_currentRating!);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:transform_your_mind/core/common_widget/app_common_dialog.dart';
import 'package:transform_your_mind/core/common_widget/ritual_tile.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/divider.dart';


class TodaysRituals extends StatefulWidget {
  const TodaysRituals({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;
  @override
  State<TodaysRituals> createState() => _TodaysRitualsState();
}

class _TodaysRitualsState extends State<TodaysRituals> {

  int selectedIndex = -1;
  int? totalCount = 0;
  final GlobalKey<AnimatedListState> _myRitualListKey =
      GlobalKey<AnimatedListState>();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
               "Your Daily Rituals",
                style: Style.montserratRegular(
                  fontSize: Dimens.d20,
                ),
              ),
              Dimens.d10.spaceWidth,
              GestureDetector(
                onTap: () {
                  CommonDialogWithCloseIcon.show(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.d16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                    'Into Text',
                                      style: Style.montserratRegular(
                                          fontSize: Dimens.d18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: SvgPicture.asset(ImageConstant.icClose),
                                ),
                              ],
                            ),
                            Dimens.d16.spaceHeight,
                            const Padding(
                              padding: EdgeInsets.only(bottom: Dimens.d16),
                              child: DividerWidget(),
                            ),
                            Dimens.d20.spaceHeight,
                            Text(
                              "Tick Once You Have Completed",
                              style: Style.montserratRegular(fontSize: Dimens.d14),
                            ),
                            Dimens.d20.spaceHeight,
                          ],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 20);
                },
                child: Lottie.asset(
                  ImageConstant.homeInfoLottie,
                  height: Dimens.d24,
                  width: Dimens.d24,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.d8),
          child:  Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.d16),
            ),
            child: AnimatedList(
              key: _myRitualListKey,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              initialItemCount: 5,
              itemBuilder: (context, index, animation) {
                return
                _buildRitualTile(
                    context, index,animation);
              },
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CommonElevatedButton(
            title: (totalCount == 0) ? "Add New" : "Edit",
            outLined: true,
            textStyle: Style.montserratRegular(
              fontSize: Dimens.d14,
            ),
            onTap: () {

            },
          ),
        ),
      ],
    );
  }



  _buildRitualTile(context, index,animation ) {
    return Column(
      children: [
        SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: RitualTile(location: true,
            onTap: () {
         /*     if (_debounce?.isActive ?? false) _debounce?.cancel();
              selectedIndex = index;
              setState(() {});
              _debounce = Timer(const Duration(milliseconds: 200), () {
                selectedIndex = -1;
                final retVal = todayRitualList.removeAt(index);
                _myRitualListKey.currentState?.removeItem(index,
                    (_, animation) {
                  return _buildRitualTile(context, index, retVal, animation);
                }, duration: const Duration(milliseconds: 200));
                _homeBloc.add(
                  UpdateTodayRitualEvent(
                      updateTodayRitualsRequest: UpdateTodayRitualsRequest(
                        ritualId: data.ritualId,
                        isCompleted: data.isCompleted,
                      ),
                      index: index),
                );
              });*/
            },
            title: "Rituals First " ?? "",
            subTitle: "Completed  times in a row",
            image: ImageConstant.imgRitualSelected,
          ),
        ),
        if (index < 5- 1)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.d20),
            child: DividerWidget(),
          )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/common_widget/shimmer_widget.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';


class JournalListShimmer extends StatelessWidget {
  const JournalListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: Dimens.d20.h),
            height: Dimens.d110,
            width: Dimens.d335,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Dimens.d16.radiusAll,
            ),
            child: Row(
              children: [
                const ShimmerWidget.rectangular(
                  width: Dimens.d110,
                  height: Dimens.d110,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16))),
                ),
                Dimens.d16.spaceWidth,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimens.d20.h),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.rectangular(
                        height: 16,
                        width: Dimens.d100,
                      ),
                      ShimmerWidget.rectangular(
                        height: 16,
                        width: Dimens.d150,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class JournalListHorizontalShimmer extends StatelessWidget {
  const JournalListHorizontalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
          child: Text(
            "Draft",
            style: Style.montserratBold(
              fontSize: Dimens.d16,
            ),
          ),
        ),
        Dimens.d20.spaceHeight,
        Padding(
          padding: const EdgeInsets.only(right: Dimens.d20),
          child: SizedBox(
            height: Dimens.d110.h,
            child: Container(
              margin: const EdgeInsets.only(left: Dimens.d20),
              height: Dimens.d110,
              width: Dimens.d325,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Dimens.d16.radiusAll,
              ),
              child: Row(
                children: [
                  const ShimmerWidget.rectangular(
                    width: Dimens.d110,
                    height: Dimens.d110,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16))),
                  ),
                  Dimens.d16.spaceWidth,
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimens.d20.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.rectangular(
                          height: 16,
                          width: Dimens.d110,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                        ShimmerWidget.rectangular(
                          height: 16,
                          width: Dimens.d150,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class JournalListGoalsShimmer extends StatelessWidget {
  const JournalListGoalsShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: Dimens.d20.h),
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.d24,
              horizontal: Dimens.d20,
            ),
            width: Dimens.d325,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Dimens.d16.radiusAll,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerWidget.rectangular(
                      width: Dimens.d48,
                      height: Dimens.d48,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    Dimens.d16.spaceWidth,
                    ShimmerWidget.rectangular(
                      height: 16,
                      width: Dimens.d150,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
                Dimens.d24.spaceHeight,
                ShimmerWidget.rectangular(
                  height: 16,
                  width: Dimens.d150,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                Dimens.d16.spaceHeight,
                ShimmerWidget.rectangular(
                  height: 16,
                  width: Dimens.d150,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ],
            ),
          );
        });
  }
}

class JournalSearchShimmer extends StatelessWidget {
  const JournalSearchShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ShimmerWidget.rectangular(
      height: 40,
      width: Dimens.d350,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}

class JournalGoalsListHorizontalShimmer extends StatelessWidget {
  const JournalGoalsListHorizontalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Draft",
          style: Style.montserratBold(
            fontSize: Dimens.d18,
          ),
        ),
        Dimens.d20.h.spaceHeight,
        Padding(
          padding: const EdgeInsets.only(right: Dimens.d20),
          child: SizedBox(
            height: Dimens.d92.h,
            child: Container(
              height: Dimens.d92,
              width: Dimens.d325,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Dimens.d16.radiusAll,
              ),
              child: Row(
                children: [
                  const ShimmerWidget.rectangular(
                    width: Dimens.d92,
                    height: Dimens.d92,
                    shapeBorder: // RoundedRectangleBorder(
                        //   borderRadius:
                        //       BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                        // ),
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                  ),
                  Dimens.d16.spaceWidth,
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimens.d20.h),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.rectangular(
                          height: 16,
                          width: Dimens.d100,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                        ),
                        ShimmerWidget.rectangular(
                          height: 16,
                          width: Dimens.d150,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/common_widget/shimmer_widget.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/widgets/divider.dart';



class RitualsShimmer extends StatelessWidget {
  final double horizontalPadding;
  const RitualsShimmer({super.key, this.horizontalPadding = Dimens.d20});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Dimens.d16.radiusAll,
      ),
      child: ListView.builder(
          itemCount: 6,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: Dimens.d20.paddingAll,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget.rectangular(
                            height: 16,
                            width: Dimens.d120,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Dimens.d8)),
                          ),
                          Dimens.d5.spaceHeight,
                          ShimmerWidget.rectangular(
                            height: 12,
                            width: Dimens.d150,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Dimens.d8)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Material(
                        color: Colors.transparent,
                        child: ShimmerWidget.circular(
                          height: Dimens.d46,
                          width: Dimens.d46,
                        ),
                      )
                    ],
                  ),
                ),
                if (index < 10 - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.d20),
                    child: DividerWidget(),
                  )
              ],
            );
          }),
    );
  }
}

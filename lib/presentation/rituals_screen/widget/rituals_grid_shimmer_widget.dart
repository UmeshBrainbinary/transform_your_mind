import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/common_widget/shimmer_widget.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';



class RitualsGridShimmer extends StatelessWidget {
  const RitualsGridShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.start,
      children: [
        ...List.generate(
          10,
          (index) => Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: ShimmerWidget.rectangular(
              width: getTileWidth(context),
              height: getTileWidth(context),
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.d16)),
            ),
          ),
        ),
      ],
    );
  }

  double getTileWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width / 2 - Dimens.d32;
}

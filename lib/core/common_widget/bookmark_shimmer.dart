import 'package:flutter/material.dart';

import 'package:transform_your_mind/core/common_widget/shimmer_widget.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';


class BookmarkMeditationsListShimmer extends StatelessWidget {
  const BookmarkMeditationsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: Dimens.d15.h),
          height: Dimens.d92,
          width: Dimens.d325,
          decoration: BoxDecoration(
            borderRadius: Dimens.d16.radiusAll,
          ),
          child: Row(
            children: [
              ShimmerWidget.rectangular(
                width: Dimens.d108,
                height: Dimens.d75,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: Dimens.d16.radiusAll,
                ),
              ),
              Dimens.d16.spaceWidth,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimens.d10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.rectangular(
                        height: 18,
                        width: Dimens.d100,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: Dimens.d16.radiusAll,
                        ),
                      ),
                      Row(
                        children: [
                          ShimmerWidget.rectangular(
                            height: 14,
                            width: Dimens.d30,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: Dimens.d16.radiusAll,
                            ),
                          ),
                          Dimens.d10.spaceWidth,
                          ShimmerWidget.rectangular(
                            height: 14,
                            width: Dimens.d150,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: Dimens.d16.radiusAll,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: Dimens.d15.h,
                            child: ShimmerWidget.rectangular(
                              height: Dimens.d10,
                              width: Dimens.d30,
                              shapeBorder: RoundedRectangleBorder(
                                borderRadius: Dimens.d16.radiusAll,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.bookmark_border_outlined,
                            color: Colors.grey[300],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class JournalListHorizontalShimmer extends StatelessWidget {
  const JournalListHorizontalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dimens.d20.h.spaceHeight,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.d20),
          child: Text(
            "Drafts",
            style: Style.nunRegular(
              fontSize: Dimens.d16,
            ),
          ),
        ),
        Dimens.d20.h.spaceHeight,
        Padding(
          padding: const EdgeInsets.only(right: Dimens.d20),
          child: SizedBox(
            height: Dimens.d92.h,
            child: ListView.builder(
                itemCount: 10,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: Dimens.d20),
                    height: Dimens.d92,
                    width: Dimens.d325,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Dimens.d16.radiusAll,
                    ),
                    child: Row(
                      children: [
                        ShimmerWidget.rectangular(
                          width: Dimens.d92,
                          height: Dimens.d92,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: Dimens.d16.radiusAll,
                          ),
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
                }),
          ),
        ),
      ],
    );
  }
}

class JournalListAffirmationShimmer extends StatelessWidget {
  const JournalListAffirmationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimens.d16),
          child: ShimmerWidget.rectangular(
            height: Dimens.d128.h,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: Dimens.d16.radiusAll,
            ),
          ),
        );
      },
    );
  }
}

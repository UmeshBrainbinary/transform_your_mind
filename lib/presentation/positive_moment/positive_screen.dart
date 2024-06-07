import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_affirmation_page.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class PositiveScreen extends StatefulWidget {
  const PositiveScreen({super.key});

  @override
  State<PositiveScreen> createState() => _PositiveScreenState();
}

class _PositiveScreenState extends State<PositiveScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  ThemeController themeController = Get.find<ThemeController>();
  PositiveController positiveController = Get.put(PositiveController());
  late ScrollController scrollController = ScrollController();
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);

  @override
  void initState() {
    scrollController.addListener(() {
      //scroll listener
      double showOffset = 10.0;

      if (scrollController.offset > showOffset) {
        showScrollTop.value = true;
      } else {
        showScrollTop.value = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "positiveMoments".tr,
        showBack: true,
        action: Padding(
          padding: const EdgeInsets.only(right: Dimens.d20),
          child: GestureDetector(
            onTap: () {
              _onAddClick(context);
            },
            child: SvgPicture.asset(
              ImageConstant.addTools,
              height: Dimens.d22,
              width: Dimens.d22,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Dimens.d15.h.spaceHeight,
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.themeColor.withOpacity(0.1),
                    blurRadius: Dimens.d8,
                  )
                ],
              ),
              child: CommonTextField(
                  onChanged: (value) {
                    setState(() {
                      /*  exploreController.filteredList =
                        exploreController.filterList(value,
                            exploreController.exploreList);*/
                    });
                  },
                  suffixIcon: SvgPicture.asset(ImageConstant.searchExplore,
                      height: 40, width: 40),
                  hintText: "search".tr,
                  controller: searchController,
                  focusNode: searchFocusNode),
            ),
            Dimens.d30.h.spaceHeight,
            Expanded(
              child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: Dimens.d20),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 2,
                    // Number of columns
                    crossAxisSpacing: 20,
                    // Spacing between columns
                    mainAxisSpacing: 20, // Spacing between rows
                  ),
                  itemCount: positiveController.positiveMomentList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        searchFocusNode.unfocus();
                        _showAlertDialog(context);
                        // _onTileClick(index, context);
                      },
                      child: Container(
                        height: 156,
                        width: 156,
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                            color: ColorConstant.colorDCE9EE,
                            borderRadius: BorderRadius.circular(18)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              positiveController.positiveMomentList[index]
                                  ["img"],
                              height: 101,
                              width: 138,
                            ),
                            /*      CustomImageView(
                                      imagePath: positiveController
                                          .positiveMomentList[index]['image'],
                                      height: Dimens.d135,
                                      radius: BorderRadius.circular(10),
                                      fit: BoxFit.cover,
                                    ),*/
                            Dimens.d12.spaceHeight,
                            Text(
                              positiveController.positiveMomentList[index]
                                  ['title'],
                              maxLines: Dimens.d2.toInt(),
                              style:
                                  Style.montserratMedium(fontSize: Dimens.d14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              //backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.0), // Set border radius
              ),
              actions: <Widget>[
                Dimens.d21.spaceHeight,
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      ImageConstant.closePositive,
                      height: 28,
                      width: 28,
                    )),
                Dimens.d10.spaceHeight,
                Image.asset(ImageConstant.moment),
                Dimens.d15.spaceHeight,
                Center(
                  child: Text(
                    "Meditation".tr,
                    style: Style.cormorantGaramondBold(fontSize: 22),
                  ),
                ),
                Dimens.d20.spaceHeight,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  child: Text(
                    "Ever wondered why addiction takes hold? From innocent curiosity to relentless cravings, uncover the roots of addiction and empower yourself with knowledge.",
                    textAlign: TextAlign.center,
                    style: Style.montserratRegular(fontSize: 12)
                        .copyWith(height: 2),
                  ),
                ),
                Dimens.d22.spaceHeight,
              ],
            );
          },
        );
      },
    );
  }

  void _onAddClick(BuildContext context) {
    final subscriptionStatus = "SUBSCRIBED";

    /// to check if item counts are not more then the config count in case of no subscription
    if (!(subscriptionStatus == "SUBSCRIBED" ||
        subscriptionStatus == "SUBSCRIBED")) {
      /*  Navigator.pushNamed(context, SubscriptionPage.subscription, arguments: {
        AppConstants.isInitialUser: AppConstants.noSubscription,
        AppConstants.subscriptionMessage: i10n.journalNoSubscriptionMessage,
      });*/
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const AddAffirmationPage(
            isFromMyAffirmation: true,
            isEdit: false,
          );
        },
      )).then(
        (value) {
          setState(() {});
        },
      );
    }
  }
}

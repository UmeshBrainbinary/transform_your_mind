import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "account".tr),
      body: Stack(
        children: [
          Positioned(
            top: Dimens.d120,
            right: 0,
            left:  null,
            child: Image.asset(ImageConstant.bgStar, height: Dimens.d287),
          ),

        ],
      ),
    );
  }
}

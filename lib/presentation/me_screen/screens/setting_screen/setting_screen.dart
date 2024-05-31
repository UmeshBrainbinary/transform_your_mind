import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_controller.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_controller.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_controller.dart';
import 'package:transform_your_mind/routes/app_routes.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/app_confirmation_dialog.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class SettingScreen extends StatelessWidget {
   SettingScreen({super.key});

   SettingController settingController = Get.put(SettingController());
   ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? ColorConstant.black : ColorConstant.backGround,
      appBar: CustomAppBar(
      title: "settings".tr,
        action: Row(
          children: [
            GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(ImageConstant.notification, height: Dimens.d30, width: Dimens.d30)
            ),
            Dimens.d20.spaceWidth
          ],
        )
    ),
      body: Stack(
        children: [
         /* Positioned(
            top: Dimens.d120,
            right: 0,
            left:  null,
            child: Image.asset(ImageConstant.bgStar, height: Dimens.d253),
          ),*/
           Padding(
               padding: Dimens.d20.paddingHorizontal,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(
                   child: ListView(
                     shrinkWrap: true,
                     physics: const ClampingScrollPhysics(),
                     padding: const EdgeInsets.only(bottom: 50, top: 30),
                     children: [
                       Container(
                         decoration: BoxDecoration(
                           color: ColorConstant.transparent,
                           borderRadius: BorderRadius.circular(Dimens.d16),
                         ),
                         child: ListView.separated(
                           physics: const NeverScrollableScrollPhysics(),
                           shrinkWrap: true,
                           clipBehavior: Clip.none,
                           padding: EdgeInsets.zero,
                           itemBuilder: (context, index) {
                             var data = settingController.settingsData[index];
                             return
                             //   index == 1
                             //     ?  Container(
                             //   margin: const EdgeInsets.symmetric(horizontal: 1.2),
                             //   decoration: BoxDecoration(
                             //       color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white,
                             //       borderRadius: BorderRadius.circular(50),
                             //       boxShadow: [
                             //         BoxShadow(
                             //             color: ColorConstant.grey.withOpacity(0.1),
                             //             blurRadius: 5,spreadRadius: 1
                             //         )
                             //       ]
                             //   ),
                             //   padding: const EdgeInsets.symmetric(
                             //     horizontal: Dimens.d10,
                             //     vertical: Dimens.d10,
                             //   ),
                             //   child: Row(
                             //     mainAxisSize: MainAxisSize.min,
                             //     children: [
                             //
                             //       Container(
                             //         height: Dimens.d50.h,
                             //         width: Dimens.d50,
                             //         padding: const EdgeInsets.all(10),
                             //         decoration: BoxDecoration(
                             //           color: ColorConstant.themeColor,
                             //           shape: BoxShape.circle,),
                             //         child: SvgPicture.asset(
                             //           ImageConstant.settingsPersonalization,
                             //           color: ColorConstant.white,
                             //         ),
                             //       ),
                             //       Dimens.d12.spaceWidth,
                             //       Text(
                             //         "theme".tr,
                             //         style: Style.montserratMedium().copyWith(
                             //           letterSpacing: Dimens.d0_16,
                             //         ),
                             //       ),
                             //       Spacer(),
                             //       CustomSwitch(
                             //         value: themeController.isDarkMode.value,
                             //         onChanged: (value) async{
                             //           themeController.switchTheme();
                             //           Get.forceAppUpdate();
                             //         },
                             //         width: 50.0,
                             //         height: 25.0,
                             //         activeColor: ColorConstant.themeColor,
                             //         inactiveColor: ColorConstant.backGround,
                             //       ),
                             //
                             //     ],
                             //   ),
                             // )
                             //   :
                             SettingListItem(
                               isSettings: true,
                               prefixIcon: data.prefixIcon,
                               title: data.title,
                               //suffixIcon: data.suffixIcon,
                               onTap: () {
                                  if(index==0){
                                    Get.toNamed(AppRoutes.notificationSetting);
                                  } else if(index==1){
                                    Get.toNamed(AppRoutes.personalisationsScreen);
                                  } else if(index==2){
                                   Get.toNamed(AppRoutes.accountScreen);
                                 }
                               },
                             );
                           },
                           separatorBuilder: (context, index) => Padding(
                             padding: Dimens.d20.paddingHorizontal,
                             child: const SizedBox(height: 15,),
                           ),
                           itemCount: settingController.settingsData.length,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Center(
                   child: CommonElevatedButton(
                     title: "logout".tr,
                     // textStyle: Style.montserratMedium(
                     //   color: ColorConstant.white,
                     //   fontSize: Dimens.d14,
                     // ),
                     onTap: () {
                       showAppConfirmationDialog(
                         context: context,
                         message: "areYouSureWantToLogout?".tr,
                         primaryBtnTitle: "no".tr,
                         secondaryBtnTitle: "yes".tr,
                         secondaryBtnAction: () {



                           RegisterController registerController = Get.put(RegisterController());
                           registerController.nameController.clear();
                           registerController.emailController.clear();
                           registerController.passwordController.clear();
                           registerController.dobController.clear();
                           registerController.genderController.clear();
                           registerController.imageFile.value = null;

    if(PrefService.getBool(PrefKey.isRemember) == false) {
      LoginController loginController = Get.put(LoginController());
      loginController.emailController.clear();
      loginController.passwordController.clear();
      loginController.rememberMe.value = false;
    }



                           Get.offAllNamed(AppRoutes.loginScreen);
                           PrefService.setValue(PrefKey.isLoginOrRegister, false);
                         },
                       );
                     },
                   ),
                 ),
                 Dimens.d30.spaceHeight,
               ],
             ),
           )
        ],
      ),
    );
  }
}




class SettingListItem extends StatelessWidget {
  SettingListItem({
    Key? key,
    required this.prefixIcon,
    required this.title,
    //required this.suffixIcon,
    required this.isSettings,
    this.onTap,
  }) : super(key: key);

  final String prefixIcon;
  final String title;
  //final String suffixIcon;
  final bool isSettings;
  final VoidCallback? onTap;

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return

      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.2),
          decoration: BoxDecoration(
              color: themeController.isDarkMode.value ? ColorConstant.textfieldFillColor : ColorConstant.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                    color: ColorConstant.grey.withOpacity(0.1),
                    blurRadius: 5,spreadRadius: 1
                )
              ]
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.d10,
            vertical: Dimens.d10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                height: Dimens.d50.h,
                width: Dimens.d50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorConstant.themeColor,
                  shape: BoxShape.circle,),
                child: SvgPicture.asset(
                  prefixIcon,
                  color: ColorConstant.white,
                ),
              ),
              Dimens.d12.spaceWidth,
              Expanded(
                child: Text(
                  title,
                  style: Style.montserratMedium().copyWith(
                    letterSpacing: Dimens.d0_16,
                  ),
                ),
              ),

            ],
          ),
        ),
      );

  }


}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  CustomSwitch({
    required this.value,
    required this.onChanged,
    this.width = 50.0,
    this.height = 20.0,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: _value ? widget.activeColor : widget.inactiveColor,
        ),
        child: Row(
          mainAxisAlignment:
          _value ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: widget.height - 2,
              height: widget.height - 2,
              margin: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


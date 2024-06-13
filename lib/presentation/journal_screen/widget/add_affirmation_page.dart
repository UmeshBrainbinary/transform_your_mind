import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/progress_dialog_utils.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';

import '../../../core/utils/prefKeys.dart';

class AddAffirmationPage extends StatefulWidget {
  final bool isFromMyAffirmation;
  final bool? isEdit;
  final bool? isSaved;
  final int? index;
  final String? title, des,id;

  const AddAffirmationPage(
      {required this.isFromMyAffirmation,
      this.isSaved,
      this.title,
      this.des,
      this.isEdit,
      this.index,
      this.id,
      super.key});

  @override
  State<AddAffirmationPage> createState() => _AddAffirmationPageState();
}

class _AddAffirmationPageState extends State<AddAffirmationPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  ValueNotifier<int> currentLength = ValueNotifier(0);

  final TextEditingController descController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();

  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  String? urlImage;
  File? selectedImage;
  late final AnimationController _lottieIconsController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loader = false;
  @override
  void initState() {
    if (widget.title != null) {
      setState(() {
        titleController.text = widget.title.toString();
      });
    }
    if (widget.des != null) {
      setState(() {
        descController.text = widget.des.toString();
      });
    }
    _lottieIconsController = AnimationController(vsync: this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.initState();
  }

  addAffirmation() async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };

    var request = http.MultipartRequest('POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.addAffirmation}'));
    request.fields.addAll({
      'created_by':PrefService.getString(PrefKey.userId),
      'name': titleController.text,
      'description': descController.text
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      showSnackBarSuccess(context, "successfullyAffirmation".tr);
      setState(() {});
      Get.back();
    }
    else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }

  }
  updateAffirmation() async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${EndPoints.baseUrl}${EndPoints.updateAffirmation}${widget.id}'));
    request.fields.addAll({
      "name": titleController.text,
      "description": descController.text,
      "created_by": PrefService.getString(PrefKey.userId)
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      showSnackBarSuccess(context, "affirmationSuccessfully".tr);
      setState(() {});
      Get.back();
    }
    else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? ColorConstant.black
            : ColorConstant.backGround,
        appBar: CustomAppBar(
          title: widget.isEdit! ? "editAffirmation".tr : "addAffirmation".tr,
          action: !(widget.isFromMyAffirmation)
              ? Row(children: [
                  GestureDetector(onTap: () {}, child: Text("skip".tr)),
                  Dimens.d20.spaceWidth,
                ])
              : const SizedBox.shrink(),
        ),
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: CustomScrollViewWidget(
                          child: LayoutContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Dimens.d20.spaceHeight,
                                CommonTextField(
                                    hintText: "enterTitle".tr,
                                    labelText: "title".tr,
                                    controller: titleController,
                                    focusNode: titleFocus,
                                    prefixLottieIcon: ImageConstant.lottieTitle,
                                    maxLength: maxLength,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          maxLength),
                                    ],
                                    validator: (value) {
                                      if (value == "") {
                                        return "pleaseEnterTitle".tr;
                                      }
                                      return null;
                                    }),
                                Dimens.d16.spaceHeight,
                                Stack(
                                  children: [
                                    CommonTextField(
                                      hintText: "enterDescription".tr,
                                      labelText: "description".tr,
                                      controller: descController,
                                      focusNode: descFocus,
                                      transform: Matrix4.translationValues(
                                          0, -108.h, 0),
                                      prefixLottieIcon:
                                          ImageConstant.lottieDescription,
                                      maxLines: 15,
                                      maxLength: maxLengthDesc,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(
                                            maxLengthDesc),
                                      ],
                                      validator: (value) {
                                        if (value == "") {
                                          return "pleaseEnterDescription".tr;
                                        }
                                        return null;
                                      },
                                      onChanged: (value) => currentLength
                                          .value = descController.text.length,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                    ),
                                  ],
                                ),
                                Dimens.d30.h.spaceHeight,
                                Row(
                                  children: [
                                    !widget.isEdit!?const SizedBox():Expanded(
                                      child: CommonElevatedButton(
                                        title: "cancel".tr,
                                        outLined: true,
                                        textStyle: Style.montserratRegular(
                                            color: ColorConstant.textDarkBlue),
                                        onTap: () {
                                          setState(() {});
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    Dimens.d20.spaceWidth,
                                    Expanded(
                                      child: CommonElevatedButton(
                                        textStyle: Style.montserratRegular(
                                            fontSize: Dimens.d14,
                                            color: ColorConstant.white),
                                        title: widget.isEdit!
                                            ? "update".tr
                                            : "save".tr,
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (widget.isEdit!) {
                                              updateAffirmation();
                                            } else {
                                              addAffirmation();

                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Dimens.d10.spaceHeight,
                    ],
                  ),
                );
              },
            ),
            loader==true?const CommonLoader():const SizedBox()
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0), // Set border radius
          ),
          actions: <Widget>[
            Dimens.d18.spaceHeight,
            Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      ImageConstant.close,
                    ))),
            Center(
                child: SvgPicture.asset(
              ImageConstant.success,
              height: Dimens.d128,
              width: Dimens.d128,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "Affirmation updated successfully".tr,
                  style: Style.montserratRegular(
                    fontSize: Dimens.d12,
                  )),
            ),
            Dimens.d20.spaceHeight,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.d70.h),
              child: CommonElevatedButton(
                textStyle: Style.montserratRegular(
                    fontSize: Dimens.d12, color: ColorConstant.white),
                title: "ok".tr,
                onTap: () {
                  Get.back();
                  Get.back();
                },
              ),
            )
          ],
        );
      },
    );
  }
}

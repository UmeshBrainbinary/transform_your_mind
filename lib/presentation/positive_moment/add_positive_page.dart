import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/layout_container.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/image_utills.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/size_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/create_positive_moment_model.dart';
import 'package:transform_your_mind/model_class/update_positive_moment_model.dart';
import 'package:transform_your_mind/presentation/home_screen/widgets/add_image_gratitude.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:transform_your_mind/widgets/custom_view_controller.dart';
import 'package:transform_your_mind/widgets/image_picker_action_sheet.dart';

class AddPositivePage extends StatefulWidget {
  final bool isFromMyAffirmation;
  final bool? isEdit;
  final bool? isSaved;
  final String? title, des, image;
  final String? id;

  const AddPositivePage(
      {required this.isFromMyAffirmation,
      this.isSaved,
      this.title,
      this.des,
      this.isEdit,
      this.id,
      this.image,
      super.key});

  @override
  State<AddPositivePage> createState() => _AddPositivePageState();
}

class _AddPositivePageState extends State<AddPositivePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  ValueNotifier<int> currentLength = ValueNotifier(0);

  ThemeController themeController = Get.find<ThemeController>();
  bool imageValid = false;
  final FocusNode titleFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  int maxLength = 50;
  int maxLengthDesc = 2000;
  String? urlImage;
  File? selectedImage;
  late final AnimationController _lottieIconsController;
  bool _isImageRemoved = false;
  Rx<bool> loader = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreatePositiveMomentsModel createPositiveMomentsModel =
      CreatePositiveMomentsModel();
  UpdatePositiveMomentsModel updatePositiveMomentsModel =
      UpdatePositiveMomentsModel();

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
    if (widget.image != null) {
      setState(() {
        urlImage = widget.image.toString();
      });
    }

    _lottieIconsController = AnimationController(vsync: this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.initState();
  }

  createPositiveMoment() async {
    loader.value = true;

    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse(EndPoints.createPositiveMoment));
      request.fields.addAll({
        'title': titleController.text.trim(),
        'description': descController.text.trim(),
        'created_by':PrefService.getString(PrefKey.userId)
      });
      if (imageFile.value != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.value!.path));
      }
      // request.files.add(await http.MultipartFile.fromPath('image', imageFile.value!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        loader.value = false;
        showSnackBarSuccess(context, "momentCreatedSuccess".tr);
        Get.back();
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
    loader.value = false;
  }

  updatePositiveMoments(filteredBookmark) async {
    try {
      var headers = {
        'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
      };

      var request = http.MultipartRequest('POST',
          Uri.parse('${EndPoints.updatePositiveMoment}$filteredBookmark'));

      request.fields.addAll({
        'title': titleController.text.trim(),
        'description': descController.text.trim(),
      });
      if (imageFile.value != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', imageFile.value!.path));
      }
      request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
        showSnackBarSuccess(context, "positiveUpdated".tr);
        Get.back();
        } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e) {
      loader.value = false;

      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.value
            ? ColorConstant.darkBackground
            : ColorConstant.backGround,
        appBar: CustomAppBar(
          title: widget.isEdit!
              ? "editPositiveMoments".tr
              : "addPositiveMoments".tr,
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
                                Text(
                                  "addImage".tr,
                                  style: Style.montserratRegular(fontSize: 14),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: imageFile,
                                  builder: (context, value, child) {
                                    return AddGratitudeImageWidget(
                                      onTap: () async {
                                        await showImagePickerActionSheet(
                                                context)
                                            ?.then((value) async {
                                          if (value != null) {
                                            imageFile.value =
                                                await ImageUtils.compressImage(
                                                    value);
                                            imageFile.value = value;
                                          }
                                        });
                                      },
                                      onDeleteTap: () async {
                                        imageFile = ValueNotifier(null);
                                        urlImage = null;
                                        _isImageRemoved = true;
                                        setState(() {});
                                      },
                                      image: imageFile.value,
                                      imageURL: urlImage,
                                    );
                                  },
                                ),
                                imageValid == true
                                    ? Text(
                                        "imageRequired".tr,
                                        style: Style.montserratRegular(
                                            color: ColorConstant.colorFF0000,
                                            fontSize: Dimens.d12),
                                      )
                                    : const SizedBox(),
                                Dimens.d20.spaceHeight,
                                CommonTextField(
                                  hintText: "enterTitle".tr,
                                  labelText: "title".tr,
                                  controller: titleController,
                                  focusNode: titleFocus,
                                  prefixLottieIcon: ImageConstant.lottieTitle,
                                  maxLength: maxLength,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(maxLength),
                                  ],
                                  validator: (value) {
                                    if (value == "") {
                                      return "pleaseEnterTitle".tr;
                                    }
                                    return null;
                                  },
                                ),
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
                                Dimens.d20.h.spaceHeight,
                                Row(
                                  children: [
                                    if (widget.isEdit!)
                                      Expanded(
                                        child: CommonElevatedButton(
                                          title: "cancel".tr,
                                          outLined: true,
                                          textStyle: Style.montserratRegular(
                                              color:
                                                  ColorConstant.textDarkBlue),
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {});
                                              Get.back();
                                            }
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
                                        onTap: () async {
                                          titleFocus.unfocus();
                                          descFocus.unfocus();
                                          if (_formKey.currentState!
                                                      .validate() &&
                                                  imageFile.value != null ||
                                              urlImage != null) {
                                            setState(() {
                                              imageValid = false;
                                            });
                                            if (widget.isEdit!) {
                                              await updatePositiveMoments(
                                                  widget.id);
                                              /* _showAlertDialog(context);*/
                                            } else {
                                              await createPositiveMoment();
                                            }
                                          } else {
                                            setState(() {
                                              imageValid = true;
                                            });
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
            Obx(
              () => loader.isTrue ? commonLoader() : const SizedBox(),
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
              ImageConstant.affirmationSuccessTools,
              height: Dimens.d128,
              width: Dimens.d128,
            )),
            Dimens.d20.spaceHeight,
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "areYouSureYouWantToDeletePo".tr,
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
                  updatePositiveMoments(widget.id);
                  // Get.back();
                  // Get.back();
                },
              ),
            )
          ],
        );
      },
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/common_widget/snack_bar.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/common_model.dart';
import 'package:transform_your_mind/model_class/feedback_model.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/common_elevated_button.dart';
import 'package:transform_your_mind/widgets/common_text_field.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController descController = TextEditingController();
  FocusNode descFocus = FocusNode();
  int maxLength = 50;
  int maxLengthDesc = 2000;
  ValueNotifier<int> currentLength = ValueNotifier(0);
  ThemeController themeController = Get.put(ThemeController());
  int? _currentRating = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CommonModel commonModel = CommonModel();
  FeedbackModel feedbackModel = FeedbackModel();
  bool loader = false;
  bool feedback = false;

  addFeedback() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST', Uri.parse(EndPoints.addFeedback));
    request.body = json.encode({
      "name": nameController.text,
      "title": titleController.text,
      "comment": descController.text,
      "star": _currentRating,
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "");
    } else {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message ?? "");

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  getFeedback() async {

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            "${EndPoints.getFeedback}${PrefService.getString(PrefKey.userId)}"));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      final responseBody = await response.stream.bytesToString();
      feedbackModel = feedbackModelFromJson(responseBody);

    } else {

      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message ?? "");

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  updateFeedback() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request('POST', Uri.parse("${EndPoints.updateFeedback}${feedbackModel.data?.first.id??""}"));
    request.body = json.encode({
      "name": nameController.text,
      "title": titleController.text,
      "comment": descController.text,
      "star": _currentRating,
      "created_by": PrefService.getString(PrefKey.userId)
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarSuccess(context, commonModel.message ?? "");
    } else {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();
      commonModel = commonModelFromJson(responseBody);
      showSnackBarError(context, commonModel.message ?? "");

      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    getData();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstant.backGround, // Status bar background color
      statusBarIconBrightness: Brightness.dark, // Status bar icon/text color
    ));
    super.initState();
  }

  getData() async {
    await getFeedback();
    nameController.text = feedbackModel.data?.first.name ?? "";
    titleController.text = feedbackModel.data?.first.title ?? "";
    descController.text = feedbackModel.data?.first.comment ?? "";
    _currentRating = feedbackModel.data?.first.star ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.isTrue
          ? ColorConstant.darkBackground
          : ColorConstant.backGround,
      appBar: CustomAppBar(title: "feedback".tr),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Dimens.d100),
                      child: SvgPicture.asset(ImageConstant.profile1),
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.d120),
                      child: SvgPicture.asset(ImageConstant.profile2),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Dimens.d30.spaceHeight,
                        CommonTextField(
                            hintText: "enterName".tr,
                            labelText: "name".tr,
                            controller: nameController,
                            focusNode: nameFocus,
                            nextFocusNode: titleFocus,
                            prefixLottieIcon: ImageConstant.lottieTitle,
                            validator: (value) {
                              if (value == "") {
                                return "theNameFieldIsRequired".tr;
                              }
                              return null;
                            }),
                        Dimens.d20.spaceHeight,
                        CommonTextField(
                            hintText: "enterTitle".tr,
                            labelText: "title".tr,
                            controller: titleController,
                            focusNode: titleFocus,
                            nextFocusNode: descFocus,
                            prefixLottieIcon: ImageConstant.lottieTitle,
                            validator: (value) {
                              if (value == "") {
                                return "theTitleFieldIsRequired".tr;
                              }
                              return null;
                            }),
                        Dimens.d20.spaceHeight,
                        CommonTextField(
                            hintText: "comment".tr,
                            labelText: "enterComment".tr,
                            controller: descController,
                            focusNode: descFocus,
                            transform: Matrix4.translationValues(0, -108, 0),
                            prefixLottieIcon: ImageConstant.lottieDescription,
                            maxLines: 15,
                            maxLength: maxLengthDesc,
                            onChanged: (value) {
                              currentLength.value = descController.text.length;
                            },
                            validator: (value) {
                              if (value == "") {
                                return "theCommentFiledIsRequired".tr;
                              }
                              return null;
                            }),
                        Dimens.d30.spaceHeight,
                        Text(
                          "rating".tr,
                          style: Style.cormorantGaramondBold(fontSize: 20),
                        ),
                        Dimens.d10.spaceHeight,
                        Text(
                          "howYourRate".tr,
                          style: Style.montserratRegular(fontSize: 13),
                        ),
                        Dimens.d20.spaceHeight,
                        Container(
                          height: Dimens.d54,
                          width: 315,
                          decoration: BoxDecoration(
                              color: themeController.isDarkMode.isTrue
                                  ? ColorConstant.textfieldFillColor
                                  : ColorConstant.white,
                              borderRadius: BorderRadius.circular(9)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                  onTap: () {
                                    setState.call(() {
                                      _currentRating = index + 1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: SvgPicture.asset(
                                      index < _currentRating!
                                          ? ImageConstant.rating
                                          : ImageConstant.rating,
                                      color: index < _currentRating!
                                          ? ColorConstant.colorFFC700
                                          : ColorConstant.colorD9D9D9,
                                      height: Dimens.d26,
                                      width: Dimens.d26,
                                    ),
                                  ));
                            }),
                          ),
                        ),
                        Dimens.d60.spaceHeight,
                        CommonElevatedButton(
                          title: "sendFeedback".tr,
                          onTap: () async {
                            titleFocus.unfocus();
                            nameFocus.unfocus();
                            descFocus.unfocus();
                            if (_formKey.currentState!.validate()) {
                              if((feedbackModel.data??[]).isNotEmpty){
                                await updateFeedback();
                              }else{
                                await addFeedback();

                              }
                            }
                          },
                        ),
                        Dimens.d56.spaceHeight,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          loader == true ? commonLoader() : const SizedBox()
        ],
      ),
    );
  }
}

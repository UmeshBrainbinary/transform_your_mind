import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';


Future<XFile?>? showImagePickerActionSheet(BuildContext context) async {

  final ImagePicker picker = ImagePicker();
  XFile? image;

  await showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      actions: <Widget>[
        Container(
          color: ColorConstant.white,
          child: CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context, ImageSource.camera);
            },
            child: Text("takePhoto", style: Style.montserratRegular()),
          ),
        ),
        Container(
          color: ColorConstant.white,
          child: CupertinoActionSheetAction(
            onPressed: () async {
           Get.back();

           Navigator.pop(context, ImageSource.gallery);

              //ignore: use_build_context_synchronously
            },
            child: Text("chooseFromLibrary", style: Style.montserratRegular()),
          ),
        ),
      ],
      cancelButton: Container(
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: Dimens.d10.radiusAll,
        ),
        child: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("cancel"),
        ),
      ),
    ),
  ).then((value) async {
    if (value == ImageSource.gallery) {
      try {
        image = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
      } on PlatformException {
        // showSnackBarError(context,
        //     'Please allow gallery permission from device settings to access your gallery!');
      }
    } else if (value == ImageSource.camera) {
      try {
        image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );
      } on PlatformException {
        // showSnackBarError(context,
        //     'Please allow camera permission from device settings to access your camera!');
      }
    }
  });
  return image;
}

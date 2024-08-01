import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/common_widget/custom_screen_loader.dart';
import 'package:transform_your_mind/core/service/pref_service.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/end_points.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/prefKeys.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/model_class/like_affirmation_model.dart';
import 'package:transform_your_mind/theme/theme_controller.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  ThemeController themeController = Get.find<ThemeController>();
  LikeAffirmationModel likeAffirmationModel = LikeAffirmationModel();
   bool loader = false;
   @override
  void initState() {
     getData();
    super.initState();
  }
  getData() async {
    await getAffirmationData();

  }
  getAffirmationData() async {
    setState(() {
      loader = true;
    });
    var headers = {
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.getAffirmation}&created_by=${PrefService.getString(PrefKey.userId)}&lang=${PrefService.getString(PrefKey.language).isEmpty ? "english" : PrefService.getString(PrefKey.language) != "en-US" ? "german" : "english"}&isLike=true'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        loader = false;
      });
      final responseBody = await response.stream.bytesToString();

      likeAffirmationModel = likeAffirmationModelFromJson(responseBody);

      setState(() {});
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }
  updateAffirmationLike({String? id, bool? isLiked}) async {
    setState(() {
      loader = true;
    });
    debugPrint("User Id ${PrefService.getString(PrefKey.userId)}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefService.getString(PrefKey.token)}'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${EndPoints.baseUrl}${EndPoints.updateAffirmation}$id'));

    request.fields.addAll({'isLiked': "$isLiked"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        loader = false;
      });
      setState(() {});
    } else {
      setState(() {
        loader = false;
      });
      debugPrint(response.reasonPhrase);
    }
    setState(() {
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:themeController.isDarkMode.isTrue?ColorConstant.darkBackground: ColorConstant.backGround,
        appBar: CustomAppBar(
          title: "Favourite".tr,
          showBack: true,
        ),
        body: Stack(
          children: [
            (likeAffirmationModel.data??[]).isEmpty?Center(
              child: Text(
                "dataNotFound".tr,
                style: Style.gothamMedium(
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ):Padding(
              padding: const EdgeInsets.only(top: 10),
              child: likeAffirmationModel.data!=null?ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: likeAffirmationModel.data?.length??0,
                itemBuilder: (context, index) {
                  return  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: themeController.isDarkMode.isTrue?ColorConstant.textfieldFillColor:ColorConstant.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(maxLines: 2,
                                likeAffirmationModel.data?[index].description??"",
                                style: Style.nunRegular(fontSize: 15),
                              ),
                            ),

                            GestureDetector(
                                onTap: () async {
                                  likeAffirmationModel.data?.removeAt(index);
                                  await updateAffirmationLike(id:  likeAffirmationModel.data![index].id,isLiked: false);
                                  setState(() {});
                                },
                                child: SvgPicture.asset(
                                  ImageConstant.likeRedTools,
                                  height: 18.5,
                                  width: 18.5,
                                )),
                            Dimens.d12.spaceWidth,
                          ],
                        ),

                      ],
                    ),
                  );
                },
              ):   const SizedBox(),
            ),
            loader==true?commonLoader():const SizedBox()
          ],
        ));
  }
}

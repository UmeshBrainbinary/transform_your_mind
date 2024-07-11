import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/widgets/custom_appbar.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List favList = [
    {
      "title": "Self-esteem",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Health",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Success",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Health",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
    {
      "title": "Self-esteem",
      "des":
          "Self-esteem affirmations help to replace negative thoughts with positive ones",
      "like": true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.backGround,
        appBar: CustomAppBar(
          title: "Favourite".tr,
          showBack: true,
        ),
        body: Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: favList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          favList[index]["title"],
                          style: Style.montserratRegular(fontSize: 18),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              favList.removeAt(index);
                              setState(() {});
                            },
                            child: SvgPicture.asset(
                              ImageConstant.likeRedTools,
                              height: 16.5,
                              width: 16.5,
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Text(
                        favList[index]["des"],
                        style: Style.montserratRegular(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}

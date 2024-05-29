import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transform_your_mind/core/app_export.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';


class ViewFullScreenImage extends StatefulWidget {


  const ViewFullScreenImage(
      {Key? key,

      })
      : super(key: key);

  @override
  State<ViewFullScreenImage> createState() => _ViewFullScreenImageState();
}

class _ViewFullScreenImageState extends State<ViewFullScreenImage> {


  var imageUrl = "";
  bool isNetworkImage = false;

  @override
  void initState() {
    // TODO: implement initState

    imageUrl = Get.arguments["imageUrl"];
    isNetworkImage = Get.arguments["isNetworkImage"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.black,
      body: Stack(
        children: [
          Hero(
            tag: imageUrl,
            child: isNetworkImage
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(imageUrl)),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
          ),
          Positioned(
            top: kToolbarHeight,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.close, color: ColorConstant.white)
            ),
          ),
        ],
      ),
    );
  }
}

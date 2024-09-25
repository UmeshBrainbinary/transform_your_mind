import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';

class CommonLoadImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double borderRadius;
  final bool isRounded;
  final BorderRadius? customBorderRadius;
  final String imagePath;
  String? pName;
  int? indexP;
  VoidCallback? onTap;

  CommonLoadImage({super.key,
      required this.url,
      this.imagePath = "",
      required this.width,
      required this.height,
      this.borderRadius = 0.0,
      this.isRounded = false,
      this.customBorderRadius,
      this.pName,
      this.indexP,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return imagePath.isNotEmpty
        ? Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.d16),
                  child: Image.file(
                    File(imagePath),
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: InkWell(
                  onTap: onTap,
                  child: const CircleAvatar(
                    backgroundColor: ColorConstant.themeColor,
                    radius: 12,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              )
            ],
          )
        : url.isNotEmpty
            ? CachedNetworkImage(
                height: height,
                width: width,
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: isRounded ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isRounded
                        ? null
                        : customBorderRadius ??
                            BorderRadius.circular(
                              borderRadius,
                            ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => PlaceHolderCNI(
                  width: width,
                  height: height,
                  isRounded: isRounded,
                  borderRadius: borderRadius,
                  customBorderRadius: customBorderRadius,
                ),
                errorWidget: (context, url, error) => PlaceHolderCNI(
                  width: width,
                  height: height,
                  isShowLoader: false,
                  isRounded: isRounded,
                  borderRadius: borderRadius,
                  customBorderRadius: customBorderRadius,
                ),
              )
            : PlaceHolderCNI(
                width: width,
                height: height,
                isShowLoader: false,
                isRounded: isRounded,
                borderRadius: borderRadius,
                customBorderRadius: customBorderRadius,
              );
  }
}

// Place holder widget used in cached network image
class PlaceHolderCNI extends StatelessWidget {
  const PlaceHolderCNI({
    required this.width,
    required this.height,
    this.isShowLoader = true,
    this.loaderRadius = 10.0,
    this.isRounded = false,
    this.borderRadius = 0.0,
    this.customBorderRadius,
    super.key,
  });

  final double width;
  final double height;
  final bool isShowLoader;
  final double loaderRadius;
  final bool isRounded;
  final double borderRadius;
  final BorderRadius? customBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.themeColor,
        shape: isRounded ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isRounded
            ? null
            : customBorderRadius ??
                BorderRadius.circular(
                  borderRadius,
                ),
      ),
      width: width,
      height: height,
      child: isShowLoader
          ? CupertinoActivityIndicator(
              color: ColorConstant.themeColor,
              radius: loaderRadius,
            )
          : const SizedBox.shrink(),
    );
  }
}
class CommonLoadImageNow extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final double borderRadius;
  final bool isRounded;
  final BorderRadius? customBorderRadius;
  final String imagePath;
  String? pName;
  int? indexP;
  VoidCallback? onTap;

  CommonLoadImageNow({super.key,
    required this.url,
    this.imagePath = "",
    required this.width,
    required this.height,
    this.borderRadius = 0.0,
    this.isRounded = false,
    this.customBorderRadius,
    this.pName,
    this.indexP,
    this.onTap});

  @override
  Widget build(BuildContext context) {
    return imagePath.isNotEmpty
        ? Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.d16),
            child: Image.file(
              File(imagePath),
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: InkWell(
            onTap: onTap,
            child: const CircleAvatar(
              backgroundColor: ColorConstant.themeColor,
              radius: 12,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        )
      ],
    )
        : url.isNotEmpty
        ? CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: isRounded ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isRounded
              ? null
              : customBorderRadius ??
              BorderRadius.circular(
                borderRadius,
              ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => PlaceHolderCNI(
        width: width,
        height: height,
        isRounded: isRounded,
        borderRadius: borderRadius,
        customBorderRadius: customBorderRadius,
      ),
      errorWidget: (context, url, error) => PlaceHolderCNI(
        width: width,
        height: height,
        isShowLoader: false,
        isRounded: isRounded,
        borderRadius: borderRadius,
        customBorderRadius: customBorderRadius,
      ),
    )
        : PlaceHolderCNI(
      width: width,
      height: height,
      isShowLoader: false,
      isRounded: isRounded,
      borderRadius: borderRadius,
      customBorderRadius: customBorderRadius,
    );
  }
}

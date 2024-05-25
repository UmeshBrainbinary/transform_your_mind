import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:transform_your_mind/core/utils/color_constant.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';

class CommonLoadImage extends StatefulWidget {
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

  CommonLoadImage(
      {Key? key,
      required this.url,
      this.imagePath = "",
      required this.width,
      required this.height,
      this.borderRadius = 0.0,
      this.isRounded = false,
      this.customBorderRadius,
      this.pName,
      this.indexP,
      this.onTap})
      : super(key: key);

  @override
  State<CommonLoadImage> createState() => _CommonLoadImageState();
}

class _CommonLoadImageState extends State<CommonLoadImage> {
  @override
  Widget build(BuildContext context) {
    return widget.imagePath.isNotEmpty
        ? Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.d16),
                  child: Image.file(
                    File(widget.imagePath),
                    height: widget.height,
                    width: widget.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: InkWell(
                  onTap: widget.onTap,
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
        : widget.url.isNotEmpty
            ? CachedNetworkImage(
                height: widget.height,
                width: widget.width,
                imageUrl: widget.url,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape:
                        widget.isRounded ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: widget.isRounded
                        ? null
                        : widget.customBorderRadius ??
                            BorderRadius.circular(
                              widget.borderRadius,
                            ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => PlaceHolderCNI(
                  width: widget.width,
                  height: widget.height,
                  isRounded: widget.isRounded,
                  borderRadius: widget.borderRadius,
                  customBorderRadius: widget.customBorderRadius,
                ),
                errorWidget: (context, url, error) => PlaceHolderCNI(
                  width: widget.width,
                  height: widget.height,
                  isShowLoader: false,
                  isRounded: widget.isRounded,
                  borderRadius: widget.borderRadius,
                  customBorderRadius: widget.customBorderRadius,
                ),
              )
            : PlaceHolderCNI(
                width: widget.width,
                height: widget.height,
                isShowLoader: false,
                isRounded: widget.isRounded,
                borderRadius: widget.borderRadius,
                customBorderRadius: widget.customBorderRadius,
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
    Key? key,
  }) : super(key: key);

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

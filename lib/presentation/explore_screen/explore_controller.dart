import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController{
  ValueNotifier<bool> showScrollTop = ValueNotifier(false);
  final List exploreList = [

  ];

  ScrollController scrollController = ScrollController();
  RxBool isScrollingOrNot = false.obs;

  @override
  void onInit() {
    // isScrollingOrNot.value = true;
    //
    // if (scrollController.offset <=
    //     scrollController.position.minScrollExtent &&
    //     !scrollController.position.outOfRange) {
    //   // If scrolled to the top, set _isScrollingOrNot to false
    //   isScrollingOrNot.value = false;
    // }
    super.onInit();
  }

}


import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';

class CustomTabBar extends StatefulWidget {
  final List<Widget> listOfItems;
  final Color bgColor;
  final double borderCurve;
  final TabController tabController;
  final Function(int value)? onTapCallBack;
  final Color? selectedLabelColor;
  final Color? unSelectedLabelColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unSelectedLabelStyle;
  final TabBarIndicatorSize? tabBarIndicatorSize;
  final EdgeInsets? labelPadding;
  final EdgeInsets? padding;
  final bool isScrollable;

  const CustomTabBar({
    Key? key,
    required this.listOfItems,
    required this.tabController,
    this.bgColor = Colors.white,
    this.borderCurve = Dimens.d90,
    this.onTapCallBack,
    this.selectedLabelColor,
    this.unSelectedLabelColor,
    this.selectedLabelStyle,
    this.unSelectedLabelStyle,
    this.tabBarIndicatorSize,
    this.labelPadding,
    this.padding,
    this.isScrollable = false,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: widget.isScrollable,
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      indicator: BoxDecoration(
        borderRadius:
            BorderRadius.circular(widget.borderCurve), // Creates border
        color: widget.bgColor,
      ),
      indicatorSize: widget.tabBarIndicatorSize ?? TabBarIndicatorSize.tab,
      tabs: widget.listOfItems,
      controller: widget.tabController,
      onTap: (value) {
        widget.onTapCallBack?.call(value);
      },
      labelColor: widget.selectedLabelColor,
      labelStyle: widget.selectedLabelStyle,
      unselectedLabelColor: widget.unSelectedLabelColor,
      unselectedLabelStyle: widget.unSelectedLabelStyle,
      padding: widget.padding,
      labelPadding: widget.labelPadding,
    );
  }
}

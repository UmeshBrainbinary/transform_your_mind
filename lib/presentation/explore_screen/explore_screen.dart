import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.backGround,
        body: Column(children: [
          Text("Explore Screen",style: TextStyle(color: Colors.black),)
      
        ],),
      ),
    );
  }
}

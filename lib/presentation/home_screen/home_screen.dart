import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.backGround,
        body: Column(children: [
          Text("Home Screen",style: TextStyle(color: Colors.black),)
        ],),
      ),
    );
  }
}

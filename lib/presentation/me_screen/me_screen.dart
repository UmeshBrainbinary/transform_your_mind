import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Column(children: [
          Text("Me Screen",style: TextStyle(color: Colors.black),)
      
        ],),
      ),
    );
  }
}

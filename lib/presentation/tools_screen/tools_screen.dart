import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/color_constant.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Column(children: [
          Text("Tools  Screen",style: TextStyle(color: Colors.black),)
      
        ],),
      ),
    );
  }
}

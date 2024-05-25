import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/image_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             Image.asset(ImageConstant.splashLogo),
            ElevatedButton(
              style:  ButtonStyle(),
                onPressed: (){},
                child: Text("fgsdfg"))
          ],
        ),
      )
    );
  }
}

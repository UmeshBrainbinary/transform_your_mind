import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/style.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const AddGratitudePage(
            registerUser: true,
            isFromMyGratitude: true,
            isSaved: true,);
        },));
      },
        child: Center(
          child:   Text("Skip", style:Style.montserratRegular(
            fontSize: Dimens.d15,
            color: Colors.black,
          ),)
        ),
      ),
    );
  }
}

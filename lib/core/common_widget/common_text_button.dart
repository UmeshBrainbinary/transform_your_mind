import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/style.dart';


class CommonTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const CommonTextButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: textStyle ?? Style.montserratRegular(),
      ),
    );
  }
}


Widget welcomeTextTitle({String? title}){
  return   Text(
    title!,
    style: Style.montserratRegular(
        color: Colors.black, fontSize: 19),
  );

}
Widget welcomeTextDescriptionTitle({String? title}){
  return     Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 18),
    child: Text(
      title!,
      textAlign: TextAlign.center,
      style: Style.montserratRegular(
          color: Colors.black.withOpacity(0.8), fontSize: 12),
    ),
  );

}
import 'dart:ui';
import 'package:flutter/material.dart';

class CommonDialogWithCloseIcon {
  CommonDialogWithCloseIcon.show(
      {required BuildContext context,
      required Widget child,
      required double width,
      bool showCrossIcon = true,
      barrierDismiss = true}) {
    // final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

    showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismiss,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Center(
              child: Container(
            width: width - 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          )),
        );
      },
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return DialogTransition(
          curvedValue: curvedValue,
          opacity: a1.value,
          child: widget,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class DialogTransition extends StatelessWidget {
  const DialogTransition({
    Key? key,
    required this.curvedValue,
    required this.opacity,
    required this.child,
  }) : super(key: key);

  final double curvedValue;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Transform(
        transform: Matrix4.translationValues(
          0.0,
          -curvedValue * 200,
          0.0,
        ),
        child: Opacity(
          opacity: opacity,
          child: child,
        ),
      ),
    );
  }
}

class CommonDialogWithCloseIconCleanse {
  CommonDialogWithCloseIconCleanse.show(
      {required BuildContext context,
        required Widget child,
        required double width,
        bool showCrossIcon = true,
        barrierDismiss = true}) {
    // final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

    showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismiss,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {

        return Material(
          color: Colors.transparent,
          child: Center(
              child: Container(
                width: width - 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: child,
              )),
        );
      },
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return DialogTransition(
          curvedValue: curvedValue,
          opacity: a1.value,
          child: widget,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
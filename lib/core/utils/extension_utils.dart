import 'package:flutter/material.dart';



extension SizedBoxSet on double {
  Widget get spaceHeight => SizedBox(
        height: this,
      );

  Widget get spaceWidth => SizedBox(
        width: this,
      );
}

extension BorderRadiusAll on double {
  BorderRadius get radiusAll => BorderRadius.all(Radius.circular(this));
}

extension PaddingAll on double {
  EdgeInsets get paddingAll => EdgeInsets.all(this);

  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: this);

  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: this);
}

extension StringUtil on String? {
  String? getFileExtension() {
    try {
      if (this?.split('.').isNotEmpty ?? false) {
        return ".${this!.split('.').last}";
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

extension DurationExt on Duration {
  String get formatHHMM {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "{h > 0 ? '{twoDigits(inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
  }
}

String formatDurationInHhMmSs(Duration duration) {
  // ignore: non_constant_identifier_names
  // final HH = (duration.inHours).toString().padLeft(2, '0');
  final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');

  return '$mm:$ss';
}

extension ObjectUtils on Object {
  Object convertToStateValue(bool isPositive) {
    if (this is num) {
      var value = isPositive
          ? (this as num) > 0.0
              ? this
              : 0
          : (this as num) > 0.0
              ? 0
              : (this as num).abs();
      print("isPositive $isPositive value $value this $this");
      return value;
    }
    return this;
  }
}

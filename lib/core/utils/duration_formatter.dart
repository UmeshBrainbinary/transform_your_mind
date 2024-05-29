extension DurationFormatter on Duration {
  String get durationFormatter {
    return toString().substring(2, 7);
    /*if (inHours == 0) {
      return toString().split('.').first.padLeft(8, "0");
    } else {
      return toString().substring(2, 7);
    }*/
  }
}

formatedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}

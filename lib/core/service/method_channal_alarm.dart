import 'package:flutter/services.dart';

class AlarmService {
  static const MethodChannel _channel = MethodChannel('com.app.transformyourmind');

  static Future<void> setAlarm(int hour, int minute, String title) async {
    try {
      await _channel.invokeMethod('setAlarm', {
        'hour': hour,
        'minute': minute,
        'title': title,
      });
    } on PlatformException catch (e) {
      print("Failed to set alarm: '${e.message}'.");
    }
  }
}

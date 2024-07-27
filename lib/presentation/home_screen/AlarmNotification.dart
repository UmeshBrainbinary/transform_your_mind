import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:transform_your_mind/core/utils/dimensions.dart';
import 'package:transform_your_mind/core/utils/extension_utils.dart';
import 'package:transform_your_mind/core/utils/style.dart';

class AlarmNotificationScreen extends StatefulWidget {
  AlarmSettings alarmSettings;
  AlarmNotificationScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text("Alram is ringing.......",style: Style.nunRegular(),),
          Text("TransformYourMind",style: Style.nunRegular(),),
          Dimens.d20.spaceHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           /*   ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: widget.alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child:  Text("Snooze",style: Style.nunitoSemiBold(fontSize: 15),)),
              Dimens.d10.spaceWidth,*/
              ElevatedButton(
                  onPressed: () {
                    //stop alarm
                    Alarm.stop(widget.alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },
                  child:  Text("Stop",style:Style.nunitoSemiBold() ,)),
            ],
          )
        ],
      ),
    );
  }
}

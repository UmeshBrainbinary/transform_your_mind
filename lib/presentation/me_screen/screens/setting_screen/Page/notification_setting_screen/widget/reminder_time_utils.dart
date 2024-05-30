enum ReminderTime {
  reminderTime1(name: '1 time ', value: 1),
  reminderTime0(name: 'Off', value: 0),
  reminderTime3(name: '3 times ', value: 3),
  reminderTime5(name: '5 times ', value: 5),
  reminderTime8(name: '8 times ', value: 8),
  reminderTime7(name: '7 times ', value: 7),
  reminderTime10(name: '10 times ', value: 10);

  final String name;
  final int value;

  const ReminderTime({required this.name, required this.value});
}

enum ReminderPeriod {
  daily(name: 'Daily', value: 1, desc: 'in a day'),
  weekly(name: 'Weekly', value: 2, desc: 'in a week'),
  monthly(name: 'Monthly', value: 3, desc: 'in a month'),
  off(name: 'Off', value: 0, desc: '');

  final String name;
  final String desc;
  final int value;
  const ReminderPeriod({
    required this.name,
    required this.value,
    required this.desc,
  });
}

extension ReminderTimeExtension on int {
  ReminderTime get getReminderTimeFromInt {
    switch (this) {
      case 0:
        return ReminderTime.reminderTime0;
      case 1:
        return ReminderTime.reminderTime1;
      case 3:
        return ReminderTime.reminderTime3;
      case 5:
        return ReminderTime.reminderTime5;
      case 7:
        return ReminderTime.reminderTime7;
      case 8:
        return ReminderTime.reminderTime8;
      case 10:
        return ReminderTime.reminderTime10;
      default:
        return ReminderTime.reminderTime1;
    }
  }
}

extension ReminderPeriodExtension on int {
  ReminderPeriod get getReminderPeriodFromInt {
    switch (this) {
      case 1:
        return ReminderPeriod.daily;
      case 2:
        return ReminderPeriod.weekly;
      case 3:
        return ReminderPeriod.monthly;
      case 0:
        return ReminderPeriod.off;

      default:
        return ReminderPeriod.daily;
    }
  }
}

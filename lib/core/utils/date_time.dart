import 'package:intl/intl.dart';


enum FormatDateType { ddMMyyyy, ddMMMyyyy, yyyyMMdd, ddMMMMYYYY, hhmm }

class DateTimeUtils {
  static const dateFormatToParse = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static const ddMMyyyyToParse = 'dd/MM/yyyy';

  static String formatDate(DateTime dateTime,
      {FormatDateType formatDateType = FormatDateType.ddMMyyyy}) {
    final DateFormat formatter = DateFormat(_getFormat(formatDateType));
    return formatter.format(dateTime);
  }

  static String _getFormat(FormatDateType formatDateType) {
    switch (formatDateType) {
      case FormatDateType.ddMMyyyy:
        return "dd/MM/yyyy";
      case FormatDateType.ddMMMyyyy:
        return "dd MMM yyyy";
      case FormatDateType.yyyyMMdd:
        return "yyyy-MM-dd";
      case FormatDateType.ddMMMMYYYY:
        return "dd MMMM, yyyy";
      case FormatDateType.hhmm:
        return "hh:mm a";
    }
  }

  static DateTime parseDate(String date, {String format = dateFormatToParse}) {
    return date.isNotEmpty
        ? DateFormat(format).parse(date, true)
        : DateTime.now();
  }
}

// extension TimeAgo on DateTime {
//   String get timeAgo {
//     final now = DateTime.now();
//     var diff = now.difference(this);
//
//     if (diff.inDays > 365) {
//       return '${(diff.inDays / 365).floor()}${(diff.inDays / 365).floor() == 1 ? i10n.year : i10n.years} ${i10n.ago}';
//     }
//     if (diff.inDays > 30) {
//       return '${(diff.inDays / 30).floor()}${(diff.inDays / 30).floor() == 1 ? i10n.month : i10n.months} ${i10n.ago}';
//     }
//     if (diff.inDays > 7) {
//       return '${(diff.inDays / 7).floor()}${(diff.inDays / 7).floor() == 1 ? i10n.week : i10n.weeks} ${i10n.ago}';
//     }
//     if (diff.inDays > 0) {
//       return '${diff.inDays}${i10n.day} ${i10n.ago}';
//     }
//     if (diff.inHours > 0) {
//       return '${diff.inHours}${i10n.hour} ${i10n.ago}';
//     }
//     if (diff.inMinutes > 0) {
//       return '${diff.inMinutes}${i10n.minute} ${i10n.ago}';
//     }
//     return i10n.justNow;
//   }
// }

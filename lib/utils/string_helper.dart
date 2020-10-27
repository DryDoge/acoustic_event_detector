import 'package:intl/intl.dart';

class StringHelper {
  static String getDate(DateTime input, [bool withoutYear = false]) {
    if (withoutYear) {
      return DateFormat('dd. MM.').format(input);
    }
    return DateFormat('dd. MM. yyyy').format(input);
  }

  static String getYear(DateTime input) {
    return DateFormat('yyyy').format(input);
  }

  static String getTime(DateTime input) {
    return DateFormat('kk:mm').format(input);
  }
}

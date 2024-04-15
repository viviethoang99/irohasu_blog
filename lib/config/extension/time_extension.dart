import 'package:intl/intl.dart';

extension DateTimeX on DateTime? {
  String date2String() {
    return DateFormat('dd-MM-yyyy').format(this ?? DateTime.now());
  }
}

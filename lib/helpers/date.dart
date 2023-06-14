import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  var dateTime =
      DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(dateTimeString).toLocal();

  return DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
}

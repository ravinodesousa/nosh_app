import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  print("dateTimeString: ${dateTimeString}");
  if (dateTimeString == null || dateTimeString == '') {
    return '';
  }
  var dateTime =
      DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(dateTimeString).toLocal();

  return DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
}

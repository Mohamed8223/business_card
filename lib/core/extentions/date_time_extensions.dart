import 'package:intl/intl.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

extension DateTimeExtensions on DateTime {
  String timeFormat(String locale) {
    return DateFormat.jm(locale).format(this);
  }

  String timeAgo(String locale) {
    final now = DateTime.now();
    // We need to create new date to exclude the hours
    // since if 24 is not completed it will be considered today
    final date = now.copyWith(year: year, month: month, day: day);
    final differenceInDays = now.difference(date).inDays;
    if (differenceInDays > 1) {
      return DateFormat.yMMMMd(locale).format(date);
    } else if (differenceInDays > 0) {
      return S.current.DateTimeExtensions_yesterday;
    } else {
      return S.current.DateTimeExtensions_today;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

String get defaultUrl {
  if (kDebugMode) {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
  }
  return 'https://app.salingtanya.com';
}

/// Currency format for Rupiah ( IDR )
NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'id',
  decimalDigits: 0,
  name: 'Rp. ',
  symbol: 'Rp. ',
);

/// Currency format for Rupiah ( IDR )
NumberFormat currencyFormatterNoLeading =
    NumberFormat.currency(locale: 'id', decimalDigits: 0, name: '', symbol: '');

/// Compare when the time is on between
bool compareTimeIsInBetween(String start, String end) {
  final format = DateFormat('HH:mm');
  final now = DateTime.now();
  final startTime = format.parse(start);
  final endTime = format.parse(end);
  final nowTime = format.parse('${now.hour}:${now.minute}');

  if (nowTime.isAfter(startTime) && nowTime.isBefore(endTime)) {
    return true;
  }

  return false;
}

import 'package:freezed_annotation/freezed_annotation.dart';

/// Response Status after request to the server
enum ResponseStatus {
  /// State success
  success,

  /// State failure
  failure
}

enum PaymentChannelCategory {
  @JsonValue('VIRTUAL_ACCOUNT')
  virtualAccount,

  @JsonValue('RETAIL_OUTLET')
  retailOutlet,

  @JsonValue('QRIS')
  qris,

  @JsonValue('EWALLET')
  ewallet,

  @JsonValue('CREDIT_CARD')
  creditCard,

  @JsonValue('CASH')
  cash,
}

enum TransactionStatus {
  @JsonValue('ACTIVE')
  active,

  @JsonValue('PENDING')
  pending,

  @JsonValue('UNPAID')
  unpaid,

  @JsonValue('PAID')
  paid,

  @JsonValue('SETTLED')
  settled,

  @JsonValue('EXPIRED')
  expired,

  @JsonValue('CANCEL')
  cancel,
}

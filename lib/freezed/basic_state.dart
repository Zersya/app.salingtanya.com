import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_state.freezed.dart';

@freezed
class BasicState with _$BasicState {
  const factory BasicState.idle() = _Idle;
  const factory BasicState.loading() = _Loading;
}

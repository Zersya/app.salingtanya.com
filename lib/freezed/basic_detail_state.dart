import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_detail_state.freezed.dart';

@freezed
class BasicDetailState<T> with _$BasicDetailState<T> {
  const factory BasicDetailState.idle(T data) = _Idle;
  const factory BasicDetailState.loading() = _Loading;
  const factory BasicDetailState.error(String message) = _Error;
}

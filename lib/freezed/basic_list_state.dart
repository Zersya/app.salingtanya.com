import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_list_state.freezed.dart';

@freezed
class BasicListState<T> with _$BasicListState<T> {
  const factory BasicListState.idle(List<T> data) = _Idle;
  const factory BasicListState.loading() = _Loading;
  const factory BasicListState.error(String error) = _Error;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'basic_form_state.freezed.dart';

@freezed
class BasicFormState with _$BasicFormState {
  const factory BasicFormState.idle() = _Idle;
  const factory BasicFormState.succeed() = _Succeed;
  const factory BasicFormState.failed() = _Failed;
  const factory BasicFormState.loading() = _Loading;
}

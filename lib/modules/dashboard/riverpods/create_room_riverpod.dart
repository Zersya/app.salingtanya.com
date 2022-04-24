import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRoomNotifier extends StateNotifier<BasicState> {
  CreateRoomNotifier({this.onCreate}) : super(const BasicState.idle());

  final Function()? onCreate;

  final _repo = RoomsRepository();

  Future createRoom(String name) async {
    try {
      state = const BasicState.loading();

      await _repo.createRoom(name);
      onCreate?.call();

      state = const BasicState.idle();
    } catch (e) {
      state = const BasicState.idle();
    }
  }
}

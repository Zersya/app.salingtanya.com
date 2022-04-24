import 'package:app_salingtanya/freezed/basic_list_state.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomsNotifier extends StateNotifier<BasicListState<Room>> {
  RoomsNotifier() : super(const BasicListState<Room>.idle([]));

  final _repo = RoomsRepository();

  Future getRooms() async {
    try {
      state = const BasicListState<Room>.loading();

      final result = await _repo.getRooms();

      state = BasicListState<Room>.idle(result);
    } catch (e) {
      state = BasicListState<Room>.error(e.toString());
    }
  }
}

import 'package:app_salingtanya/freezed/basic_detail_state.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailRoomNotifier extends StateNotifier<BasicDetailState<Room?>> {
  DetailRoomNotifier(this.ref)
      : room = ref.read(selectedRoomProvider),
        super(BasicDetailState<Room?>.idle(ref.read(selectedRoomProvider)));

  late String roomId;

  final Room? room;
  final Ref ref;
  final _repo = RoomsRepository();

  Future getRoom() async {
    try {
      state = const BasicDetailState<Room?>.loading();

      final result = await _repo.getRoom(roomId);
      ref.read(selectedRoomProvider.notifier).state = result;

      state = BasicDetailState<Room?>.idle(result);
    } catch (e) {
      state = BasicDetailState<Room?>.error(e.toString());
    }
  }
}

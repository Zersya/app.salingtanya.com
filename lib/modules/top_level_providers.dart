import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/auth/riverpods/auth_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, BasicState>(
  (ref) => AuthNotifier(),
);

final selectedRoomProvider = StateProvider<Room?>((ref) => null);

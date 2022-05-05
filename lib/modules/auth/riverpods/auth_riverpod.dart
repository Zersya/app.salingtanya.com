import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';

class AuthNotifier extends StateNotifier<BasicState> {
  AuthNotifier() : super(const BasicState.idle());

  final _repo = AuthRepository();

  Future signInAnonymously() async {
    try {
      state = const BasicState.loading();

      await _repo.signInAnonymously();

      state = const BasicState.idle();
    } catch (e) {
      state = const BasicState.idle();
    }
  }

  Future signInGoogle(String? lastLocation) async {
    try {
      state = const BasicState.loading();

      await _repo.signInGoogle();

      if (lastLocation == null) {
        GetIt.I<NavigationHelper>().goNamed('DashboardPage');
      } else {
        GetIt.I<NavigationHelper>().goRouter.go(lastLocation);
      }

      state = const BasicState.idle();
    } catch (e) {
      state = const BasicState.idle();
    }
  }
}

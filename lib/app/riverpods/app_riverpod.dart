import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/helpers/user_helper.dart';
import 'package:app_salingtanya/utils/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class AppNotifier extends StateNotifier<BasicState> {
  AppNotifier() : super(const BasicState.loading()) {
    _init();
  }

  Future _init() async {
    state = const BasicState.loading();

    GetItContainer.initializeNavigation(isLoggedIn: false);

    late bool isLoggedIn;

    try {
      await GetIt.I<UserHelper>().getSession();

      isLoggedIn = true;
    } catch (e) {
      isLoggedIn = false;
    }

    GetIt.I<NavigationHelper>().isLoggedIn = isLoggedIn;

    state = const BasicState.idle();
  }
}

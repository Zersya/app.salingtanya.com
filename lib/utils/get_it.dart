import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/helpers/user_helper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetItContainer {
  static void initializeAppwrite(Client sdk) {
    GetIt.I.registerSingleton<Client>(sdk);
    GetIt.I.registerSingleton<Account>(Account(sdk));
    GetIt.I.registerSingleton<Databases>(Databases(sdk));
    GetIt.I.registerSingleton<Realtime>(Realtime(sdk));
    GetIt.I.registerSingleton<Teams>(Teams(sdk));
  }

  static void initializeNavigation({
    required bool isLoggedIn,
    required SharedPreferences sharedPreferences,
  }) {
    GetIt.I.registerSingleton<NavigationHelper>(
      NavigationHelper(isLoggedIn: isLoggedIn),
    );

    GetIt.I.registerSingleton<SharedPreferences>(sharedPreferences);

    GetIt.I.registerSingleton(UserHelper());

    GetIt.I.registerSingleton<FlashMessageHelper>(FlashMessageHelper());
  }
}

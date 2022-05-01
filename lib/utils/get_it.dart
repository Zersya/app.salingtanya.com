import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/helpers/user_helper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class GetItContainer {
  static void initializeAppwrite(Client sdk) {
    GetIt.I.registerSingleton<Client>(sdk);
    GetIt.I.registerSingleton<Account>(Account(sdk));
    GetIt.I.registerSingleton<Database>(Database(sdk));
    GetIt.I.registerSingleton<Realtime>(Realtime(sdk));
    GetIt.I.registerSingleton<Teams>(Teams(sdk));
  }

  static void initializeNavigation({required bool isLoggedIn}) {
    GetIt.I.registerSingleton<NavigationHelper>(
      NavigationHelper(isLoggedIn: isLoggedIn),
    );

    GetIt.I.registerSingleton(UserHelper());

    GetIt.I.registerSingleton<FlashMessageHelper>(FlashMessageHelper());
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_it/get_it.dart';

class UserHelper {
  Future<User> getUser()  {
    final account = GetIt.I<Account>();

    return account.get();
  }

  Future getSession()  async {
    final account = GetIt.I<Account>();

    return account.getSession(sessionId: 'current');
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:get_it/get_it.dart';

class UserHelper {
  String? userId;
  models.Account? user;

  Future<models.Account?> getUser() async {
    return user = await GetIt.I<Account>().get();
  }

  Future<models.Session> getSession() async {
    final account = await GetIt.I<Account>().getSession(sessionId: 'current');
    userId = account.userId;

    return account;
  }
}

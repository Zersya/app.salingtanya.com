import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get_it/get_it.dart';

class UserHelper {
  String? userId;
  User? user;

  Future<User?> getUser() async {
    return user = await GetIt.I<Account>().get();
  }

  Future<Session> getSession() async {
    final account = await GetIt.I<Account>().getSession(sessionId: 'current');
    userId = account.userId;

    return account;
  }
}

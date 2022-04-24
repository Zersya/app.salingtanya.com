import 'dart:io';

import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:app_salingtanya/utils/functions.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class AuthRepository {
  final account = GetIt.I<Account>();
  final teams = GetIt.I<Teams>();

  Future signInAnonymously() async {
    try {
      await account.createAnonymousSession();
    } on AppwriteException catch (e) {
      if (e.type == AppwriteExceptionType.kUserSessionExist) {
        return;
      }

      throw ExceptionWithMessage(e.message);
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    } finally {
      GetIt.I<NavigationHelper>().isLoggedIn = true;

      // final user = await account.get();
      //
      // await teams.createMembership(
      //   teamId: kRegisteredTeamsId,
      //   email: user.email,
      //   roles: <String>['member'],
      //   url: defaultUrl,
      // );
    }
  }

  Future signInGoogle() async {
    try {
      var redirectUrl = '$defaultUrl/auth/web.html';
      if (!kIsWeb && Platform.isAndroid) {
        redirectUrl = '$defaultUrl/auth/android.html';
      }

      await account.createOAuth2Session(
        provider: 'google',
        success: redirectUrl,
        failure: redirectUrl,
      );
      GetIt.I<NavigationHelper>().isLoggedIn = true;

      // final user = await account.get();
      //
      // await teams.createMembership(
      //   teamId: kTeamsId,
      //   email: user.email,
      //   roles: <String>['member'],
      //   url: defaultUrl,
      // );
    } on AppwriteException catch (e) {
      if (e.type == AppwriteExceptionType.kUserSessionExist) {
        return;
      }

      throw ExceptionWithMessage(e.message);
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    }
  }

  Future signOut() async {
    try {
      final session = await account.getSession(sessionId: 'current');
      await account.deleteSession(sessionId: session.$id);
    } on AppwriteException catch (e) {
      if (e.type == AppwriteExceptionType.kUserSessionNotFound) {
        return;
      }

      throw ExceptionWithMessage(e.message);
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    } finally {
      GetIt.I<NavigationHelper>().isLoggedIn = false;
    }
  }
}

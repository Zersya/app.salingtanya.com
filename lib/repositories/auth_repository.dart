import 'dart:io';

import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/helpers/user_helper.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:app_salingtanya/utils/functions.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final account = GetIt.I<Account>();
  final db = GetIt.I<Database>();

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
      await GetIt.I<UserHelper>().getSession();
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

      final session = await GetIt.I<UserHelper>().getSession();
      final prefs = GetIt.I<SharedPreferences>();
      final now = DateTime.now();

      await db.getDocument(
        collectionId: kUsersCollectionId,
        documentId: session.userId,
      );

      await db.updateDocument(
        collectionId: kUsersCollectionId,
        documentId: session.userId,
        data: <String, dynamic>{
          'active_session_id': session.$id,
          'last_login_at': now.toIso8601String(),
          'default_language': prefs.getString(kDefaultLanguage) ?? 'id',
        },
      );

      GetIt.I<NavigationHelper>().isLoggedIn = true;
    } on AppwriteException catch (e) {
      if (e.type == AppwriteExceptionType.kDocumentNotFound) {
        final session = await GetIt.I<UserHelper>().getSession();
        final prefs = GetIt.I<SharedPreferences>();
        final now = DateTime.now();

        await db.createDocument(
          collectionId: kUsersCollectionId,
          documentId: session.userId,
          data: <String, dynamic>{
            'active_session_id': session.$id,
            'last_login_at': now.toIso8601String(),
            'default_language': prefs.getString(kDefaultLanguage) ?? 'id',
          },
        );
        GetIt.I<NavigationHelper>().isLoggedIn = true;

        return;
      }
      if (e.type == AppwriteExceptionType.kUserSessionExist) {
        return;
      }

      throw ExceptionWithMessage(e.message);
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    } finally {
      await GetIt.I<UserHelper>().getUser();
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
      GetIt.I<UserHelper>().userId = null;
    }
  }
}

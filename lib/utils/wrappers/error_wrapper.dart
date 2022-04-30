import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class ErrorWrapper {
  static Future<T> guard<T>(
    Future<T> Function() f, {
    Function(Object e)? onError,
    Function(AppwriteException e)? onAppwriteError,
  }) async {
    try {
      return await f();
    } on AppwriteException catch (e) {
      onAppwriteError?.call(e);

      GetIt.I<FlashMessageHelper>().showError(e.message);

      throw ExceptionWithMessage(e.message);
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}

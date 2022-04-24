class ExceptionWithMessage implements Exception {
  ExceptionWithMessage(this.message);

  String? message;

  @override
  String toString() => message ?? ' - ';
}

class AppwriteExceptionType {
  static const kUserSessionExist = 'user_session_already_exists';
  static const kUserSessionNotFound = 'user_session_not_found';
}

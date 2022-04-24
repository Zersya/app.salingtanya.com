class ErrorWrapper {
  static Future<BaseResponse> guard<BaseResponse>(
    Future<BaseResponse> Function() f, {
    Function(Object e)? onError,
  }) async {
    try {
      return await f();
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}

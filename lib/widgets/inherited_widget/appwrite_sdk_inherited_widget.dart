
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

class AppwriteSdkProvider extends InheritedWidget {
  const AppwriteSdkProvider({
    Key? key,
    required this.sdk,
    required Widget child,
  }) : super(key: key, child: child);

  final Client sdk;

  static AppwriteSdkProvider of(BuildContext context) {
    final result =
    context.dependOnInheritedWidgetOfExactType<AppwriteSdkProvider>();
    assert(result != null, 'No AppwriteSdkProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppwriteSdkProvider oldWidget) =>
      sdk != oldWidget.sdk;
}

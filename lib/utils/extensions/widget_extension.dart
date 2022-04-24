import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Future<T?> showCustomDialog<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: this,
      ),
    );
  }
}

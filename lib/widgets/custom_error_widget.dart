import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:flutter/material.dart';

/// Widget that displays error icon with a message
class CustomErrorWidget extends StatelessWidget {
  /// Called when the widget is called into existence.
  const CustomErrorWidget({
    Key? key,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.onTap,
    this.message = 'Tap untuk refresh',
  }) : super(key: key);

  ///
  final EdgeInsets padding;

  /// Border radius of the inkwell
  final BorderRadius borderRadius;

  /// On tap can be used for callback like refresh error
  final Function()? onTap;

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.error,
                  size: 32,
                  color: ColorName.errorForeground,
                ),
                if (onTap != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColorName.errorForeground,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

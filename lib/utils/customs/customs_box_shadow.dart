import 'package:flutter/material.dart';

class CustomBoxShadow extends BoxShadow {
  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  // ignore: overridden_fields
  final BlurStyle blurStyle;

  @override
  Paint toPaint() {
    final result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(blurStyle, blurSigma);

    assert(
      () {
        if (debugDisableShadows) {
          result.maskFilter = null;
        }
        return true;
      }(),
      'Assert Debug',
    );
    return result;
  }
}

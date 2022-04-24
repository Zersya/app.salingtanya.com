import 'package:app_salingtanya/gen/assets.gen.dart';
import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:flutter/material.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.logoIndieapps.image(
            width: 200,
            height: 200,
          ),
          const Text(
            'Kita Saling Tanya',
            style: TextStyle(
              fontSize: 14,
              color: ColorName.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              ColorName.primary,
            ),
          ),
        ],
      ),
    );
  }
}

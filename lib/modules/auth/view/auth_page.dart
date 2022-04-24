import 'package:app_salingtanya/gen/assets.gen.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 280,
            height: 180,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: Assets.images.logoIndieapps.image(
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const Positioned(
                  top: 42,
                  right: 0,
                  left: 0,
                  child: Icon(Icons.favorite, color: Colors.red),
                ),
                const Positioned(
                  top: 32,
                  right: 0,
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: FlutterLogo(),
                  ),
                ),
              ],
            ),
          ),
          const _SignInWidget(),
        ],
      ),
    );
  }
}

class _SignInWidget extends ConsumerWidget {
  const _SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.maybeWhen(
      idle: () => Center(
        child: SignInButton(
          Buttons.Google,
          text: 'Sign in with Google',
          onPressed: () async {
            await ref.read(authProvider.notifier).signInGoogle();
          },
        ),
      ),
      orElse: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

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
            child: Assets.images.logoSalingtanya.image(
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                8,
              ),
            ),
          ),
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

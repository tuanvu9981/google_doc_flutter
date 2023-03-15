import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_doc_flutter/color.dart';
import 'package:google_doc_flutter/repository/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  // stateless widget, but be able to listen to changes
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref) {
    ref.watch(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef interacts with Widget. ProviderRef interacts with Provider
    ref.watch(authRepositoryProvider).signInWithGoogle();
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref),
          icon: Image.asset('assets/images/g-logo-2.png', height: 20),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(color: kBlackColor),
          ),
          style: ElevatedButton.styleFrom(
            primary: kWhiteColor,
            minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result.dart';
import '../../../entities/app_user.dart';
import '../../../features/sign_in/presentations/view/sign_in_screen.dart';
import '../../../main.dart';
import '../../../services/user_service.dart';
import '../../shared/dialogs/error_dialog.dart';
import '../../shared/dialogs/loader_dialog.dart';
import '../../shared/extensions/auth_failure_x.dart';
import '../../shared/extensions/build_context.dart';
import '../../shared/widgets/flutter_masters_rich_text.dart';
import '../home/home_screen.dart';
import '../../shared/extensions/form_field_x.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  static const String route = '/sign_up';

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final userService = UserService(FirebaseFirestore.instance);
  AppUser? user;
  late final formKey = GlobalKey<FormState>();

  Username userName = Username.pure();
  Email email = Email.pure();
  Password password = Password.pure();

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (user != null) return createUser();
    final authRepo = ref.read(authRepoProvider);
    final result = await showLoader(
      context,
      authRepo.signUp(email: email.value, password: password.value),
    );
    final record = switch (result) {
      Success(value: final user) => (user: user, failure: null),
      Err(value: final failure) => (user: null, failure: failure),
    };
    user = record.user;
    final failure = record.failure;
    if (failure != null) {
      final data = failure.errorData;
      return ErrorDialog.show(
        context,
        title: data.message,
        icon: data.icon,
      );
    }
    return createUser();
  }

  Future<void> createUser() async {
    final result = await showLoader(
      context,
      userService.createUser(
        id: user!.id,
        username: userName.value,
        email: email.value,
        photoUrl: user?.photoUrl,
      ),
    );
    final route = switch (result) {
      Success() => HomeScreen.route,
      Err() => null,
    };
    if (route != null) {
      return context.pushNamedAndRemoveUntil<void>(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: userName.validate,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        hintText: 'Your username here',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      onChanged: (value) =>
                          setState(() => userName = Username.dirty(value)),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: email.validate,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Your email here',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      onChanged: (value) =>
                          setState(() => email = Email.dirty(value)),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: password.validate,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Your password here',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: password.isEmpty()
                              ? const Icon(Icons.check_box_outline_blank)
                              : password.isValid()
                                  ? const Icon(Icons.check_box)
                                  : const Icon(Icons.error_outline)),
                      onChanged: (value) =>
                          setState(() => password = Password.dirty(value)),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      validator: password.match,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'Confirm password here',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: signUp,
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 56),
                    FlutterMastersRichText(
                      text: 'Already have an Account?',
                      secondaryText: 'Sign In',
                      onTap: () => context.pushNamed(SignInScreen.route),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/result.dart';
import '../../../../core/typedefs.dart';
import '../../../../failures/auth_failure.dart';
import '../../domain/repositories/sign_in_repository.dart';
import '../../../../ui/shared/extensions/form_field_x.dart';

class SignInService implements SignInRepository {
  const SignInService(this.client);

  final FirebaseAuth client;

  @override
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required Email email,
    required Password password,
  }) async {
    try {
      final credentials = await client.signInWithEmailAndPassword(
        email: email.result.value,
        password: password.result.value,
      );
      final user = credentials.user;
      if (user != null) {
        return Success(null);
      }
      return Err(SignInAuthFailure.userNotFound);
    } on FirebaseAuthException catch (e) {
      return Err(
        SignInAuthFailure.values.firstWhere(
          (failure) => failure.code == e.code,
          orElse: () => SignInAuthFailure.unknown,
        ),
      );
    } catch (_) {
      return Err(SignInAuthFailure.unknown);
    }
  }
}

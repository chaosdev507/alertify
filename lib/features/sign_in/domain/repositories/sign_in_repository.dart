import '../../../../core/typedefs.dart';
import '../../../../failures/auth_failure.dart';
import '../../../../ui/shared/extensions/form_field_x.dart';

abstract interface class SignInRepository {
  FutureAuthResult<void, SignInAuthFailure> signIn({
    required Email email,
    required Password password,
  });
}

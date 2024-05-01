import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../core/result.dart';
import '../../../../ui/shared/extensions/form_field_x.dart';

enum SignInStatus { none, success }

class SignInController extends AutoDisposeAsyncNotifier<SignInStatus> {
  @override
  FutureOr<SignInStatus> build() => SignInStatus.none;

  Future<void> signIn({required Email email, required Password password}) async {
    state = const AsyncLoading();

    try {
      if(email is Err) {
        state = AsyncError(email.result.value, StackTrace.current);
        return;
      }

      if(password is Err) {
        state = AsyncError(password.result.value, StackTrace.current);
        return;
      }

      final authRepo = ref.read(signInServiceProvider);

      final result = await authRepo.signIn(email: email, password: password);
      final failure = switch (result) {
        Success() => null,
        Err(value: final exception) => exception,
      };

      if (failure == null) {
        state = const AsyncData(SignInStatus.success);
      } else {
        state = AsyncError(failure, StackTrace.current);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final signInControllerProvider =
    AsyncNotifierProvider.autoDispose<SignInController, SignInStatus>(
  SignInController.new,
);

import 'package:flutter_test/flutter_test.dart';
import 'package:spaces_application/business_logic/auth/form_submission_status.dart';
import 'package:spaces_application/business_logic/auth/login/login_state.dart';

void main() {
  const email = 'test@wsu.edu';
  const password = 'password';
  group('LoginState', () {
    test(
        'LoginInitialState - Initial landing into page, support value comparisons for defaults',
        () {
      expect(LoginState(), LoginState());
    });

    test(
        'InitialFormStatus - return same objects when no properties are passed',
        () {
      expect(LoginState().copyWith(formStatus: const InitialFormStatus()),
          LoginState());
    });

    test('EmailUpdate - returns object with updated email when email is passed',
        () {
      expect(LoginState().copyWith(email: email), LoginState(email: email));
    });

    test(
        'PasswordUpdate - returns object with updated password when password is passed',
        () {
      expect(LoginState().copyWith(password: password),
          LoginState(password: password));
    });
  });
}

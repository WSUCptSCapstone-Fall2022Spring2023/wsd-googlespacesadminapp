import 'package:spaces_application/business_logic/auth/login/login_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const email = 'test@wsu.edu';
  const password = 'password';
  group('LoginEvent', () {
    group('LoginEmailChanged', () {
      test('support value comparisons', () {
        expect(
            LoginEmailChanged(email: email), LoginEmailChanged(email: email));
      });
    });

    group('LoginPasswordChanged', () {
      test('supports value comparisons', () {
        expect(LoginPasswordChanged(password: password),
            LoginPasswordChanged(password: password));
      });
    });

    group('LoginSubmitted', () {
      test('supports value comparisons', () {
        expect(LoginSubmitted(), LoginSubmitted());
      });
    });
  });
}

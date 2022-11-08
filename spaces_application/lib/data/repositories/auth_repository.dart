class AuthRepository {
  Future<void> login() async {
    print('attenpting login');
    await Future.delayed(Duration(seconds: 3));
    print('loggin in');
    throw Exception('failed to login');
  }
}

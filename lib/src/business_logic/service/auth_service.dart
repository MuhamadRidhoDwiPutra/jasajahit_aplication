class AuthService {
  /// Returns 'admin' if admin login, 'customer' if customer login, null if invalid
  Future<String?> login(String username, String password) async {
    // Simulasi delay autentikasi
    await Future.delayed(const Duration(milliseconds: 500));
    if (username == 'admin' && password == 'admin123') {
      return 'admin';
    } else if (username == 'customer' && password == 'customer123') {
      return 'customer';
    } else {
      return null;
    }
  }
}

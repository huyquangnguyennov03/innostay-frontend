import 'dart:async';

class MockAuthService {
  // Tài khoản mẫu
  static const String demoEmail = 'demo@innostay.app';
  static const String demoPassword = '12345678';

  // Lưu trạng thái đăng nhập tạm thời trong memory
  bool _signedIn = false;

  bool get isSignedIn => _signedIn;

  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (email == demoEmail && password == demoPassword) {
      _signedIn = true;
      return;
    }
    throw AuthException('Email hoặc mật khẩu không đúng');
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Với mock: chấp nhận mọi email khác demoEmail là "đăng ký thành công"
    if (email == demoEmail) {
      throw AuthException('Email đã tồn tại (mock)');
    }
    _signedIn = true;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _signedIn = false;
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
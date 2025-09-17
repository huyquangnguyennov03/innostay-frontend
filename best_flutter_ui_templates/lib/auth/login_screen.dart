import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'mock_auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(text: MockAuthService.demoEmail);
  final _password = TextEditingController(text: MockAuthService.demoPassword);
  final _auth = MockAuthService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await _auth.signIn(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NavigationHomeScreen()),
      );
    } on AuthException catch (e) {
      setState(() { _error = e.message; });
    } catch (_) {
      setState(() { _error = 'Đã có lỗi xảy ra, vui lòng thử lại.'; });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff132137);
    return Scaffold(
      backgroundColor: const Color(0xffF7EBE1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
                ],
              ),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Welcome back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: primary)),
                    const SizedBox(height: 8),
                    const Text('Đăng nhập bằng tài khoản mẫu để vào app', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || !v.contains('@')) ? 'Email không hợp lệ' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                      obscureText: true,
                      validator: (v) => (v == null || v.length < 6) ? 'Mật khẩu tối thiểu 6 ký tự' : null,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Login'),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: _loading
                            ? null
                            : () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                ),
                        child: const Text('Chưa có tài khoản? Đăng ký'),
                      ),
                    ),
                    TextButton(
                      onPressed: _loading ? null : () => Navigator.pop(context),
                      child: const Text('← Back to Intro'),
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
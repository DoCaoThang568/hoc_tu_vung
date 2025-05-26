import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth'; // Optional: for named routes

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordObscured = true; // Thêm biến này
  bool _isConfirmPasswordObscured = true; // Thêm biến này

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      // Reset password visibility on mode toggle
      _isPasswordObscured = true;
      _isConfirmPasswordObscured = true;
    });
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Simulate network request before actual logic
    await Future.delayed(const Duration(seconds: 1));

    try {
      if (_isLoginMode) {
        // --- TÀI KHOẢN CỨNG ĐỂ TEST ---
        const String testEmail = "test@example.com";
        const String testPassword = "test123";

        if (email == testEmail && password == testPassword) {
          print('Hardcoded Login Successful: Email: $email');
          if (mounted) {
            // Điều hướng đến màn hình chính sau khi đăng nhập thành công
            Navigator.of(context).pushReplacementNamed('/main-app'); // Sử dụng routeName của ManHinhChinh
          }
        } else {
          _showErrorDialog('Email hoặc mật khẩu không đúng (tài khoản test).');
        }
        // --- KẾT THÚC TÀI KHOẢN CỨNG ---
        // TODO: Xóa đoạn code trên và Implement Login Logic (Call API) khi có backend
        // print('Login with Email: $email, Password: $password');
      } else {
        final confirmPassword = _confirmPasswordController.text.trim();
        if (password != confirmPassword) {
          _showErrorDialog('Mật khẩu không khớp.');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          return;
        }
        // TODO: Implement Register Logic (Call API)
        print('Register with Email: $email, Password: $password');
        // Ví dụ: Sau khi đăng ký thành công, có thể tự động đăng nhập hoặc chuyển về màn hình đăng nhập
        // Tạm thời thông báo đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công (giả lập)! Vui lòng đăng nhập.', style: GoogleFonts.poppins())),
        );
        _toggleMode(); // Chuyển về màn hình đăng nhập sau khi đăng ký (giả lập)
      }
    } catch (error) {
      print('Auth Error: $error');
      _showErrorDialog(error.toString());
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Có lỗi xảy ra', style: GoogleFonts.poppins()),
        content: Text(message, style: GoogleFonts.poppins()),
        actions: <Widget>[
          TextButton(
            child: Text('OK', style: GoogleFonts.poppins()),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // App Logo or Title
                Text(
                  'Học Từ Vựng',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode ? 'Đăng nhập tài khoản' : 'Tạo tài khoản mới',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: theme.colorScheme.onBackground.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Nhập địa chỉ email của bạn',
                          prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface.withOpacity(0.5),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty || !value.contains('@')) {
                            return 'Vui lòng nhập email hợp lệ.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          hintText: 'Nhập mật khẩu của bạn',
                          prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                          suffixIcon: IconButton( // Thêm suffixIcon
                            icon: Icon(
                              _isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.surface.withOpacity(0.5),
                        ),
                        obscureText: _isPasswordObscured, // Sử dụng biến trạng thái
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty || value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Field (only in Register mode)
                      if (!_isLoginMode)
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Xác nhận mật khẩu',
                            hintText: 'Nhập lại mật khẩu của bạn',
                            prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                            suffixIcon: IconButton( // Thêm suffixIcon
                              icon: Icon(
                                _isConfirmPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface.withOpacity(0.5),
                          ),
                          obscureText: _isConfirmPasswordObscured, // Sử dụng biến trạng thái
                          style: GoogleFonts.poppins(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng xác nhận mật khẩu.';
                            }
                            if (value != _passwordController.text) {
                              return 'Mật khẩu không khớp.';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 24),

                      // Submit Button
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            minimumSize: const Size(double.infinity, 50), // Full width
                          ),
                          child: Text(
                            _isLoginMode ? 'Đăng nhập' : 'Đăng ký',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Toggle Mode Button
                      TextButton(
                        onPressed: _toggleMode,
                        child: Text(
                          _isLoginMode
                              ? 'Chưa có tài khoản? Đăng ký ngay'
                              : 'Đã có tài khoản? Đăng nhập',
                          style: GoogleFonts.poppins(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

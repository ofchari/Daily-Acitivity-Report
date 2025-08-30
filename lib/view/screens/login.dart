import 'package:daily_activity_report/view/screens/dashboard_select_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'daily_acticvity.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String dummyUsername = 'admin';
  final String dummyPassword = '123456';

  bool _obscurePassword = true;
  String? errorMessage;

  void _login() {
    setState(() {
      if (_usernameController.text == dummyUsername &&
          _passwordController.text == dummyPassword) {
        errorMessage = null;
        Get.offAll(ActivitySelectionPage());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Login Successful')));
      } else {
        errorMessage = '❌ Invalid username or password';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13 reference
      builder: (context, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 80.sp, color: Colors.white),
                    SizedBox(height: 20.h),
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Login Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          children: [
                            TextField(
                              controller: _usernameController,
                              style: GoogleFonts.poppins(fontSize: 16.sp),
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                ),
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: GoogleFonts.poppins(fontSize: 16.sp),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                ),
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            if (errorMessage != null)
                              Text(
                                errorMessage!,
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                ),
                              ),
                            SizedBox(height: 20.h),
                            SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4e54c8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF4e54c8),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

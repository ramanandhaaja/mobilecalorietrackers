
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilecalorietrackers/core/theme/app_colors.dart';
import 'package:mobilecalorietrackers/features/auth/providers/auth_provider.dart'; // Assuming AppColors exists

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use ScreenUtilInit at the root, then use .w, .h, .sp for dimensions

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              SvgPicture.asset(
                'assets/svg/logo.svg',
                height: 50.h,
                colorFilter: ColorFilter.mode(AppColors.primaryGreen, BlendMode.srcIn),
              ),
              SizedBox(height: 48.h),

              // Welcome Text
              Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Log in to continue your fitness journey.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              SizedBox(height: 32.h),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off_outlined), // Add toggle logic later
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                            _error = '';
                          });

                          try {
                            await ref.read(authStateProvider.notifier).login(
                              _emailController.text,
                              _passwordController.text,
                            );
                            
                            if (mounted) {
                              context.go('/dashboard');
                            }
                          } catch (e) {
                            setState(() {
                              _error = e.toString();
                              _isLoading = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Log In'),
              ),
              if (_error.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                  child: Text(
                    _error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              SizedBox(height: 16.h),

              // Forgot Password & Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () { /* TODO: Implement forgot password */ },
                    child: const Text('Forgot Password?'),
                  ),
                  TextButton(
                    onPressed: () { /* TODO: Implement sign up navigation */ },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

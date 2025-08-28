import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../profile/screens/profile_screen.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;
  final String otp;

  const ResetPasswordScreen({
    Key? key,
    required this.phone,
    required this.otp,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _isArabic(context);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
        create: (_) => LoginCubit(dio: Dio()),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isArabic
                    ? "تم تغيير كلمة المرور بنجاح ✅"
                    : "Password changed successfully ✅")),
              );
            } else if (state is ResetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.black),
                title: Text(
                  isArabic ? "إعادة تعيين كلمة المرور" : "Reset Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic
                            ? "أدخل الكود المرسل إلى رقمك ${widget.phone}"
                            : "Enter the OTP sent to your number ${widget.phone}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 14.sp,
                          fontFamily: 'Graphik Arabic',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      _buildLabel(isArabic ? 'الكود (OTP)' : 'OTP Code'),
                      _buildTextField(
                        controller: _otpController,
                        hint: widget.otp,
                        textInputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic
                                ? "يرجى إدخال الكود"
                                : "Please enter the code";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),

                      _buildLabel(
                          isArabic ? 'كلمة المرور الجديدة' : 'New Password'),
                      _buildTextField(
                        controller: _passwordController,
                        hint: "********",
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic
                                ? "يرجى إدخال كلمة المرور"
                                : "Please enter password";
                          }
                          if (value.length < 6) {
                            return isArabic
                                ? "كلمة المرور يجب أن تكون 6 أحرف على الأقل"
                                : "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),

                      _buildLabel(
                          isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password'),
                      _buildTextField(
                        controller: _confirmPasswordController,
                        hint: "********",
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return isArabic
                                ? "يرجى تأكيد كلمة المرور"
                                : "Please confirm password";
                          }
                          if (value != _passwordController.text) {
                            return isArabic
                                ? "كلمة المرور غير متطابقة"
                                : "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30.h),

                      SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is ResetPasswordLoading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().resetPassword(
                                phone: widget.phone,
                                otp: _otpController.text.trim(),
                                newPassword:
                                _passwordController.text.trim(),
                                confirmPassword:
                                _confirmPasswordController.text
                                    .trim(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBA1B1B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: state is ResetPasswordLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : Text(
                            isArabic
                                ? 'تغيير كلمة المرور'
                                : 'Change Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Graphik Arabic',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 13.sp,
          fontFamily: 'Graphik Arabic',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType textInputType,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        hintStyle: GoogleFonts.almarai(fontSize: 14.sp, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
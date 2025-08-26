// lib/screens/auth/screen/login_bottom_sheet.dart
import 'dart:ui';
import 'package:abu_diyab_workshop/screens/profile/screens/profile_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abu_diyab_workshop/screens/home/screen/home_screen.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/sign_up.dart';
import 'package:abu_diyab_workshop/screens/auth/widget/support_bottom_sheet.dart';

import '../../../core/language/locale.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({Key? key}) : super(key: key);

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: MediaQuery
            .of(context)
            .viewInsets,
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width, // ياخذ عرض الشاشة كله

          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                    .onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                      locale!.isDirectionRTL(context)
                      ? 'حيّاك! سجل دخولك'
                      : "Welcome! Log in",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  locale!.isDirectionRTL(context)
                      ? "عطنا رقم جوالك ونساعدك تصلّح سيارتك بأقرب وقت 🚗"
                      : "Give us your mobile number and we will help you fix your car as soon as possible 🚗",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 13.h,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),

                _buildLabel(locale!.isDirectionRTL(context)
                    ? "رقم الهاتف"
                    : "phone number",),
                _buildTextField(
                  controller: _phoneController,
                  hint: "05XXXXXXXX",
                  textInputType: TextInputType.phone,
                  maxLength: 15,
                ),

                SizedBox(height: 16.h),
                _buildLabel(locale!.isDirectionRTL(context)
                    ? "كلمه المرور"
                    : "password",
                ),
                _buildTextField(
                  controller: _passwordController,
                  hint: "********",
                  textInputType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "يرجى إدخال كلمة المرور";
                    }
                    if (value.length < 6) {
                      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                    }
                    return null;
                  },
                  maxLength: 30,
                  obscureText: true,
                ),
                SizedBox(height: 20.h),
/*
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        // ✅ نجاح تغيير كلمة المرور
                        if (state is ResetPasswordSuccess) {
                          Navigator.pop(context); // يقفل الـ reset BottomSheet فقط

                          showDialog(
                            context: context,
                            builder: (dialogCtx) => AlertDialog(
                              title: const Text("تم بنجاح 🎉"),
                              content: const Text(
                                  "تم تغيير كلمة المرور بنجاح، يمكنك الآن تسجيل الدخول."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogCtx),
                                  child: const Text("حسناً"),
                                ),
                              ],
                            ),
                          );
                        }

                        // ❌ فشل تسجيل الدخول
                        else if (state is LoginFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }

                        // ✅ نجاح إرسال كود استرجاع الباسورد
                        else if (state is ForgotPasswordSuccess) {
                          final TextEditingController otpController = TextEditingController();
                          final TextEditingController passController = TextEditingController();
                          final TextEditingController confirmController = TextEditingController();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (resetSheetContext) {
                              final phone = state.phone;

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, -3),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "🔑 إعادة تعيين كلمة المرور",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // OTP
                                        TextField(
                                          controller: otpController,
                                          keyboardType: TextInputType.number,
                                          maxLength: 6,
                                          decoration: InputDecoration(
                                            labelText: "رمز التحقق (OTP)",
                                            prefixIcon: const Icon(Icons.lock_clock_outlined),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // Password
                                        TextField(
                                          controller: passController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: "كلمة المرور الجديدة",
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // Confirm Password
                                        TextField(
                                          controller: confirmController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: "تأكيد كلمة المرور",
                                            prefixIcon: const Icon(Icons.lock_reset),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        // زر تغيير كلمة المرور
                                        BlocBuilder<LoginCubit, LoginState>(
                                          builder: (context, state) {
                                            final isLoading = state is LoginLoading;

                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFBA1B1B),
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: isLoading
                                                  ? null
                                                  : () {
                                                if (otpController.text.trim().length != 6) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "أدخل رمز تحقق صحيح (6 أرقام)")),
                                                  );
                                                  return;
                                                }

                                                if (passController.text.trim().length < 6) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "كلمة المرور يجب أن تكون 6 أحرف على الأقل")),
                                                  );
                                                  return;
                                                }

                                                if (passController.text.trim() !=
                                                    confirmController.text.trim()) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            "كلمتا المرور غير متطابقتين")),
                                                  );
                                                  return;
                                                }

                                                context.read<LoginCubit>().resetPassword(
                                                  phone: phone,
                                                  otp: otpController.text.trim(),
                                                  newPassword: passController.text.trim(),
                                                  confirmPassword:
                                                  confirmController.text.trim(),
                                                );
                                              },
                                              child: isLoading
                                                  ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                                  : const Text(
                                                "تغيير كلمة المرور",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        // ❌ فشل تغيير الباسورد
                        else if (state is ResetPasswordFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 50.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is LoginLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                  phone: _phoneController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBA1B1B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: state is LoginLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                              locale!.isDirectionRTL(context)
                                  ? 'سجّلني الآن'
                                  : 'Register me now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    )
,*/
                SizedBox(height: 10.h),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        locale!.isDirectionRTL(context)
                            ? "ماعندك حساب ؟"
                            : "You don't have an account?",

                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.27.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Future.delayed(Duration(milliseconds: 100), () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const AuthBottomSheet(),
                            );
                          });
                        },
                        child: Text(
                          locale!.isDirectionRTL(context)
                              ? "سوّيه الحين"
                              : "Do it now",
                          style: TextStyle(
                            color: const Color(0xFFBA1B1B),
                            fontSize: 16.17.h,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(  "تم تسجيل الدخول ✅" )),
                      );
                      Navigator.pop(context); // أو روح للصفحة الرئيسية
                    } else if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      height: 50.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                              phone: _phoneController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBA1B1B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: state is LoginLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                           'تسجيل الدخول' ,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                        GestureDetector(
                  onTap: () {
                    if (_phoneController.text
                        .trim()
                        .isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("يرجى إدخال رقم الهاتف أولاً")),
                      );
                      return;
                    }

                    context.read<LoginCubit>().forgotPassword(
                      phone: _phoneController.text.trim(),
                    );
                  },
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "نسيت كلمة المرور؟"
                        : "Forget password?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordSuccess) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResetPasswordScreen(
                            phone: state.phone,
                            otp: state.otp,
                          ),
                        ),
                      );
                    }


                    if (state is ResetPasswordSuccess) {
                      // يقفل أي بوتوم شيت مفتوح
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FractionallySizedBox(
                          widthFactor: 1,
                          child: BlocProvider(
                            create: (_) => LoginCubit(dio: Dio()),
                            child: const LoginBottomSheet(),
                          ),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("تم تغيير كلمة المرور بنجاح ✅")),
                      );
                      print("تم تغيير كلمة المرور بنجاح ✅");
                    }


                    if (state is ResetPasswordFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox.shrink();
                  },
                ),



                Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    locale!.isDirectionRTL(context)
                        ? "او"
                        : "or",
                    style: GoogleFonts.almarai(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/technical-support.png',
                height: 22.h,
                width: 22.w,
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const SupportBottomSheet(),
                  );
                },
                child: Text(
                  locale!.isDirectionRTL(context)
                      ? "تواصل معنا لو تبي مساعدة"
                      : "Contact us if you need help",
                  style: TextStyle(
                    color: const Color(0xFFBA1B1B),
                    fontSize: 16.h,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    ),)
    ,
    )
    ,
    )
    ,
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.black,
        fontSize: 13.sp,
        fontFamily: 'Graphik Arabic',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType textInputType,
    String? Function(String?)? validator,
    int? maxLength,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters:
      maxLength != null
          ? [LengthLimitingTextInputFormatter(maxLength)]
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 16.w,
        ),
        hintText: hint,
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
} /*
class ResetPasswordSheet extends StatelessWidget {
  final String phone;
  const ResetPasswordSheet({required this.phone, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("أدخل الكود المرسل وكلمة المرور الجديدة"),

            SizedBox(height: 10),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "أدخل الكود",
              ),
            ),

            SizedBox(height: 10),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "كلمة المرور الجديدة",
              ),
            ),

            SizedBox(height: 10),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "تأكيد كلمة المرور",
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (passController.text == confirmController.text &&
                    passController.text.length >= 6) {
                  context.read<LoginCubit>().resetPassword(
                    phone: phone, // ✅ استخدم الباراميتر مش state
                    otp: otpController.text.trim(),
                    newPassword: passController.text.trim(),
                    confirmPassword: confirmController.text.trim(),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("تأكد من إدخال البيانات بشكل صحيح")),
                  );
                }

              },
              child: Text("تغيير كلمة المرور"),
            ),
          ],
        ),
      ),
    );
  }
}
*/


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
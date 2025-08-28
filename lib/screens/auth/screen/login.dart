import 'dart:ui';
import 'package:abu_diyab_workshop/screens/auth/screen/reset_pass.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/sign_up.dart';
import 'package:abu_diyab_workshop/screens/auth/widget/support_bottom_sheet.dart';
import '../../../core/language/locale.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widget/build_label.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

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
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: MediaQuery.of(context).size.width, // ياخذ عرض الشاشة كله

          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

                    build_label(
                      text:
                          locale!.isDirectionRTL(context)
                              ? "رقم الهاتف"
                              : "phone number",
                    ),
                    _buildTextField(
                      controller: _phoneController,
                      hint: "05XXXXXXXX",
                      textInputType: TextInputType.phone,
                      maxLength: 15,
                    ),

                    SizedBox(height: 16.h),
                    build_label(
                      text:
                          locale!.isDirectionRTL(context)
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
                    SizedBox(height: 6.h),
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("تم تسجيل الدخول ✅")),
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
                            onPressed:
                                state is LoginLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginCubit>().login(
                                          phone: _phoneController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBA1B1B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child:
                                state is LoginLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      'تسجيل الدخول',
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
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: () {
                        if (_phoneController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("يرجى إدخال رقم الهاتف أولاً"),
                            ),
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
                    SizedBox(height: 8.h),
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
                        if (state is ForgotPasswordSuccess) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => ResetPasswordScreen(
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
                            builder:
                                (context) => FractionallySizedBox(
                                  widthFactor: 1,
                                  child: BlocProvider(
                                    create: (_) => LoginCubit(dio: Dio()),
                                    child: const LoginBottomSheet(),
                                  ),
                                ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("تم تغيير كلمة المرور بنجاح ✅"),
                            ),
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
                              locale!.isDirectionRTL(context) ? "او" : "or",
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
            ),
          ),
        ),
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
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
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
}

import 'package:abu_diyab_workshop/screens/auth/cubit/login_cubit.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/login.dart';
import 'package:abu_diyab_workshop/screens/auth/screen/sign_up.dart';
import 'package:abu_diyab_workshop/screens/auth/widget/log_out.dart';
import 'package:abu_diyab_workshop/screens/auth/widget/support_bottom_sheet.dart';
import 'package:abu_diyab_workshop/screens/home/screen/home_screen.dart';
import 'package:abu_diyab_workshop/screens/profile/screens/profile_screen.dart';
import 'package:abu_diyab_workshop/screens/profile/widget/ITN.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/language/locale.dart';
import '../../../main.dart';
import '../../on_boarding/screen/on_boarding_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}


class _MoreScreenState extends State<MoreScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      await prefs.clear();
      if (mounted) {
     //   Navigator.pushAndRemoveUntil(
     //     context,
     //     MaterialPageRoute(builder: (_) => OnboardingScreen()),
     //         (route) => false,
     //   );
      }
      return;
    }

    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final locale = AppLocalizations.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xFFEAEAEA),
        appBar: AppBar(
          toolbarHeight: 130.h,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFBA1B1B), Color(0xFFD27A7A)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locale!.isDirectionRTL(context) ? "المزيد" : "More",

                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'عام',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                if (_isLoggedIn)
                  widget_ITN(
                    text: 'تعديل بيانات الحساب',
                    iconPath: 'assets/icons/edit.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                if (_isLoggedIn) SizedBox(height: 10.h),

                widget_ITN(
                  text: 'تواصل معنا ',
                  iconPath: 'assets/icons/technical-support.png',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const SupportBottomSheet(),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  height: 50,
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.50,
                        color: const Color(0xFFAFAFAF),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.language,color: Color(0xFFBA1B1B),) ,// شكل الكرة الأرضية الافتراضي
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          locale!.isDirectionRTL(context)
                              ? 'لغة التطبيق'
                              : 'App Language',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(),
                      LanguageToggle(
                        isArabic: isArabic,
                        onToggle: () {
                          myAppKey.currentState?.changeLanguage(
                            isArabic ? const Locale('en') : const Locale('ar'),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                _isLoggedIn
                    ? widget_ITN(
                      text: 'تسجيل الخروج',
                      iconPath: 'assets/icons/logout.png',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const LogoutBottomSheet(),
                        );
                      },
                    )
                    : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const AuthBottomSheet(),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFBA1B1B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'إنشاء حساب جديد',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder:
                                  (context) => BlocProvider(
                                    create: (_) => LoginCubit(dio: Dio()),
                                    child: const LoginBottomSheet(),
                                  ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.50,
                                  color: Colors.black.withOpacity(
                                    0.7,
                                  ), // fix for .withValues() error
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'تسجيل الدخول',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
    );
  }
}

class LanguageToggle extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggle;

  const LanguageToggle({
    Key? key,
    required this.isArabic,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 70.w,
        height: 30.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.transparent, width: 1),
        ),
        child: Stack(
          children: [
            // النصوص AR / EN
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Text(
                  "AR",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isArabic ? Colors.white : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Text(
                  "EN",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isArabic ? Colors.red : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // الزر المتحرك
            AnimatedAlign(
              alignment:
                  isArabic ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Container(
                width: 30.w,
                height: 22.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

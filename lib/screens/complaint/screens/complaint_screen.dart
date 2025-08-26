import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isRTL = locale!.isDirectionRTL(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: 130.h,
            padding: EdgeInsets.only(top: 20.h, right: 16.w, left: 16.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFBA1B1B), Color(0xFFD27A7A)],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    isRTL ? "الشكاوي" : "Complaints",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextField(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    decoration: InputDecoration(
                      hintText: isRTL ? "الاسم بالكامل" : "Full name",
                      prefixIcon: isRTL
                          ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/icons/profilee.png',
                          height: 18.h,
                          width: 18.w,
                        ),
                      )
                          : null,
                      suffixIcon: !isRTL
                          ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/icons/profilee.png',
                          height: 18.h,
                          width: 18.w,
                        ),
                      )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextField(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    decoration: InputDecoration(
                      hintText: isRTL ? "عنوان البريد الإلكتروني" : "Email address",
                      prefixIcon: isRTL
                          ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/icons/email.png',
                          height: 18.h,
                          width: 18.w,
                        ),
                      )
                          : null,
                      suffixIcon: !isRTL
                          ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/icons/email.png',
                          height: 18.h,
                          width: 18.w,
                        ),
                      )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: isRTL ? "رقم الجوال" : "Mobile number",
                    prefixIcon: isRTL
                        ? Padding(
                      padding: EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/icons/call.png',
                        height: 18,
                        width: 18,
                      ),
                    )
                        : null,
                    suffixIcon: !isRTL
                        ? Padding(
                      padding: EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/icons/call.png',
                        height: 18,
                        width: 18,
                      ),
                    )
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 4,
                  decoration: InputDecoration(
                    hintText: isRTL ? "أكتب اللي في خاطرك ......" : "Write what's on your mind...",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 226.w,
                  height: 45.h,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFBA1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 161.w,
                        height: 26.h,
                        child: Text(
                          isRTL ? "إرسال" : "Send",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.h,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                            height: 1.47.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
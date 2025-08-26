import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;
  final VoidCallback? onTap; // زرار اختيارى


  const HelpCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: onTap,

        child: Container(
          padding: EdgeInsets.all(12.w),
          height: 125.h,
          width: 170.w,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2.w,
                color: const Color(0xFFAFAFAF),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title, textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.h,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    iconPath,
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.70),
                    fontSize: 16,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
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

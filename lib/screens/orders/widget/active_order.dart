import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';

class ActiveOrder extends StatelessWidget {
  const ActiveOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      width: 350.w,
      height: 370.h,
      // Makes container responsive
      padding: EdgeInsets.all(12),
      // Add padding instead of hardcoded positions
      decoration: ShapeDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors. white
            : Colors. black,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Service name row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'اسم الخدمة :',
                      style: TextStyle(
                        color: const Color(0xFF4D4D4D),
                        fontSize: 15.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                        height: 1.47,
                      ),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                    TextSpan(
                      text: 'صيانة وأعطال',
                      style: TextStyle(
                        color: const Color(0xFFBA1B1B),
                        fontSize: 22.h,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 8),
              Container(
                width: 23.w,
                height: 23.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icons/car_fact.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),          SizedBox(height: 3),

          // Status and order number row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'رقــم الطلـب : ',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.h,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '9704#',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: const Color(0xFFBA1B1B),
                      fontSize: 16.h,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: ShapeDecoration(
                  color: const Color(0xFF00B441),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'قيد التنفيذ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.h,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                    height: 1.38,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),          SizedBox(height: 3),

          // Vehicle details section
          Row(
      //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle image placeholder
              Container(
                width: 93.w ,
                height: 85.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.transparent,
                  width: 1,
                  ),
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:Image.asset('assets/icons/car_logo.png',fit: BoxFit.cover,),
              ),
              SizedBox(width: 10,),

              // Vehicle details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'المــوديــل : ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.83,
                        ),
                      ),                      SizedBox(width: 8),

                      Text(
                        'جيلي اميجراند 2023',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFBA1B1B),
                          fontSize: 13.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 9),

                  Row(
                    children: [
                      Text(
                        'المــوديــل : ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.83,
                        ),
                      ),                      SizedBox(width: 8),

                      Text(
                        'جيلي اميجراند 2023',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFBA1B1B),
                          fontSize: 13.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 9),

                  Row(
                    children: [
                      Text(
                        'المــوديــل : ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.83,
                        ),
                      ),                      SizedBox(width: 8),

                      Text(
                        'جيلي اميجراند 2023',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFBA1B1B),
                          fontSize: 13.h,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                          height: 1.69,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),          SizedBox(height: 3),
          // Delivery estimate
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'موعد التسليم المتوقع !',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFF4D4D4D),
                  fontSize: 16,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                  height: 1.38,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'بعد 5 أيام',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: const Color(0xFFBA1B1B),
                  fontSize: 22,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 3),
          Center(
            child: Text(
              "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
            ),
          ),          SizedBox(height: 3),

          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFBA1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'عرض التفاصيل',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.47,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 22),
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1.30,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'تواصل مع المركز',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF4D4D4D),
                      fontSize: 15,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                      height: 1.47,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

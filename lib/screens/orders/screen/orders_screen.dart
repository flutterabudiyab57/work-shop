import 'package:abu_diyab_workshop/screens/orders/widget/active_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../widget/old_order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}
bool _showActiveOrders = true;

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {

    final locale = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color activeOrdersBackgroundColor = _showActiveOrders
        ? const Color(0xFFBA1B1B)
        : isDark
        ? Colors.black
        : Colors.white24;
    final Color oldOrdersBackgroundColor = !_showActiveOrders
        ? const Color(0xFFBA1B1B)
        : isDark
        ? Colors.black
        : Colors.white24;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Directionality(
          textDirection: Localizations
              .localeOf(context)
              .languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,

          child: Container(
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
                  locale!.isDirectionRTL(context)
                      ? "طلباتي"
                      : "My Orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Active Orders Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showActiveOrders = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:     Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          width: 1,
                        ),
                        color: activeOrdersBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: Theme.of(context).brightness == Brightness.dark
                            ? [


                        ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'الطلبات النشطة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:  Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: 18,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                            height: 1.22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 35), // Add some spacing between tabs

                // Old Orders Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showActiveOrders = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:     Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          width: 1,
                        ),
                        color: oldOrdersBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'الطلبات القديمة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                            height: 1.22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16), // Add some spacing

          // Content Container
          Expanded(
            child: Container(
              width: double.infinity,
              child: _showActiveOrders ? ActiveOrdersContent() : OldOrdersContent(),
            ),
          ),
        ],
      ),    );
  }
  Widget ActiveOrdersContent() {
    return ListView(
      children: [
        // Your active orders items here
        // Example: the responsive container we created earlier
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ActiveOrder(),
        ),
        // Add more active orders as needed
      ],
    );
  }

  Widget OldOrdersContent() {
    return ListView(
      children: [
        // Your old orders items here
        Padding(
          padding: EdgeInsets.all(8.0),
          child: OldOrder(),
        ),
        // Add more old orders as needed
      ],
    );
  }
}

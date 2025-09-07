import 'dart:io';

import 'package:abu_diyab_workshop/screens/services/cubit/battery_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/locale.dart';
import '../../my_car/cubit/CarModelCubit.dart';
import '../../my_car/cubit/CarModelState.dart';
import '../../my_car/cubit/car_brand_cubit.dart';
import '../../my_car/cubit/car_brand_state.dart';
import '../../my_car/screen/widget/image_picker.dart';
import '../cubit/battery_state.dart';
import '../widgets/CarBrand-Section.dart';
import '../widgets/CarModel-Section.dart';
import '../widgets/Custom-Button.dart';
import '../widgets/Service-Custom-AppBar.dart';

class ChangeBattery extends StatefulWidget {
  const ChangeBattery({super.key});

  @override
  State<ChangeBattery> createState() => _ChangeBatteryState();
}

class _ChangeBatteryState extends State<ChangeBattery> {
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFD27A7A),
      appBar: CustomGradientAppBar(
      title: "إنشاء طلب",
      onBack: () => Navigator.pop(context),
    ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color:
              Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
        ),

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'تغيير بطارية',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color:Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      'assets/icons/technical-support.png',
                      height: 20.h,
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                /// ---------------- ماركة السيارة ----------------
                CarBrandSection(
                  titleAr: "ماركة السيارة",
                  titleEn: "Car brand",
                  selectedCarBrandId: _selectedCarBrandId,
                  onBrandSelected: (id) {
                    setState(() {
                      _selectedCarBrandId = id;
                      _selectedCarModelId = null;
                    });

                    /// هنا نستدعي موديلات السيارة
                    context.read<CarModelCubit>().fetchCarModels(id);
                  },
                ),

                SizedBox(height: 15.h),

                /// ---------------- الموديل ----------------
                 CarModelSection(
                  titleAr: "موديل السيارة",
                  titleEn: "Car model",
                  selectedCarModelId: _selectedCarModelId,
                  onModelSelected: (id) {
                    setState(() {
                      _selectedCarModelId = id;
                    });

                    /// هنا لو محتاج تجيب بيانات بناءً على الموديل
                    context.read<BatteryCubit>().fetchBatterysByModel(id);
                  },
                ),
                SizedBox(height: 15.h),

                /// ---------------- الزيوت ----------------
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Align(
                    alignment:
                        locale.isDirectionRTL(context)
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Text(
                      locale.isDirectionRTL(context)
                          ? "البطاريات المتاحة"
                          : "Available Oils",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                BlocBuilder<BatteryCubit, BatteryState>(
                  builder: (context, state) {
                    if (state is BatteryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BatteryLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.batterys.length,
                        itemBuilder: (context, index) {
                          final battery = state.batterys[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            child: ListTile(
                              title: Text(battery.type),
                              subtitle: Text(
                                "${battery.brand} - ${battery.type}\n${battery.warrantyUnit}",
                              ),
                              trailing: Text("${battery.price} ر.س"),
                            ),
                          );
                        },
                      );
                    } else if (state is BatteryError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
                SizedBox(height: 10.h),

                SizedBox(
                  width: 74.w,
                  height: 20.h,
                  child: Text(
                    'الملاحظات',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                   Container(
                    decoration: ShapeDecoration(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.50, color: Color(0xFF9B9B9B)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                      child: TextField(
                        maxLines: null,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w500,
                            height: 1.57,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10.h),

                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text(
                    locale.isDirectionRTL(context)
                        ? "ممشى السياره"
                        : "Car counter",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    textDirection:
                    locale.isDirectionRTL(context)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Expanded(
                        child: DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: const [6, 3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8.r),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: TextField(
                            //  controller: kiloReadController,
                            decoration: InputDecoration(
                              hintText: '0000000',
                              hintStyle: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    :  Colors.white38,
                                fontSize: 13.sp,
                                fontFamily: 'Graphik Arabic',
                                fontWeight: FontWeight.w500,
                              ),
                              hintTextDirection:
                              locale.isDirectionRTL(context)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                              ),
                              border: InputBorder.none,
                            ),
                            textDirection:
                            locale.isDirectionRTL(context)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        locale.isDirectionRTL(context) ? 'كم' : 'KM',
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15.h),

                // --- الاستمارة (اختياري) ---
                Align(
                  alignment:
                      locale.isDirectionRTL(context)
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              locale.isDirectionRTL(context)
                                  ? 'إستمارة السيارة '
                                  : 'Car Registration ',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text:
                              locale.isDirectionRTL(context)
                                  ? '( أختياري )'
                                  : '( Optional )',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF4D4D4D)
                                    : Colors.white,
                            fontSize: 12.sp,
                            fontFamily: 'Graphik Arabic',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign:
                        locale.isDirectionRTL(context)
                            ? TextAlign.right
                            : TextAlign.left,
                  ),
                ),
                SizedBox(height: 10.h),
                UploadFormWidget(
                  onImageSelected: (file) {
                    selectedCarDoc = file;
                  },
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
      //هنا زرار التالي في اخر الصفحه
      bottomNavigationBar: CustomBottomButton(
        textAr: "التالي",
        textEn: "Add My Car",
        onPressed: () {
          print("Button Pressed");
        },
      ),

    );
  }
}

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
    final locale = AppLocalizations.of(context);

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
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    'إنشاء طلب',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'تغيير بطارية',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Graphik Arabic',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Image.asset('assets/icons/technical-support.png',height: 20,width: 20,),
                ],
              ),

              /// ---------------- ماركة السيارة ----------------
              Align(
                alignment: locale!.isDirectionRTL(context)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context) ? "ماركة السيارة" : "Car brand",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<CarBrandCubit, CarBrandState>(
                builder: (context, state) {
                  if (state is CarBrandLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CarBrandLoaded) {
                    return SizedBox(
                      height: 110.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.brands.length,
                        itemBuilder: (context, index) {
                          final car = state.brands[index];
                          final isSelected = _selectedCarBrandId == car.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCarBrandId = car.id;
                                _selectedCarModelId = null;
                              });
                              context.read<CarModelCubit>().fetchCarModels(car.id);
                            },
                            child: Container(
                              width: 80.w, // عرض ريسبونسف
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? Color(0xFFE19A9A) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Color(0xFFBA1B1B) : Colors.grey.shade300,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    car.image,
                                    width: 40.w,
                                    height: 40.h,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error, size: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    car.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : Colors.grey,
                                      fontSize: 14.h,
                                      fontFamily: 'Graphik Arabic',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CarBrandError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
              SizedBox(height: 15.h),

              /// ---------------- الموديل ----------------
              Align(
                alignment: locale.isDirectionRTL(context)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context) ? "موديل السيارة" : "Car model",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              BlocBuilder<CarModelCubit, CarModelState>(
                builder: (context, state) {
                  if (state is CarModelLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CarModelLoaded) {
                    return SizedBox(
                      height: 50.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.models.length,
                        itemBuilder: (context, index) {
                          final car = state.models[index];
                          final isSelected = _selectedCarModelId == car.id;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCarModelId = car.id;
                              });
                              /// استدعاء الزيوت حسب الموديل
                              context.read<BatteryCubit>().fetchBatterysByModel(car.id);
                            },
                            child: Container(
                              width: 70.w,
                              height: 50.h,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? Color(0xFFE19A9A) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Color(0xFFBA1B1B) : Colors.grey.shade300,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                car.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.black54,
                                  fontSize: 11.h,
                                  fontFamily: 'Graphik Arabic',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is CarModelError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
              SizedBox(height: 15.h),

              /// ---------------- الزيوت ----------------
              Align(
                alignment: locale.isDirectionRTL(context)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context) ? "البطاريات المتاحة" : "Available Oils",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
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
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(battery.type),
                            subtitle: Text("${battery.brand} - ${battery.type}\n${battery.warrantyUnit}"),
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
                width: 74,
                height: 20,
                child: Text(
                  'الملاحظات',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              Container(
                width: 350,
                height: 191,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      color: Color(0xFF9B9B9B),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    maxLines: null, // يخليه متعدد الأسطر
                    textAlign: TextAlign.right, // الكتابة من اليمين لليسار
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                        height: 1.57,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      border: InputBorder.none, // عشان ما يضيفش إطار ثاني
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
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
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
                              color: Colors.black.withValues(alpha: 0.70),
                              fontSize: 13,
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
                    SizedBox(width: 8.w),
                    Text(
                      locale.isDirectionRTL(context) ? 'كم' : 'KM',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
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
                          color: Colors.black,
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
                          color: const Color(0xFF4D4D4D),
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
      bottomNavigationBar: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            height: 55.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                backgroundColor: const Color(0xFFBA1B1B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 3,
              ),
              onPressed: ()  {},
              child: Text(
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'التالي'
                    : 'Add My Car',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
      ),

    );
  }
}

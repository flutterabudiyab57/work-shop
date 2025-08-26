import 'dart:io';

import 'package:abu_diyab_workshop/screens/auth/model/login_model.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/api.dart';
import '../../../../core/language/locale.dart';
import '../../cubit/CarModelCubit.dart';
import '../../cubit/CarModelState.dart';
import '../../cubit/add_car_cubit.dart';
import '../../cubit/add_car_state.dart';
import '../../cubit/car_brand_cubit.dart';
import '../../cubit/car_brand_state.dart';
import 'image_picker.dart';
import 'nemra.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});
  @override
  State<AddCar> createState() => _AddCarState();
}
class _AddCarState extends State<AddCar> {
  final TextEditingController arabicLettersController = TextEditingController();
  final TextEditingController arabicNumbersController = TextEditingController();
  final List<String> years = List.generate(
    50,
    (index) => (DateTime.now().year - index).toString(),
  );
  int selectedYearIndex = 0;
  int? _selectedCarBrandId;
  int? _selectedCarModelId;
  File? selectedCarDoc;

  String? selectedYear;

  final TextEditingController carNameController = TextEditingController();
  final TextEditingController kiloReadController = TextEditingController();

  // تحويل كل الأرقام العربية/الفارسية إلى إنجليزية
  String _digitsToEn(String input) {
    const Map<String, String> arabicIndic = {
      "٠": "0",
      "١": "1",
      "٢": "2",
      "٣": "3",
      "٤": "4",
      "٥": "5",
      "٦": "6",
      "٧": "7",
      "٨": "8",
      "٩": "9",
    };
    const Map<String, String> persianIndic = {
      "۰": "0",
      "۱": "1",
      "۲": "2",
      "۳": "3",
      "۴": "4",
      "۵": "5",
      "۶": "6",
      "۷": "7",
      "۸": "8",
      "۹": "9",
    };
    final buffer = StringBuffer();
    for (final ch in input.characters) {
      if (arabicIndic.containsKey(ch)) {
        buffer.write(arabicIndic[ch]);
      } else if (persianIndic.containsKey(ch)) {
        buffer.write(persianIndic[ch]);
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  // تنظيف الحروف: إزالة مسافات زائدة/رموز، ودمج متعدد المسافات
  String _cleanLetters(String input) {
    String s = input.trim();
    // إزالة أي شيء مش حرف عربي أساسي أو مسافة
    s = s.replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '');
    // إزالة تكرار المسافات
    s = s.replaceAll(RegExp(r'\s+'), '');
    return s;
  }

  // إعداد النمرة بالشكل: "ت ل ج 1535"
  String _buildBoardNo({
    required String lettersRaw,
    required String numbersRaw,
  }) {
    final letters = _cleanLetters(lettersRaw);
    final lettersWithSpaces = letters.split('').join(' ');
    final numbersEn = _digitsToEn(numbersRaw.trim());
    // دمج: حروف متفرقة + مسافة + أرقام إنجليزية
    return "$lettersWithSpaces $numbersEn".trim();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAEAEA),
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Directionality(
          textDirection:
              locale!.isDirectionRTL(context)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                    locale.isDirectionRTL(context)
                        ? 'أضف سيارتك'
                        : 'Add Your Car',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            textDirection:
                locale.isDirectionRTL(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            children: [
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? 'رقم لوحة السيارة'
                      : 'Car plate number',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Nemra(
                    arabicLettersController: arabicLettersController,
                    englishNumbersController: arabicNumbersController,
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // --- الماركة ---
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? "ماركة السيارة"
                      : "Car brand",
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
                      height: 100, // ارتفاع الـ horizontal list
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
                              context.read<CarModelCubit>().fetchCarModels(
                                car.id,
                              );
                            },
                            child: Container(
                              width: 70,

                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xFFE19A9A)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Color(0xFFBA1B1B)
                                          : Colors.grey.shade300,
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
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error, size: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    car.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.black
                                              : Colors.grey,
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

              // --- الموديل ---
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? "موديل السيارة"
                      : "Car model",
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
                      height: 50.h, // ارتفاع قائمة الموديلات
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
                            },
                            child: Container(
                              width: 70.w,
                              height: 50.h,

                              // ارتفاع قائمة الموديلات
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Color(0xFFE19A9A)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Color(0xFFBA1B1B)
                                          : Colors.grey.shade300,
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
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.black54,
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

              // --- اسم السيارة (اختياري) ---
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
                                ? 'اسم السيارة '
                                : 'Car name ',
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
                                ? '( اختياري )'
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
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                ),
                child: TextField(
                  controller: carNameController,
                  decoration: InputDecoration(
                    hintText:
                        locale.isDirectionRTL(context)
                            ? "سيارة الدوام، سيارة العائلة، سيارة أحمد"
                            : "Work car, family car, Ahmed's car",
                    hintTextDirection:
                        locale.isDirectionRTL(context)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),

              SizedBox(height: 15.h),

              // --- سنة الصنع ---
              Align(
                alignment:
                    locale.isDirectionRTL(context)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                child: Text(
                  locale.isDirectionRTL(context)
                      ? "سنة الصنع"
                      : "Year of manufacture",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              SizedBox(
                height: 80.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 30.h,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedYearIndex = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= years.length) return null;
                      final isSelected = index == selectedYearIndex;
                      return Container(
                        width: double.infinity,
                        color:
                            isSelected
                                ? const Color(0xFFBBBBBB)
                                : Colors.transparent,
                        child: Center(
                          child: Text(
                            years[index],
                            style: TextStyle(
                              fontFamily: 'Graphik Arabic',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected
                                      ? Colors.black
                                      : const Color(0xFF5E5E5E),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: years.length,
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              // --- ممشى السيارة ---
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
                          controller: kiloReadController,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // يقبل أرقام بس
                          ],
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
        child: BlocConsumer<AddCarCubit, AddCarState>(
          listener: (context, state) {
            if (state is AddCarSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("✅ ${state.message}")));
            } else if (state is AddCarError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("❌ ${state.message}")));
            }
          },
          builder: (context, state) {
            if (state is AddCarLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SizedBox(
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
                onPressed: () async {
                  final numbersRaw = arabicNumbersController.text;
                  final lettersRaw = arabicLettersController.text;

                  debugPrint("Numbers (raw): $numbersRaw");
                  debugPrint("Letters (raw): $lettersRaw");

                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');

                  if (token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("⚠️ لا يوجد توكن محفوظ")),
                    );
                    return;
                  }

                  // تحقق من أن الماركة والموديل مختارين
                  if (_selectedCarBrandId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ من فضلك اختر ماركة السيارة"),
                      ),
                    );
                    return;
                  }
                  if (_selectedCarModelId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ من فضلك اختر موديل السيارة"),
                      ),
                    );
                    return;
                  }

                  // تحقق من إدخال النمرة
                  final cleanedLetters = _cleanLetters(lettersRaw);
                  final cleanedNumbers = _digitsToEn(numbersRaw.trim());

                  if (cleanedLetters.isEmpty || cleanedNumbers.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ من فضلك أدخل رقم وحروف اللوحة"),
                      ),
                    );
                    return;
                  }

                  // (اختياري) قيود بسيطة: حروف من 1-4، أرقام من 1-6 مثلاً
                  if (cleanedLetters.length > 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ الحد الأقصى لعدد حروف اللوحة 4"),
                      ),
                    );
                    return;
                  }
                  if (cleanedNumbers.length > 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ الحد الأقصى لعدد أرقام اللوحة 6"),
                      ),
                    );
                    return;
                  }

                  // ركّب النتيجة بالشكل: "ت ل ج 1535"
                  final boardNoFinal = _buildBoardNo(
                    lettersRaw: lettersRaw,
                    numbersRaw: numbersRaw,
                  );
                  final kilo = kiloReadController.text.trim();
                  final kiloEn = _digitsToEn(kilo);
                  final kiloInt = int.tryParse(kiloEn);
                  debugPrint("📤 Board No Final (sent): $boardNoFinal");
                  debugPrint("📌 boardNo: $boardNoFinal");
                  debugPrint("📌 brandId: $_selectedCarBrandId");
                  debugPrint("📌 modelId: $_selectedCarModelId");
                  debugPrint("📌 year: ${years[selectedYearIndex]}");
                  debugPrint("📌 carName: ${carNameController.text.trim()}");
                  debugPrint("📌 kiloRead: $kiloInt");
                  debugPrint("📌 carDocs: $selectedCarDoc");
                  final requestBody = {
                    "user_id": 1,
                    "car_brand_id": _selectedCarBrandId,
                    "car_model_id": _selectedCarModelId,
                    "creation_year": years[selectedYearIndex],
                    "board_no": boardNoFinal,
                    "name": carNameController.text.trim(),
                    "kilo_read": kiloInt,
                  };

                  debugPrint("🚀 Request Body: $requestBody");



                  if (kiloInt == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("⚠️ من فضلك أدخل ممشى السيارة")),
                    );
                    return;
                  }

                  debugPrint("📌 kiloRead to send: $kiloInt");

                  context.read<AddCarCubit>().addCar(
                    userId: 1,
                    carDocs: selectedCarDoc,
                    kiloRead: kiloInt,
                    translationName: carNameController.text.trim(),
                    boardNo: boardNoFinal,
                    creationYear: years[selectedYearIndex],
                    carModelId: _selectedCarModelId!,
                    carBrandId: _selectedCarBrandId!,
                    token: token,
                  );
                },
                child: Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'أضف سيارتي'
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
            );
          },
        ),
      ),
    );
  }
}

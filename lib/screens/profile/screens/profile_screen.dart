import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../auth/cubit/login_cubit.dart';
import '../../auth/screen/login.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../repositorie/profile_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepository())..fetchProfile(),
      child: Scaffold(
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
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      'الملف الشخصي',
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
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // صورة بروفايل
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // البطاقة
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: Text("الاسم"),
                              subtitle: Text(user.name ?? ""),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: Text("رقم الهاتف"),
                              subtitle: Text(user.phone ?? ""),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.security),
                              title: Text("الدور"),
                              subtitle: Text(user.role ?? ""),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.calendar_today),
                              title: Text("تاريخ الإنشاء"),
                              subtitle: Text(user.createdAt ?? ""),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
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
                      },
                      child: const Text("سجل الدخول مره اخري من فضلك"),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

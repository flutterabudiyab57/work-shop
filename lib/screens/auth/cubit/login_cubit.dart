// login_cubit.dart
import 'package:abu_diyab_workshop/core/constant/api.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../model/login_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Dio dio;

  LoginCubit({required this.dio}) : super(LoginInitial());

  Future<void> login({required String phone, required String password}) async {
    emit(LoginLoading());
    print('جاري محاولة تسجيل الدخول...');

    try {
      final response = await dio.post(
        mainApi + loginApi,
        data: {'phone': phone, 'password': password},
      );

      if (response.data['status'] == 'success') {
        final data = response.data['data'];
        final loginResponse = LoginResponse.fromJson(data);

        final prefs = await SharedPreferences.getInstance();

        // مسح أي توكين قديم قبل حفظ الجديد
        await prefs.remove('token');

        // حفظ التوكين الجديد وبيانات المستخدم
        await prefs.setString('username', loginResponse.user.name);
        await prefs.setString('token', loginResponse.token);
        await prefs.setBool('is_logged_in', true);

        print('تم تسجيل الدخول بنجاح!');

        // تحديث initialToken في main.dart
        initialToken = loginResponse.token;

        // إرسال الحالة فقط بدون أي Navigator
        emit(LoginSuccess());
      } else {
        final errorMessage = response.data['message'] ?? 'فشل تسجيل الدخول';
        emit(LoginFailure(message: errorMessage));
      }
    } catch (e) {
      emit(LoginFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final res = await dio.post(
        "$mainApi/reset-password",
        data: {
          "phone": phone,
          "otp": otp,
          "password": newPassword,
          "password_confirmation": confirmPassword,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      print("📩 Reset response: ${res.data}");

      if (res.statusCode == 200) {
        final message = res.data["message"]?.toString() ?? "";
        if (message.toLowerCase().contains("success")) {
          emit(ResetPasswordSuccess());
        } else {
          emit(ResetPasswordFailure(message: message));
        }
      } else {
        print("❌ Reset exception: ");

        emit(ResetPasswordFailure(
          message: res.data['message'] ?? 'تعذر إعادة تعيين كلمة المرور',
        ));
      }
    } catch (e) {
      emit(ResetPasswordFailure(message: "خطأ في الاتصال بالسيرفر"));
    }
  }



  Future<void> forgotPassword({required String phone}) async {
    emit(ForgotPasswordLoading()); // ✅ صحح هنا
    print("📞 Sending forgot-password request for $phone");

    try {
      final res = await dio.post(
        "$mainApi/forgot-password",
        data: {"phone": phone},
      );

      print("📩 Response: ${res.data}");

      if (res.statusCode == 200 && res.data["otp"] != null) {
        final otp = res.data["otp"];
        final phoneFromApi = res.data["phone"] ?? phone;
        print("✅ OTP from server: $otp");

        emit(ForgotPasswordSuccess(
          phone: phoneFromApi,
          otp: otp.toString(),
        ));
      } else {
        print("❌ Failure: ${res.data["message"]}");
        emit(ResetPasswordFailure( // ✅ صحح هنا
            message: res.data["message"] ?? "فشل إرسال الكود"
        ));
      }
    } catch (e) {
      print("❌ Exception: $e");
      emit(ResetPasswordFailure( // ✅ صحح هنا
          message: "خطأ في الاتصال بالسيرفر"
      ));
    }
  }

}

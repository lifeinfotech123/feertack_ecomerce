import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController implements GetxService {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxString token = ''.obs;
  final RxString tokenType = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  // Forgot password flow state
  final RxString forgotIdentity = ''.obs;
  final RxString tempOtp = ''.obs;
  final RxString temporaryToken = ''.obs;

  /// Customer Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response['status'] == true) {
        if (response['user_model'] != null) {
          currentUser.value = response['user_model'] as UserModel;
        }
        token.value = response['token']?.toString() ?? '';
        tokenType.value = response['token_type']?.toString() ?? 'Bearer';
        successMessage.value = response['message']?.toString() ?? 'Login successful';
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Login failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register Customer
  Future<bool> register({
    required String fName,
    required String lName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _authService.register(
        fName: fName,
        lName: lName,
        email: email,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (response['status'] == true) {
        if (response['user_model'] != null) {
          currentUser.value = response['user_model'] as UserModel;
        }
        token.value = response['token']?.toString() ?? '';
        tokenType.value = response['token_type']?.toString() ?? 'Bearer';
        successMessage.value = response['message']?.toString() ?? 'Registration successful';
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Registration failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Forgot Password
  Future<bool> forgotPassword({
    required String identity,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _authService.forgotPassword(
        identity: identity,
      );

      if (response['status'] == true) {
        forgotIdentity.value = response['identity']?.toString() ?? identity;
        tempOtp.value = response['temp_otp']?.toString() ?? '';
        successMessage.value = response['message']?.toString() ?? 'OTP generated successfully';
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Failed to send OTP';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp({
    required String identity,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _authService.verifyOtp(
        identity: identity,
        otp: otp,
      );

      if (response['status'] == true) {
        temporaryToken.value = response['temporary_token']?.toString() ?? '';
        successMessage.value = response['message']?.toString() ?? 'OTP verified successfully';
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ?? 'OTP verification failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset Password
  Future<bool> resetPassword({
    required String identity,
    required String otp,
    required String temporaryToken,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _authService.resetPassword(
        identity: identity,
        otp: otp,
        temporaryToken: temporaryToken,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (response['status'] == true) {
        successMessage.value = response['message']?.toString() ?? 'Password reset successfully';
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ?? 'Password reset failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

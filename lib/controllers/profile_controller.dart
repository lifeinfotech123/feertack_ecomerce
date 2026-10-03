import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileService _profileService = ProfileService();

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final Rxn<UserModel> userProfile = Rxn<UserModel>();
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Try fetching profile on controller initialization if auth token is available
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      if (authController.token.value.isNotEmpty) {
        fetchProfile(authController.token.value);
      }
    }
  }

  /// Fetch User Profile
  Future<bool> fetchProfile([String? token]) async {
    String authToken = token ?? '';
    if (authToken.isEmpty && Get.isRegistered<AuthController>()) {
      authToken = Get.find<AuthController>().token.value;
    }

    if (authToken.isEmpty) {
      errorMessage.value = "No authentication token found. Please log in.";
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _profileService.getProfile(token: authToken);

      if (response['status'] == true) {
        if (response['user_model'] != null) {
          userProfile.value = response['user_model'] as UserModel;

          // Sync with AuthController current user if registered
          if (Get.isRegistered<AuthController>()) {
            Get.find<AuthController>().currentUser.value = userProfile.value;
          }
        }
        successMessage.value =
            response['message']?.toString() ?? 'Profile fetched successfully';
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to fetch profile';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update User Profile
  Future<bool> updateProfile({
    required String fName,
    String? lName,
    required String phone,
    String? token,
  }) async {
    String authToken = token ?? '';
    if (authToken.isEmpty && Get.isRegistered<AuthController>()) {
      authToken = Get.find<AuthController>().token.value;
    }

    if (authToken.isEmpty) {
      errorMessage.value = "No authentication token found. Please log in.";
      return false;
    }

    try {
      isUpdating.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _profileService.updateProfile(
        token: authToken,
        fName: fName,
        lName: lName,
        phone: phone,
      );

      if (response['status'] == true) {
        if (response['user_model'] != null) {
          userProfile.value = response['user_model'] as UserModel;

          // Sync with AuthController current user if registered
          if (Get.isRegistered<AuthController>()) {
            Get.find<AuthController>().currentUser.value = userProfile.value;
          }
        }
        successMessage.value =
            response['message']?.toString() ?? 'Profile updated successfully';
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to update profile';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}

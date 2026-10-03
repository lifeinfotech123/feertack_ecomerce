import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/address_model.dart';
import '../services/address_service.dart';

class AddressController extends GetxController implements GetxService {
  final AddressService _addressService = AddressService();

  final RxList<AddressModel> addressList = <AddressModel>[].obs;
  final Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  String _getToken([String? token]) {
    if (token != null && token.isNotEmpty) return token;
    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>().token.value;
    }
    return '';
  }

  /// 1. Fetch Address List
  Future<void> fetchAddresses([String? token]) async {
    final authToken = _getToken(token);
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _addressService.getAddressList(token: authToken);

      if (response['status'] == true) {
        if (response['addresses'] != null) {
          addressList.assignAll(response['addresses'] as List<AddressModel>);
        }
        successMessage.value =
            response['message']?.toString() ?? 'Addresses fetched successfully';
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to fetch addresses';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Add Address
  Future<bool> addAddress({
    required String contactPersonName,
    required String addressType,
    required String address,
    required String city,
    required String zip,
    required String country,
    required String phone,
    String? token,
  }) async {
    final authToken = _getToken(token);
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _addressService.addAddress(
        token: authToken,
        contactPersonName: contactPersonName,
        addressType: addressType,
        address: address,
        city: city,
        zip: zip,
        country: country,
        phone: phone,
      );

      if (response['status'] == true) {
        successMessage.value =
            response['message']?.toString() ?? 'Address added successfully';
        await fetchAddresses(authToken);
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to add address';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 3. Get Address By ID
  Future<bool> getAddressById(int id, [String? token]) async {
    final authToken = _getToken(token);
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _addressService.getAddressById(
        token: authToken,
        id: id,
      );

      if (response['status'] == true) {
        if (response['address_model'] != null) {
          selectedAddress.value = response['address_model'] as AddressModel;
        }
        successMessage.value =
            response['message']?.toString() ?? 'Address fetched successfully';
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to fetch address details';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 4. Update Address
  Future<bool> updateAddress({
    required int id,
    required String contactPersonName,
    required String addressType,
    required String address,
    required String city,
    required String zip,
    required String country,
    required String phone,
    String? token,
  }) async {
    final authToken = _getToken(token);
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _addressService.updateAddress(
        token: authToken,
        id: id,
        contactPersonName: contactPersonName,
        addressType: addressType,
        address: address,
        city: city,
        zip: zip,
        country: country,
        phone: phone,
      );

      if (response['status'] == true) {
        successMessage.value =
            response['message']?.toString() ?? 'Address updated successfully';
        await fetchAddresses(authToken);
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to update address';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 5. Delete Address
  Future<bool> deleteAddress(int id, [String? token]) async {
    final authToken = _getToken(token);
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _addressService.deleteAddress(
        token: authToken,
        id: id,
      );

      if (response['status'] == true) {
        successMessage.value =
            response['message']?.toString() ?? 'Address deleted successfully';
        addressList.removeWhere((item) => item.id == id);
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to delete address';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}

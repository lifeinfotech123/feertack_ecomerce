import 'package:get/get.dart';
import '../models/wishlist_model.dart';
import '../services/wishlist_service.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';

class AddToCartAndWishlist extends GetxController implements GetxService {
  final WishlistService _wishlistService = WishlistService();

  final RxList<WishlistItemModel> wishlistList = <WishlistItemModel>[].obs;
  final RxSet<int> wishlistProductIds = <int>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  final RxInt wishlistCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  String _getToken([String? token]) {
    if (token != null && token.isNotEmpty) return token;
    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>().token.value;
    }
    return '';
  }

  /// Check if product is in wishlist
  bool isWishlisted(int productId) {
    return wishlistProductIds.contains(productId);
  }

  /// 1. Fetch Wishlist Items
  Future<void> fetchWishlist([String? token]) async {
    final authToken = _getToken(token);
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _wishlistService.getWishlist(token: authToken);

      if (response['status'] == true) {
        if (response['wishlist'] != null) {
          final List<WishlistItemModel> items =
              response['wishlist'] as List<WishlistItemModel>;
          wishlistList.assignAll(items);
          wishlistCount.value = response['count'] is int
              ? response['count']
              : (int.tryParse(response['count']?.toString() ?? '') ??
                  items.length);
          wishlistProductIds.assignAll(items.map((e) => e.productId));
        } else {
          wishlistList.clear();
          wishlistCount.value = 0;
          wishlistProductIds.clear();
        }
        successMessage.value =
            response['message']?.toString() ?? 'Wishlist fetched successfully';
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to fetch wishlist';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Add Product to Wishlist
  Future<bool> addToWishlist(int productId, [String? token]) async {
    final authToken = _getToken(token);
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _wishlistService.addToWishlist(
        token: authToken,
        productId: productId,
      );

      if (response['status'] == true) {
        successMessage.value = response['message']?.toString() ??
            'Product added to wishlist successfully.';
        wishlistProductIds.add(productId);
        await fetchWishlist(authToken);
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ??
            'Failed to add product to wishlist';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 3. Remove Product from Wishlist
  Future<bool> removeFromWishlist(int productId, [String? token]) async {
    final authToken = _getToken(token);
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _wishlistService.removeFromWishlist(
        token: authToken,
        productId: productId,
      );

      if (response['status'] == true) {
        successMessage.value = response['message']?.toString() ??
            'Product removed from wishlist successfully.';
        wishlistProductIds.remove(productId);
        wishlistList.removeWhere((item) => item.productId == productId);
        wishlistCount.value = wishlistList.length;
        return true;
      } else {
        errorMessage.value = response['message']?.toString() ??
            'Failed to remove product from wishlist';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 4. Toggle Wishlist
  Future<bool> toggleWishlist(int productId, [String? token]) async {
    if (isWishlisted(productId)) {
      return await removeFromWishlist(productId, token);
    } else {
      return await addToWishlist(productId, token);
    }
  }

  /// 5. Add Product to Cart API & Local Cart Controller
  Future<bool> addToCart(int productId,
      {WishlistItemModel? wishlistModel, String? token}) async {
    final authToken = _getToken(token);
    try {
      isSubmitting.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await _wishlistService.addToCart(
        token: authToken,
        productId: productId,
      );

      if (response['status'] == true) {
        successMessage.value = response['message']?.toString() ??
            'Product added to cart successfully.';

        if (wishlistModel != null) {
          CartController.instance.addToCart(wishlistModel.toProductModel());
        }

        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to add product to cart';
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

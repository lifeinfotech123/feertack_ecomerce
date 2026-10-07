import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/address_controller.dart';
import 'package:shop/controllers/cart_controller.dart';
import 'package:shop/controllers/order_controller.dart';
import 'package:shop/models/address_model.dart';
import 'package:shop/route/route_constants.dart';

enum PaymentType { upi, bankCard, netBanking, cod }

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final CartController _cart = CartController.instance;
  late final OrderController _orderController;
  late final AddressController _addressController;

  PaymentType _selectedPaymentType = PaymentType.cod;
  String _selectedUpiApp = "Google Pay";
  String _selectedBank = "HDFC Bank";
  bool _isProcessing = false;
  bool _showItemsSummary = false;
  int? _selectedAddressId;

  final TextEditingController _upiIdController = TextEditingController();
  final TextEditingController _cardNumberController =
      TextEditingController(text: "4532 •••• •••• 8821");
  final TextEditingController _cardHolderController =
      TextEditingController(text: "ALEXANDER SMITH");
  final TextEditingController _cardExpiryController =
      TextEditingController(text: "08/28");
  final TextEditingController _cardCvvController =
      TextEditingController(text: "842");

  final List<Map<String, dynamic>> _upiApps = [
    {
      "name": "Google Pay",
      "icon": Icons.account_balance_wallet_rounded,
      "color": const Color(0xFF4285F4),
    },
    {
      "name": "PhonePe",
      "icon": Icons.payment_rounded,
      "color": const Color(0xFF6739B7),
    },
    {
      "name": "Paytm",
      "icon": Icons.currency_rupee_rounded,
      "color": const Color(0xFF00B9F1),
    },
  ];

  final List<String> _popularBanks = [
    "HDFC Bank",
    "State Bank of India (SBI)",
    "ICICI Bank",
    "Axis Bank",
    "Kotak Mahindra Bank",
  ];

  @override
  void initState() {
    super.initState();
    _orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    _addressController = Get.isRegistered<AddressController>()
        ? Get.find<AddressController>()
        : Get.put(AddressController());

    _addressController.fetchAddresses();
    _orderController.fetchCheckoutSummary();
  }

  @override
  void dispose() {
    _upiIdController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  List<AddressModel> _getAvailableAddresses() {
    final Map<int, AddressModel> addressMap = {};

    final summaryAddresses =
        _orderController.checkoutSummary.value?.savedAddresses ?? [];
    for (var addr in summaryAddresses) {
      if (addr.id != null) {
        addressMap[addr.id!] = addr;
      }
    }

    for (var addr in _addressController.addressList) {
      if (addr.id != null) {
        addressMap[addr.id!] = addr;
      }
    }

    return addressMap.values.toList();
  }

  AddressModel? _getEffectiveSelectedAddress(List<AddressModel> addresses) {
    if (addresses.isEmpty) return null;
    if (_selectedAddressId != null) {
      for (var a in addresses) {
        if (a.id == _selectedAddressId) return a;
      }
    }
    for (var a in addresses) {
      if (a.isDefault == 1) return a;
    }
    return addresses.first;
  }

  void _processPayment() async {
    final addresses = _getAvailableAddresses();
    final selectedAddress = _getEffectiveSelectedAddress(addresses);

    if (selectedAddress == null || selectedAddress.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "No delivery address found. Please add an address to continue.",
          ),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: "ADD ADDRESS",
            textColor: Colors.white,
            onPressed: () => _showAddressFormDialog(),
          ),
        ),
      );
      return;
    }

    final int addressId = selectedAddress.id!;

    setState(() {
      _isProcessing = true;
    });

    final success = await _orderController.placeOrder(addressId: addressId);

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      final result = _orderController.lastPlacedOrder.value;
      final double paidTotal = result?.orderAmount ?? _cart.grandTotal;
      final double savedTotal = _cart.totalSavings;
      final int itemsCount = _cart.totalItemCount;

      _cart.clearCart();

      Navigator.pushReplacementNamed(
        context,
        thanksForOrderScreenRoute,
        arguments: {
          "paymentMethod": result?.paymentMethod ?? "Cash on Delivery",
          "amount": paidTotal,
          "savings": savedTotal,
          "itemsCount": itemsCount,
          "orderId": result?.orderId,
          "formattedAmount": result?.formattedAmount,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _orderController.errorMessage.value.isNotEmpty
                ? _orderController.errorMessage.value
                : "Failed to place order. Please try again.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPaymentHeader({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget title,
    required String subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : greyColor,
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: greyColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? darkGreyColor : whiteColor;
    final bodyBg = isDark ? const Color(0xFF121218) : const Color(0xFFF6F6F9);

    return Scaffold(
      backgroundColor: bodyBg,
      appBar: AppBar(
        backgroundColor: bodyBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment & Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        final summary = _orderController.checkoutSummary.value?.summary;
        final allAddresses = _getAvailableAddresses();
        final currentAddress = _getEffectiveSelectedAddress(allAddresses);

        if (_selectedAddressId == null && currentAddress != null) {
          _selectedAddressId = currentAddress.id;
        }

        final subtotal = summary?.subtotal ?? _cart.subtotal;
        final shippingCost = summary?.shippingCost ?? _cart.deliveryFee;
        final discountAmount = summary?.totalDiscount ?? _cart.discountAmount;
        final grandTotal = summary?.grandTotal ?? _cart.grandTotal;
        final savings = _cart.totalSavings;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Delivery Address Card / Address Selector
              _buildDeliveryAddressSection(cardBg, isDark, currentAddress, allAddresses),

              const SizedBox(height: defaultPadding),

              // 2. Order Items Collapsible Card
              _buildOrderItemsCard(cardBg, isDark, _cart.items),

              const SizedBox(height: defaultPadding),

              // 3. Payment Methods Section Title
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Choose Payment Method",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield_rounded,
                            size: 12, color: successColor),
                        SizedBox(width: 4),
                        Text(
                          "100% SECURE",
                          style: TextStyle(
                            color: successColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Payment Option 1: Cash On Delivery
              _buildCodOption(cardBg, isDark),

              const SizedBox(height: 10),

              // 5. Payment Option 2: UPI
              _buildUpiPaymentOption(cardBg, isDark),

              const SizedBox(height: 10),

              // 6. Payment Option 3: Bank Cards
              _buildBankCardPaymentOption(cardBg, isDark),

              const SizedBox(height: 10),

              // 7. Payment Option 4: Net Banking
              _buildNetBankingOption(cardBg, isDark),

              const SizedBox(height: defaultPadding * 1.2),

              // 8. Bill Details Summary Card
              _buildDetailedBillCard(
                cardBg: cardBg,
                isDark: isDark,
                subtotal: subtotal,
                deliveryFee: shippingCost,
                discountAmount: discountAmount,
                appliedCouponCode: _cart.appliedCoupon?.code,
                isFreeDeliveryCoupon:
                    _cart.appliedCoupon?.isFreeDelivery ?? false,
                grandTotal: grandTotal,
                savings: savings,
              ),

              const SizedBox(height: defaultPadding * 2),
            ],
          ),
        );
      }),

      // Bottom Sticky Pay Button
      bottomNavigationBar: Obx(() {
        final summary = _orderController.checkoutSummary.value?.summary;
        final grandTotal = summary?.grandTotal ?? _cart.grandTotal;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding * 0.75,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total To Pay",
                      style: TextStyle(
                        fontSize: 10.5,
                        color: greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "\$${grandTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.lock_rounded,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                "PLACE ORDER (\$${grandTotal.toStringAsFixed(2)})",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDeliveryAddressSection(
      Color cardBg, bool isDark, AddressModel? currentAddress, List<AddressModel> allAddresses) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Location.svg",
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.white : blackColor,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  if (allAddresses.isNotEmpty) {
                    _showSelectAddressModal(allAddresses);
                  } else {
                    _showAddressFormDialog();
                  }
                },
                icon: Icon(
                  allAddresses.isNotEmpty
                      ? Icons.swap_horiz_rounded
                      : Icons.add_circle_outline,
                  size: 16,
                ),
                label: Text(
                  allAddresses.isNotEmpty
                      ? (allAddresses.length > 1 ? "Change" : "Manage")
                      : "Add New",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (currentAddress == null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: errorColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: errorColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "No Delivery Address Found",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: errorColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Please add a delivery address to place your order.",
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showAddressFormDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "+ Add Address",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E28)
                    : primaryColor.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (currentAddress.addressType ?? 'home').toUpperCase(),
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          currentAddress.contactPersonName ?? 'Delivery Contact',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.check_circle,
                          color: successColor, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          [
                            currentAddress.address,
                            currentAddress.city,
                            currentAddress.state,
                            currentAddress.zip,
                            currentAddress.country,
                          ]
                              .where((s) => s != null && s.trim().isNotEmpty)
                              .join(", "),
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (currentAddress.phone != null &&
                      currentAddress.phone!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          currentAddress.phone!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSelectAddressModal(List<AddressModel> addresses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(modalContext).size.height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Delivery Address",
                    style: Theme.of(modalContext).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(modalContext),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding / 2),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    final isSelected = address.id == _selectedAddressId;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? primaryColor
                              : Colors.grey.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAddressId = address.id;
                          });
                          Navigator.pop(modalContext);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: address.id ?? index,
                                groupValue: _selectedAddressId,
                                onChanged: (val) {
                                  setState(() {
                                    _selectedAddressId = address.id;
                                  });
                                  Navigator.pop(modalContext);
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColor
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            (address.addressType ?? 'home')
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: primaryColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          address.contactPersonName ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      [
                                        address.address,
                                        address.city,
                                        address.zip
                                      ]
                                          .where((s) =>
                                              s != null && s.trim().isNotEmpty)
                                          .join(", "),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    if (address.phone != null &&
                                        address.phone!.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        address.phone!,
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(modalContext);
                    _showAddressFormDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Address"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddressFormDialog({AddressModel? addressToEdit}) {
    final isEdit = addressToEdit != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(
      text: addressToEdit?.contactPersonName ?? '',
    );
    final streetController = TextEditingController(
      text: addressToEdit?.address ?? '',
    );
    final cityController = TextEditingController(
      text: addressToEdit?.city ?? '',
    );
    final zipController = TextEditingController(
      text: addressToEdit?.zip ?? '',
    );
    final countryController = TextEditingController(
      text: addressToEdit?.country ?? 'India',
    );
    final phoneController = TextEditingController(
      text: addressToEdit?.phone ?? '',
    );
    String addressType = addressToEdit?.addressType ?? 'home';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom +
                    defaultPadding,
                top: defaultPadding,
                left: defaultPadding,
                right: defaultPadding,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEdit ? "Update Address" : "Add New Address",
                            style: Theme.of(modalContext)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(modalContext),
                          ),
                        ],
                      ),
                      const SizedBox(height: defaultPadding),

                      TextFormField(
                        controller: nameController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Contact name is required'
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Contact Person Name",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: defaultPadding / 2),

                      Row(
                        children: ['home', 'office', 'permanent'].map((type) {
                          final isSelected = addressType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(type.capitalizeFirst ?? type),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setModalState(() {
                                    addressType = type;
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: defaultPadding / 2),

                      TextFormField(
                        controller: streetController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Address is required'
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Street Address",
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: defaultPadding / 2),

                      TextFormField(
                        controller: cityController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'City is required'
                            : null,
                        decoration: const InputDecoration(
                          hintText: "City",
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                      ),
                      const SizedBox(height: defaultPadding / 2),

                      TextFormField(
                        controller: zipController,
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Zip code is required'
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Zip Code",
                          prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                        ),
                      ),
                      const SizedBox(height: defaultPadding / 2),

                      TextFormField(
                        controller: countryController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Country is required'
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Country",
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                      ),
                      const SizedBox(height: defaultPadding / 2),

                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Phone number is required'
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Phone Number",
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: defaultPadding * 1.5),

                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _addressController.isSubmitting.value
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      bool success = false;
                                      if (isEdit) {
                                        success =
                                            await _addressController.updateAddress(
                                          id: addressToEdit.id!,
                                          contactPersonName:
                                              nameController.text.trim(),
                                          addressType: addressType,
                                          address:
                                              streetController.text.trim(),
                                          city: cityController.text.trim(),
                                          zip: zipController.text.trim(),
                                          country:
                                              countryController.text.trim(),
                                          phone: phoneController.text.trim(),
                                        );
                                      } else {
                                        success =
                                            await _addressController.addAddress(
                                          contactPersonName:
                                              nameController.text.trim(),
                                          addressType: addressType,
                                          address:
                                              streetController.text.trim(),
                                          city: cityController.text.trim(),
                                          zip: zipController.text.trim(),
                                          country:
                                              countryController.text.trim(),
                                          phone: phoneController.text.trim(),
                                        );
                                      }

                                      if (!modalContext.mounted || !mounted) return;

                                      if (success) {
                                        Navigator.pop(modalContext);
                                        await _addressController.fetchAddresses();
                                        await _orderController.fetchCheckoutSummary();
                                        if (_addressController.addressList.isNotEmpty) {
                                          setState(() {
                                            _selectedAddressId = _addressController.addressList.last.id;
                                          });
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              _addressController
                                                  .successMessage.value,
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              _addressController
                                                  .errorMessage.value,
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: _addressController.isSubmitting.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(isEdit
                                    ? "Update Address"
                                    : "Save Address"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOrderItemsCard(
      Color cardBg, bool isDark, List<CartItemModel> items) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showItemsSummary = !_showItemsSummary;
              });
            },
            borderRadius: BorderRadius.circular(defaultBorderRadious),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Bag.svg",
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Order Items (${_cart.totalItemCount})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _showItemsSummary ? "Hide" : "View Details",
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showItemsSummary
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_showItemsSummary) ...[
            const Divider(height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 40,
                        height: 40,
                        color:
                            isDark ? Colors.white10 : const Color(0xFFF6F6F9),
                        child: NetworkImageWithLoader(
                          item.product.image,
                          radius: 6,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Qty: ${item.quantity} × \$${item.unitPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isDark ? Colors.white54 : greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$${item.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpiPaymentOption(Color cardBg, bool isDark) {
    final isSelected = _selectedPaymentType == PaymentType.upi;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(
          color: isSelected
              ? primaryColor
              : (isDark ? Colors.white10 : const Color(0xFFE5E5EA)),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          _buildPaymentHeader(
            isSelected: isSelected,
            onTap: () {
              setState(() => _selectedPaymentType = PaymentType.upi);
            },
            title: const Text(
              "UPI (Google Pay, PhonePe, Paytm)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            subtitle: "Instant payment using any UPI app or UPI ID",
          ),
          if (isSelected) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  const Text(
                    "Select UPI App:",
                    style:
                        TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _upiApps.map((app) {
                      final isAppSelected = _selectedUpiApp == app["name"];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedUpiApp = app["name"]);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isAppSelected
                                  ? primaryColor.withValues(alpha: 0.12)
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : const Color(0xFFF6F6F9)),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isAppSelected
                                    ? primaryColor
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  app["icon"] as IconData,
                                  color: app["color"] as Color,
                                  size: 22,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  app["name"] as String,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: isAppSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isAppSelected
                                        ? primaryColor
                                        : (isDark
                                            ? Colors.white70
                                            : blackColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Or Enter UPI ID:",
                    style:
                        TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _upiIdController,
                    decoration: InputDecoration(
                      hintText: "username@okhdfcbank / paytm",
                      hintStyle:
                          const TextStyle(fontSize: 11.5, color: greyColor),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF262634)
                          : const Color(0xFFF6F6F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          if (_upiIdController.text.trim().isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("UPI ID Verified Successfully!"),
                                duration: Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Verify",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBankCardPaymentOption(Color cardBg, bool isDark) {
    final isSelected = _selectedPaymentType == PaymentType.bankCard;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(
          color: isSelected
              ? primaryColor
              : (isDark ? Colors.white10 : const Color(0xFFE5E5EA)),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          _buildPaymentHeader(
            isSelected: isSelected,
            onTap: () {
              setState(() => _selectedPaymentType = PaymentType.bankCard);
            },
            title: const Row(
              children: [
                Text(
                  "Credit / Debit Card",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.credit_card_rounded, color: primaryColor, size: 18),
              ],
            ),
            subtitle: "Visa, Mastercard, RuPay & more",
          ),
          if (isSelected) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2C2C3E), Color(0xFF151520)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "STANDARD CARD",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "VISA",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _cardNumberController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _cardHolderController.text,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "EXP: ${_cardExpiryController.text}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cardExpiryController,
                          decoration: InputDecoration(
                            labelText: "Valid Thru (MM/YY)",
                            labelStyle: const TextStyle(fontSize: 11),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF262634)
                                : const Color(0xFFF6F6F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _cardCvvController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "CVV",
                            labelStyle: const TextStyle(fontSize: 11),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            filled: true,
                            fillColor: isDark
                                ? const Color(0xFF262634)
                                : const Color(0xFFF6F6F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNetBankingOption(Color cardBg, bool isDark) {
    final isSelected = _selectedPaymentType == PaymentType.netBanking;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(
          color: isSelected
              ? primaryColor
              : (isDark ? Colors.white10 : const Color(0xFFE5E5EA)),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          _buildPaymentHeader(
            isSelected: isSelected,
            onTap: () {
              setState(() => _selectedPaymentType = PaymentType.netBanking);
            },
            title: const Row(
              children: [
                Text(
                  "Net Banking",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.account_balance_rounded,
                    color: primaryColor, size: 18),
              ],
            ),
            subtitle: "All Major Indian & International Banks",
          ),
          if (isSelected) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  const Text(
                    "Select Your Bank:",
                    style:
                        TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF262634)
                          : const Color(0xFFF6F6F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBank,
                        isExpanded: true,
                        dropdownColor: cardBg,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: _popularBanks.map((bank) {
                          return DropdownMenuItem<String>(
                            value: bank,
                            child: Row(
                              children: [
                                const Icon(Icons.account_balance_outlined,
                                    size: 16, color: primaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  bank,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedBank = val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCodOption(Color cardBg, bool isDark) {
    final isSelected = _selectedPaymentType == PaymentType.cod;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(
          color: isSelected
              ? primaryColor
              : (isDark ? Colors.white10 : const Color(0xFFE5E5EA)),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: _buildPaymentHeader(
        isSelected: isSelected,
        onTap: () {
          setState(() => _selectedPaymentType = PaymentType.cod);
        },
        title: const Row(
          children: [
            Text(
              "Cash on Delivery (COD)",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.handshake_outlined, color: primaryColor, size: 18),
          ],
        ),
        subtitle: "Pay cash or via UPI at your doorstep",
      ),
    );
  }

  Widget _buildDetailedBillCard({
    required Color cardBg,
    required bool isDark,
    required double subtotal,
    required double deliveryFee,
    required double discountAmount,
    required String? appliedCouponCode,
    required bool isFreeDeliveryCoupon,
    required double grandTotal,
    required double savings,
  }) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bill Details Summary",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
              ),
              if (savings > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "You Save \$${savings.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: successColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Subtotal
          _buildBillRow("Item Subtotal", "\$${subtotal.toStringAsFixed(2)}",
              isDark: isDark),
          const SizedBox(height: 8),

          // Delivery
          _buildBillRow(
            "Express Delivery Charge",
            deliveryFee == 0 ? "FREE" : "\$${deliveryFee.toStringAsFixed(2)}",
            isHighlight: deliveryFee == 0,
            isDark: isDark,
          ),

          // Coupon Discount if active
          if (appliedCouponCode != null && discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildBillRow(
              "Coupon Savings ($appliedCouponCode)",
              "-\$${discountAmount.toStringAsFixed(2)}",
              isDiscount: true,
              isDark: isDark,
            ),
          ],

          if (isFreeDeliveryCoupon) ...[
            const SizedBox(height: 8),
            _buildBillRow(
              "Free Delivery Coupon ($appliedCouponCode)",
              "WAIVED",
              isDiscount: true,
              isDark: isDark,
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${grandTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    bool isHighlight = false,
    bool isDiscount = false,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: (isHighlight || isDiscount)
                ? successColor
                : (isDark ? Colors.white : blackColor),
          ),
        ),
      ],
    );
  }
}

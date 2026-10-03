import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants.dart';
import '../../../../controllers/address_controller.dart';
import '../../../../models/address_model.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late final AddressController _addressController;

  @override
  void initState() {
    super.initState();
    _addressController = Get.isRegistered<AddressController>()
        ? Get.find<AddressController>()
        : Get.put(AddressController());

    _addressController.fetchAddresses();
  }

  void _showAddressFormDialog({AddressModel? addressToEdit}) {
    final isEdit = addressToEdit != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(
      text: addressToEdit?.contactPersonName ?? '',
    );
    final addressController = TextEditingController(
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

                      // Contact Person Name
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

                      // Address Type Selector
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

                      // Street Address
                      TextFormField(
                        controller: addressController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Address is required'
                            : null,
                        decoration: const InputDecoration(
                          hintText: "Street Address",
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                      const SizedBox(height: defaultPadding / 2),

                      // City
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

                      // Zip Code
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

                      // Country
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

                      // Phone
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

                      // Submit Button
                      Obx(
                        () => ElevatedButton(
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
                                            addressController.text.trim(),
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
                                            addressController.text.trim(),
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

  void _confirmDelete(AddressModel address) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadious),
        ),
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: errorColor),
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (address.id != null) {
                final success =
                    await _addressController.deleteAddress(address.id!);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? _addressController.successMessage.value
                          : _addressController.errorMessage.value,
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Addresses"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Add Address"),
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        if (_addressController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_addressController.addressList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: defaultPadding),
                const Text(
                  "No addresses found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                const Text(
                  "Add a new address for faster checkout",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: defaultPadding * 1.5),
                ElevatedButton.icon(
                  onPressed: () => _showAddressFormDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Address"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _addressController.fetchAddresses(),
          child: ListView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: _addressController.addressList.length,
            itemBuilder: (context, index) {
              final address = _addressController.addressList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: defaultPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (address.addressType ?? 'home').toUpperCase(),
                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                address.contactPersonName ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () {
                                  _showAddressFormDialog(
                                      addressToEdit: address);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 20, color: errorColor),
                                onPressed: () => _confirmDelete(address),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        address.address ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${address.city ?? ''}, ${address.zip ?? ''}, ${address.country ?? ''}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            address.phone ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

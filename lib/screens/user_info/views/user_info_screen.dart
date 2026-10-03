import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/profile_controller.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileController _profileController;

  late final TextEditingController _fNameController;
  late final TextEditingController _lNameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    final user = _profileController.userProfile.value;
    _fNameController = TextEditingController(text: user?.fName ?? '');
    _lNameController = TextEditingController(text: user?.lName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onUpdateProfile() async {
    if (_formKey.currentState!.validate()) {
      final fName = _fNameController.text.trim();
      final lName = _lNameController.text.trim();
      final phone = _phoneController.text.trim();

      final success = await _profileController.updateProfile(
        fName: fName,
        lName: lName,
        phone: phone,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_profileController.successMessage.value),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_profileController.errorMessage.value),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Details"),
      ),
      body: SafeArea(
        child: Obx(() {
          final user = _profileController.userProfile.value;
          final avatarUrl = user?.avatar?.isNotEmpty == true
              ? user!.avatar!
              : "https://i.imgur.com/IXnwbLk.png";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: NetworkImageWithLoader(
                          avatarUrl,
                          radius: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding),

                Text(
                  user?.name ?? "${user?.fName ?? ''} ${user?.lName ?? ''}".trim(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: defaultPadding * 1.5),

                // Info Cards Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: "Orders",
                        value: "${user?.ordersCount ?? 0}",
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: "Loyalty Points",
                        value: "${user?.loyaltyPoint ?? 0}",
                        icon: Icons.card_giftcard,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),

                // Update Profile Form
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Edit Profile Info",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: defaultPadding),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // First Name
                      TextFormField(
                        controller: _fNameController,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "First Name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding * 0.75),
                            child: Icon(
                              Icons.person_outline,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),

                      // Last Name
                      TextFormField(
                        controller: _lNameController,
                        decoration: InputDecoration(
                          hintText: "Last Name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding * 0.75),
                            child: Icon(
                              Icons.person_outline,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),

                      // Phone
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: defaultPadding * 0.75),
                            child: Icon(
                              Icons.phone_outlined,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),

                // Update Profile Button
                Obx(
                  () => ElevatedButton(
                    onPressed: _profileController.isUpdating.value
                        ? null
                        : _onUpdateProfile,
                    child: _profileController.isUpdating.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Update Profile"),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E28) : Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFECECF2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

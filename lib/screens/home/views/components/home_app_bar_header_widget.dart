import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';

class HomeAppBarHeaderWidget extends StatelessWidget {
  const HomeAppBarHeaderWidget({
    super.key,
    this.userName = "Amrita Kumari",
    this.userImage = "https://i.imgur.com/IXn2A0P.png",
    this.location = "New York, USA",
  });

  final String userName;
  final String userImage;
  final String location;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    // Rich modern gradient for header
    final headerGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF231942), Color(0xFF130E26)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFF7B61FF), Color(0xFF5333ED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: headerGradient,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : const Color(0xFF7B61FF))
                  .withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top: topPadding + 8,
          left: defaultPadding,
          right: defaultPadding,
          bottom: defaultPadding * 1.2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Profile Avatar, Greeting, User Name & Action Buttons
            Row(
              children: [
                // Profile Avatar with White Ring & Online Status
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, profileScreenRoute);
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white24,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: NetworkImageWithLoader(
                              userImage,
                              radius: 100,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          height: 11,
                          width: 11,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Greeting & User Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning 👋",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFFFFD54F),
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Notification & Cart Action Buttons
                Row(
                  children: [
                    // Notification Button
                    Material(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          Navigator.pushNamed(context, notificationsScreenRoute);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Notification.svg",
                                height: 20,
                                width: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF3D00),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Cart / Shopping Bag Button
                    Material(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          Navigator.pushNamed(context, cartScreenRoute);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Bag.svg",
                                height: 20,
                                width: 20,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF4081),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  child: const Text(
                                    "3",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Delivery Location Glassmorphic Chip
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, addressesScreenRoute);
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Location.svg",
                      height: 14,
                      width: 14,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Deliver to: ",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      "assets/icons/Arrow - Down.svg",
                      height: 10,
                      width: 10,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Floating Search Bar Card
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, searchScreenRoute);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262038) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Search.svg",
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Search for products, brands...",
                        style: TextStyle(
                          fontSize: 13.5,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF888894),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 1,
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                    ),
                    const SizedBox(width: 10),
                    SvgPicture.asset(
                      "assets/icons/Filter.svg",
                      height: 18,
                      width: 18,
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
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
  }
}

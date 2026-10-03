class UserModel {
  final int? id;
  final String? name;
  final String? fName;
  final String? lName;
  final String? email;
  final String? phone;
  final String? avatar;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final num? walletBalance;
  final num? loyaltyPoint;
  final String? referralCode;
  final String? streetAddress;
  final String? city;
  final String? zip;
  final String? country;
  final int? ordersCount;
  final int? wishlistCount;
  final int? referralUserCount;
  final String? createdAt;

  UserModel({
    this.id,
    this.name,
    this.fName,
    this.lName,
    this.email,
    this.phone,
    this.avatar,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.walletBalance,
    this.loyaltyPoint,
    this.referralCode,
    this.streetAddress,
    this.city,
    this.zip,
    this.country,
    this.ordersCount,
    this.wishlistCount,
    this.referralUserCount,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String?,
      fName: json['f_name'] as String?,
      lName: json['l_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      isPhoneVerified: json['is_phone_verified'] == true ||
          json['is_phone_verified'] == 1 ||
          json['is_phone_verified']?.toString() == 'true',
      isEmailVerified: json['is_email_verified'] == true ||
          json['is_email_verified'] == 1 ||
          json['is_email_verified']?.toString() == 'true',
      walletBalance: json['wallet_balance'] is num
          ? json['wallet_balance']
          : double.tryParse(json['wallet_balance']?.toString() ?? '0'),
      loyaltyPoint: json['loyalty_point'] is num
          ? json['loyalty_point']
          : int.tryParse(json['loyalty_point']?.toString() ?? '0'),
      referralCode: json['referral_code'] as String?,
      streetAddress: json['street_address'] as String?,
      city: json['city'] as String?,
      zip: json['zip'] as String?,
      country: json['country'] as String?,
      ordersCount: json['orders_count'] is int
          ? json['orders_count']
          : int.tryParse(json['orders_count']?.toString() ?? '0'),
      wishlistCount: json['wishlist_count'] is int
          ? json['wishlist_count']
          : int.tryParse(json['wishlist_count']?.toString() ?? '0'),
      referralUserCount: json['referral_user_count'] is int
          ? json['referral_user_count']
          : int.tryParse(json['referral_user_count']?.toString() ?? '0'),
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'is_phone_verified': isPhoneVerified,
      'is_email_verified': isEmailVerified,
      'wallet_balance': walletBalance,
      'loyalty_point': loyaltyPoint,
      'referral_code': referralCode,
      'street_address': streetAddress,
      'city': city,
      'zip': zip,
      'country': country,
      'orders_count': ordersCount,
      'wishlist_count': wishlistCount,
      'referral_user_count': referralUserCount,
      'created_at': createdAt,
    };
  }
}

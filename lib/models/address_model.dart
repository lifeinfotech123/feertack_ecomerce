class AddressModel {
  final int? id;
  final dynamic customerId;
  final String? contactPersonName;
  final String? addressType;
  final String? address;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
  final String? phone;
  final String? email;
  final String? latitude;
  final String? longitude;
  final bool? isBilling;
  final bool? isGuest;
  final int? isDefault;
  final String? createdAt;
  final String? updatedAt;

  AddressModel({
    this.id,
    this.customerId,
    this.contactPersonName,
    this.addressType,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.phone,
    this.email,
    this.latitude,
    this.longitude,
    this.isBilling,
    this.isGuest,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      customerId: json['customer_id'],
      contactPersonName: json['contact_person_name'] as String?,
      addressType: json['address_type'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
      country: json['country'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      isBilling: json['is_billing'] == true ||
          json['is_billing'] == 1 ||
          json['is_billing']?.toString() == 'true',
      isGuest: json['is_guest'] == true ||
          json['is_guest'] == 1 ||
          json['is_guest']?.toString() == 'true',
      isDefault: json['is_default'] is int
          ? json['is_default']
          : int.tryParse(json['is_default']?.toString() ?? '0'),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'contact_person_name': contactPersonName,
      'address_type': addressType,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'phone': phone,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'is_billing': isBilling,
      'is_guest': isGuest,
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

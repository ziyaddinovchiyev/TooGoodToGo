import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { customer, vendor }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserType userType;
  final GeoPoint? location;
  final String? address;
  final DateTime createdAt;
  final DateTime lastActive;
  final bool isVerified;
  final Map<String, dynamic>? preferences;

  // Vendor specific fields
  final String? businessName;
  final String? businessDescription;
  final String? businessCategory;
  final List<String>? businessImages;
  final double? rating;
  final int? totalOrders;
  final bool? isActive;

  // Customer specific fields
  final List<String>? favoriteVendors;
  final List<String>? orderHistory;
  final double? totalSpent;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImageUrl,
    required this.userType,
    this.location,
    this.address,
    required this.createdAt,
    required this.lastActive,
    this.isVerified = false,
    this.preferences,
    this.businessName,
    this.businessDescription,
    this.businessCategory,
    this.businessImages,
    this.rating,
    this.totalOrders,
    this.isActive,
    this.favoriteVendors,
    this.orderHistory,
    this.totalSpent,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${data['userType']}',
        orElse: () => UserType.customer,
      ),
      location: data['location'],
      address: data['address'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActive: (data['lastActive'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
      preferences: data['preferences'],
      businessName: data['businessName'],
      businessDescription: data['businessDescription'],
      businessCategory: data['businessCategory'],
      businessImages: List<String>.from(data['businessImages'] ?? []),
      rating: data['rating']?.toDouble(),
      totalOrders: data['totalOrders'],
      isActive: data['isActive'],
      favoriteVendors: List<String>.from(data['favoriteVendors'] ?? []),
      orderHistory: List<String>.from(data['orderHistory'] ?? []),
      totalSpent: data['totalSpent']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'userType': userType.toString().split('.').last,
      'location': location,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'isVerified': isVerified,
      'preferences': preferences,
      'businessName': businessName,
      'businessDescription': businessDescription,
      'businessCategory': businessCategory,
      'businessImages': businessImages,
      'rating': rating,
      'totalOrders': totalOrders,
      'isActive': isActive,
      'favoriteVendors': favoriteVendors,
      'orderHistory': orderHistory,
      'totalSpent': totalSpent,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    UserType? userType,
    GeoPoint? location,
    String? address,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? isVerified,
    Map<String, dynamic>? preferences,
    String? businessName,
    String? businessDescription,
    String? businessCategory,
    List<String>? businessImages,
    double? rating,
    int? totalOrders,
    bool? isActive,
    List<String>? favoriteVendors,
    List<String>? orderHistory,
    double? totalSpent,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
      location: location ?? this.location,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isVerified: isVerified ?? this.isVerified,
      preferences: preferences ?? this.preferences,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      businessCategory: businessCategory ?? this.businessCategory,
      businessImages: businessImages ?? this.businessImages,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      isActive: isActive ?? this.isActive,
      favoriteVendors: favoriteVendors ?? this.favoriteVendors,
      orderHistory: orderHistory ?? this.orderHistory,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }
} 
import 'package:cloud_firestore/cloud_firestore.dart';

enum MagicBagStatus { available, reserved, sold, expired }
enum FoodCategory { bakery, restaurant, cafe, grocery, convenience, other }

class MagicBagModel {
  final String id;
  final String vendorId;
  final String vendorName;
  final String title;
  final String description;
  final List<String> foodItems;
  final List<String> images;
  final double originalPrice;
  final double discountedPrice;
  final int quantity;
  final int availableQuantity;
  final FoodCategory category;
  final MagicBagStatus status;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final DateTime createdAt;
  final DateTime expiresAt;
  final GeoPoint location;
  final String address;
  final double? rating;
  final int? totalReviews;
  final List<String>? allergens;
  final Map<String, dynamic>? additionalInfo;

  MagicBagModel({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.title,
    required this.description,
    required this.foodItems,
    required this.images,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
    required this.availableQuantity,
    required this.category,
    required this.status,
    required this.pickupStartTime,
    required this.pickupEndTime,
    required this.createdAt,
    required this.expiresAt,
    required this.location,
    required this.address,
    this.rating,
    this.totalReviews,
    this.allergens,
    this.additionalInfo,
  });

  factory MagicBagModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return MagicBagModel(
      id: doc.id,
      vendorId: data['vendorId'] ?? '',
      vendorName: data['vendorName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      foodItems: List<String>.from(data['foodItems'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      originalPrice: (data['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (data['discountedPrice'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      availableQuantity: data['availableQuantity'] ?? 0,
      category: FoodCategory.values.firstWhere(
        (e) => e.toString() == 'FoodCategory.${data['category']}',
        orElse: () => FoodCategory.other,
      ),
      status: MagicBagStatus.values.firstWhere(
        (e) => e.toString() == 'MagicBagStatus.${data['status']}',
        orElse: () => MagicBagStatus.available,
      ),
      pickupStartTime: (data['pickupStartTime'] as Timestamp).toDate(),
      pickupEndTime: (data['pickupEndTime'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      location: data['location'],
      address: data['address'] ?? '',
      rating: data['rating']?.toDouble(),
      totalReviews: data['totalReviews'],
      allergens: List<String>.from(data['allergens'] ?? []),
      additionalInfo: data['additionalInfo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vendorId': vendorId,
      'vendorName': vendorName,
      'title': title,
      'description': description,
      'foodItems': foodItems,
      'images': images,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'quantity': quantity,
      'availableQuantity': availableQuantity,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'pickupStartTime': Timestamp.fromDate(pickupStartTime),
      'pickupEndTime': Timestamp.fromDate(pickupEndTime),
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'location': location,
      'address': address,
      'rating': rating,
      'totalReviews': totalReviews,
      'allergens': allergens,
      'additionalInfo': additionalInfo,
    };
  }

  double get discountPercentage {
    if (originalPrice == 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice * 100).roundToDouble();
  }

  bool get isAvailable => status == MagicBagStatus.available && availableQuantity > 0;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  MagicBagModel copyWith({
    String? id,
    String? vendorId,
    String? vendorName,
    String? title,
    String? description,
    List<String>? foodItems,
    List<String>? images,
    double? originalPrice,
    double? discountedPrice,
    int? quantity,
    int? availableQuantity,
    FoodCategory? category,
    MagicBagStatus? status,
    DateTime? pickupStartTime,
    DateTime? pickupEndTime,
    DateTime? createdAt,
    DateTime? expiresAt,
    GeoPoint? location,
    String? address,
    double? rating,
    int? totalReviews,
    List<String>? allergens,
    Map<String, dynamic>? additionalInfo,
  }) {
    return MagicBagModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      title: title ?? this.title,
      description: description ?? this.description,
      foodItems: foodItems ?? this.foodItems,
      images: images ?? this.images,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      quantity: quantity ?? this.quantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      category: category ?? this.category,
      status: status ?? this.status,
      pickupStartTime: pickupStartTime ?? this.pickupStartTime,
      pickupEndTime: pickupEndTime ?? this.pickupEndTime,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      location: location ?? this.location,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      allergens: allergens ?? this.allergens,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }
} 
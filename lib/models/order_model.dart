import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, confirmed, ready, pickedUp, cancelled, completed }
enum PaymentStatus { pending, paid, failed, refunded }

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String vendorId;
  final String vendorName;
  final String magicBagId;
  final String magicBagTitle;
  final int quantity;
  final double totalAmount;
  final double originalAmount;
  final double discountAmount;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final DateTime orderDate;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final DateTime? pickedUpAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String? pickupCode;
  final String? paymentIntentId;
  final String? receiptUrl;
  final Map<String, dynamic>? customerNotes;
  final Map<String, dynamic>? vendorNotes;
  final double? rating;
  final String? review;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.vendorId,
    required this.vendorName,
    required this.magicBagId,
    required this.magicBagTitle,
    required this.quantity,
    required this.totalAmount,
    required this.originalAmount,
    required this.discountAmount,
    required this.status,
    required this.paymentStatus,
    required this.orderDate,
    required this.pickupStartTime,
    required this.pickupEndTime,
    this.pickedUpAt,
    this.cancelledAt,
    this.cancellationReason,
    this.pickupCode,
    this.paymentIntentId,
    this.receiptUrl,
    this.customerNotes,
    this.vendorNotes,
    this.rating,
    this.review,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return OrderModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? '',
      vendorId: data['vendorId'] ?? '',
      vendorName: data['vendorName'] ?? '',
      magicBagId: data['magicBagId'] ?? '',
      magicBagTitle: data['magicBagTitle'] ?? '',
      quantity: data['quantity'] ?? 0,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      originalAmount: (data['originalAmount'] ?? 0).toDouble(),
      discountAmount: (data['discountAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${data['status']}',
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${data['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      pickupStartTime: (data['pickupStartTime'] as Timestamp).toDate(),
      pickupEndTime: (data['pickupEndTime'] as Timestamp).toDate(),
      pickedUpAt: data['pickedUpAt'] != null 
          ? (data['pickedUpAt'] as Timestamp).toDate() 
          : null,
      cancelledAt: data['cancelledAt'] != null 
          ? (data['cancelledAt'] as Timestamp).toDate() 
          : null,
      cancellationReason: data['cancellationReason'],
      pickupCode: data['pickupCode'],
      paymentIntentId: data['paymentIntentId'],
      receiptUrl: data['receiptUrl'],
      customerNotes: data['customerNotes'],
      vendorNotes: data['vendorNotes'],
      rating: data['rating']?.toDouble(),
      review: data['review'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'magicBagId': magicBagId,
      'magicBagTitle': magicBagTitle,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'originalAmount': originalAmount,
      'discountAmount': discountAmount,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'orderDate': Timestamp.fromDate(orderDate),
      'pickupStartTime': Timestamp.fromDate(pickupStartTime),
      'pickupEndTime': Timestamp.fromDate(pickupEndTime),
      'pickedUpAt': pickedUpAt != null ? Timestamp.fromDate(pickedUpAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'cancellationReason': cancellationReason,
      'pickupCode': pickupCode,
      'paymentIntentId': paymentIntentId,
      'receiptUrl': receiptUrl,
      'customerNotes': customerNotes,
      'vendorNotes': vendorNotes,
      'rating': rating,
      'review': review,
    };
  }

  bool get isActive => status == OrderStatus.pending || 
                      status == OrderStatus.confirmed || 
                      status == OrderStatus.ready;

  bool get canBeCancelled => status == OrderStatus.pending || 
                            status == OrderStatus.confirmed;

  bool get isCompleted => status == OrderStatus.completed;

  bool get isPaid => paymentStatus == PaymentStatus.paid;

  bool get isPickupTime => DateTime.now().isAfter(pickupStartTime) && 
                          DateTime.now().isBefore(pickupEndTime);

  bool get isExpired => DateTime.now().isAfter(pickupEndTime);

  double get discountPercentage {
    if (originalAmount == 0) return 0;
    return ((originalAmount - totalAmount) / originalAmount * 100);
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? vendorId,
    String? vendorName,
    String? magicBagId,
    String? magicBagTitle,
    int? quantity,
    double? totalAmount,
    double? originalAmount,
    double? discountAmount,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? orderDate,
    DateTime? pickupStartTime,
    DateTime? pickupEndTime,
    DateTime? pickedUpAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? pickupCode,
    String? paymentIntentId,
    String? receiptUrl,
    Map<String, dynamic>? customerNotes,
    Map<String, dynamic>? vendorNotes,
    double? rating,
    String? review,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      magicBagId: magicBagId ?? this.magicBagId,
      magicBagTitle: magicBagTitle ?? this.magicBagTitle,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      originalAmount: originalAmount ?? this.originalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderDate: orderDate ?? this.orderDate,
      pickupStartTime: pickupStartTime ?? this.pickupStartTime,
      pickupEndTime: pickupEndTime ?? this.pickupEndTime,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      pickupCode: pickupCode ?? this.pickupCode,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      customerNotes: customerNotes ?? this.customerNotes,
      vendorNotes: vendorNotes ?? this.vendorNotes,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }
} 
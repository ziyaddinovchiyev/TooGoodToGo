import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/magic_bag_model.dart';
import '../models/order_model.dart';

class FirestoreSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Seed all collections with mock data
  Future<void> seedAllCollections() async {
    try {
      print('🌱 Starting Firestore seeding...');
      
      // Seed users first (customers and vendors)
      await _seedUsers();
      
      // Seed magic bags
      await _seedMagicBags();
      
      // Seed orders
      await _seedOrders();
      
      print('✅ Firestore seeding completed successfully!');
    } catch (e) {
      print('❌ Error seeding Firestore: $e');
      rethrow;
    }
  }

  // Seed users collection
  Future<void> _seedUsers() async {
    print('👥 Seeding users collection...');
    
    final users = [
      // Customer users
      {
        'id': 'customer1',
        'email': 'john.doe@example.com',
        'name': 'John Doe',
        'phoneNumber': '+1234567890',
        'profileImageUrl': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'userType': 'customer',
        'location': const GeoPoint(40.7128, -74.0060), // New York
        'address': '123 Main St, New York, NY 10001',
        'createdAt': DateTime.now().subtract(const Duration(days: 30)),
        'lastActive': DateTime.now(),
        'isVerified': true,
        'preferences': {
          'dietaryRestrictions': ['vegetarian'],
          'favoriteCategories': ['bakery', 'restaurant'],
          'maxDistance': 10.0,
        },
        'favoriteVendors': ['vendor1', 'vendor2'],
        'orderHistory': ['order1', 'order2'],
        'totalSpent': 45.97,
      },
      {
        'id': 'customer2',
        'email': 'sarah.wilson@example.com',
        'name': 'Sarah Wilson',
        'phoneNumber': '+1234567891',
        'profileImageUrl': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'userType': 'customer',
        'location': const GeoPoint(40.7589, -73.9851), // Manhattan
        'address': '456 Park Ave, New York, NY 10022',
        'createdAt': DateTime.now().subtract(const Duration(days: 45)),
        'lastActive': DateTime.now(),
        'isVerified': true,
        'preferences': {
          'dietaryRestrictions': ['vegan', 'gluten-free'],
          'favoriteCategories': ['cafe', 'grocery'],
          'maxDistance': 5.0,
        },
        'favoriteVendors': ['vendor3'],
        'orderHistory': ['order3'],
        'totalSpent': 18.99,
      },
      
      // Vendor users
      {
        'id': 'vendor1',
        'email': 'fresh.bakery@example.com',
        'name': 'Maria Rodriguez',
        'phoneNumber': '+1234567892',
        'profileImageUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'userType': 'vendor',
        'location': const GeoPoint(40.7505, -73.9934), // Midtown
        'address': '789 5th Ave, New York, NY 10065',
        'createdAt': DateTime.now().subtract(const Duration(days: 60)),
        'lastActive': DateTime.now(),
        'isVerified': true,
        'businessName': 'Fresh Bakery',
        'businessDescription': 'Artisanal bakery specializing in French pastries and sourdough breads.',
        'businessCategory': 'bakery',
        'businessImages': [
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        ],
        'rating': 4.8,
        'totalOrders': 156,
        'isActive': true,
      },
      {
        'id': 'vendor2',
        'email': 'pizza.place@example.com',
        'name': 'Tony Rossi',
        'phoneNumber': '+1234567893',
        'profileImageUrl': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        'userType': 'vendor',
        'location': const GeoPoint(40.7614, -73.9776), // Upper East Side
        'address': '321 Lexington Ave, New York, NY 10016',
        'createdAt': DateTime.now().subtract(const Duration(days: 90)),
        'lastActive': DateTime.now(),
        'isVerified': true,
        'businessName': 'Pizza Palace',
        'businessDescription': 'Authentic Italian pizzeria with wood-fired ovens and fresh ingredients.',
        'businessCategory': 'restaurant',
        'businessImages': [
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        ],
        'rating': 4.6,
        'totalOrders': 89,
        'isActive': true,
      },
      {
        'id': 'vendor3',
        'email': 'coffee.corner@example.com',
        'name': 'Emma Chen',
        'phoneNumber': '+1234567894',
        'profileImageUrl': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        'userType': 'vendor',
        'location': const GeoPoint(40.7589, -73.9851), // Manhattan
        'address': '567 Madison Ave, New York, NY 10022',
        'createdAt': DateTime.now().subtract(const Duration(days: 75)),
        'lastActive': DateTime.now(),
        'isVerified': true,
        'businessName': 'Coffee Corner',
        'businessDescription': 'Specialty coffee shop with locally roasted beans and artisanal pastries.',
        'businessCategory': 'cafe',
        'businessImages': [
          'https://images.unsplash.com/photo-1501339847302-ac426a4a87c7?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=300&fit=crop',
        ],
        'rating': 4.9,
        'totalOrders': 234,
        'isActive': true,
      },
    ];

    for (final userData in users) {
      final user = UserModel(
        id: userData['id'] as String,
        email: userData['email'] as String,
        name: userData['name'] as String,
        phoneNumber: userData['phoneNumber'] as String?,
        profileImageUrl: userData['profileImageUrl'] as String?,
        userType: UserType.values.firstWhere(
          (e) => e.toString() == 'UserType.${userData['userType']}',
        ),
        location: userData['location'] as GeoPoint?,
        address: userData['address'] as String?,
        createdAt: userData['createdAt'] as DateTime,
        lastActive: userData['lastActive'] as DateTime,
        isVerified: userData['isVerified'] as bool,
        preferences: userData['preferences'] as Map<String, dynamic>?,
        businessName: userData['businessName'] as String?,
        businessDescription: userData['businessDescription'] as String?,
        businessCategory: userData['businessCategory'] as String?,
        businessImages: userData['businessImages'] != null 
            ? List<String>.from(userData['businessImages'] as List)
            : null,
        rating: userData['rating'] != null 
            ? (userData['rating'] as num).toDouble()
            : null,
        totalOrders: userData['totalOrders'] as int?,
        isActive: userData['isActive'] as bool?,
        favoriteVendors: userData['favoriteVendors'] != null 
            ? List<String>.from(userData['favoriteVendors'] as List)
            : null,
        orderHistory: userData['orderHistory'] != null 
            ? List<String>.from(userData['orderHistory'] as List)
            : null,
        totalSpent: userData['totalSpent'] != null 
            ? (userData['totalSpent'] as num).toDouble()
            : null,
      );

      await _firestore.collection('users').doc(user.id).set(user.toFirestore());
      print('✅ Created user: ${user.name}');
    }
  }

  // Seed magic bags collection with multi-language support
  Future<void> _seedMagicBags() async {
    print('🛍️ Seeding magic bags collection...');
    
    final magicBags = [
      {
        'id': 'magicbag1',
        'vendorId': 'vendor1',
        'vendorName': 'Fresh Bakery',
        'title': {
          'en': 'Surprise Pastry Bag',
          'ru': 'Пакет сюрприз с выпечкой',
          'az': 'Sehirli çörək paketi',
        },
        'description': {
          'en': 'A delicious mix of fresh pastries, breads, and sweet treats. Perfect for breakfast or afternoon tea.',
          'ru': 'Вкусная смесь свежей выпечки, хлеба и сладостей. Идеально для завтрака или послеобеденного чая.',
          'az': 'Təravətli çörək, şirniyyat və şirniyyatların ləzzətli qarışığı. Səhər yeməyi və ya ikindi çayı üçün mükəmməl.',
        },
        'foodItems': ['Croissants', 'Danish Pastries', 'Baguettes', 'Muffins', 'Scones'],
        'images': [
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop',
        ],
        'originalPrice': 25.0,
        'discountedPrice': 8.99,
        'quantity': 10,
        'availableQuantity': 5,
        'category': 'bakery',
        'status': 'available',
        'pickupStartTime': DateTime.now().add(const Duration(hours: 2)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 6)),
        'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
        'expiresAt': DateTime.now().add(const Duration(hours: 6)),
        'location': const GeoPoint(40.7505, -73.9934),
        'address': '789 5th Ave, New York, NY 10065',
        'rating': 4.8,
        'totalReviews': 23,
        'allergens': ['gluten', 'dairy', 'eggs'],
      },
      {
        'id': 'magicbag2',
        'vendorId': 'vendor1',
        'vendorName': 'Fresh Bakery',
        'title': {
          'en': 'Artisan Bread Collection',
          'ru': 'Коллекция ремесленного хлеба',
          'az': 'Sənətkar çörək kolleksiyası',
        },
        'description': {
          'en': 'Freshly baked artisan breads including sourdough, whole wheat, and rye varieties.',
          'ru': 'Свежеиспеченный ремесленный хлеб, включая закваску, цельнозерновой и ржаной сорта.',
          'az': 'Təravətli bişirilmiş sənətkar çörəkləri, turş xəmir, tam buğda və çovdar növləri daxil olmaqla.',
        },
        'foodItems': ['Sourdough Bread', 'Whole Wheat Bread', 'Rye Bread', 'Ciabatta'],
        'images': [
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop',
        ],
        'originalPrice': 18.0,
        'discountedPrice': 6.99,
        'quantity': 8,
        'availableQuantity': 3,
        'category': 'bakery',
        'status': 'available',
        'pickupStartTime': DateTime.now().add(const Duration(hours: 3)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 7)),
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
        'expiresAt': DateTime.now().add(const Duration(hours: 7)),
        'location': const GeoPoint(40.7505, -73.9934),
        'address': '789 5th Ave, New York, NY 10065',
        'rating': 4.9,
        'totalReviews': 15,
        'allergens': ['gluten'],
      },
      {
        'id': 'magicbag3',
        'vendorId': 'vendor2',
        'vendorName': 'Pizza Palace',
        'title': {
          'en': 'Pizza Surprise Box',
          'ru': 'Коробка сюрприз с пиццей',
          'az': 'Pizza sürpriz qutusu',
        },
        'description': {
          'en': 'A variety of our best-selling pizzas including Margherita, Pepperoni, and Vegetarian options.',
          'ru': 'Разнообразие наших самых продаваемых пицц, включая Маргариту, Пепперони и вегетарианские варианты.',
          'az': 'Margarita, Pepperoni və vegetarian seçimləri daxil olmaqla ən çox satılan pizzalarımızın müxtəlifliyi.',
        },
        'foodItems': ['Margherita Pizza', 'Pepperoni Pizza', 'Vegetarian Pizza', 'Garlic Bread'],
        'images': [
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        ],
        'originalPrice': 35.0,
        'discountedPrice': 12.99,
        'quantity': 6,
        'availableQuantity': 4,
        'category': 'restaurant',
        'status': 'available',
        'pickupStartTime': DateTime.now().add(const Duration(hours: 1)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 5)),
        'createdAt': DateTime.now().subtract(const Duration(hours: 30)),
        'expiresAt': DateTime.now().add(const Duration(hours: 5)),
        'location': const GeoPoint(40.7614, -73.9776),
        'address': '321 Lexington Ave, New York, NY 10016',
        'rating': 4.6,
        'totalReviews': 31,
        'allergens': ['gluten', 'dairy'],
      },
      {
        'id': 'magicbag4',
        'vendorId': 'vendor3',
        'vendorName': 'Coffee Corner',
        'title': {
          'en': 'Coffee & Pastry Bundle',
          'ru': 'Набор кофе и выпечки',
          'az': 'Qəhvə və şirniyyat dəsti',
        },
        'description': {
          'en': 'Freshly brewed coffee with a selection of artisanal pastries and cookies.',
          'ru': 'Свежесваренный кофе с выбором ремесленной выпечки и печенья.',
          'az': 'Sənətkar şirniyyat və peçenye seçimi ilə təravətli qəhvə.',
        },
        'foodItems': ['Espresso', 'Cappuccino', 'Croissants', 'Chocolate Chip Cookies', 'Muffins'],
        'images': [
          'https://images.unsplash.com/photo-1501339847302-ac426a4a87c7?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400&h=300&fit=crop',
        ],
        'originalPrice': 22.0,
        'discountedPrice': 9.99,
        'quantity': 12,
        'availableQuantity': 7,
        'category': 'cafe',
        'status': 'available',
        'pickupStartTime': DateTime.now().add(const Duration(hours: 4)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 8)),
        'createdAt': DateTime.now().subtract(const Duration(hours: 3)),
        'expiresAt': DateTime.now().add(const Duration(hours: 8)),
        'location': const GeoPoint(40.7589, -73.9851),
        'address': '567 Madison Ave, New York, NY 10022',
        'rating': 4.9,
        'totalReviews': 42,
        'allergens': ['gluten', 'dairy', 'nuts'],
      },
      {
        'id': 'magicbag5',
        'vendorId': 'vendor2',
        'vendorName': 'Pizza Palace',
        'title': {
          'en': 'Italian Pasta Feast',
          'ru': 'Итальянский пир с пастой',
          'az': 'İtalyan makaron ziyafəti',
        },
        'description': {
          'en': 'Authentic Italian pasta dishes with fresh sauces and premium ingredients.',
          'ru': 'Аутентичные итальянские блюда из пасты со свежими соусами и премиальными ингредиентами.',
          'az': 'Təravətli souslar və premium tərkib hissələri ilə həqiqi İtalyan makaron yeməkləri.',
        },
        'foodItems': ['Spaghetti Carbonara', 'Fettuccine Alfredo', 'Penne Arrabbiata', 'Garlic Bread'],
        'images': [
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        ],
        'originalPrice': 28.0,
        'discountedPrice': 11.99,
        'quantity': 5,
        'availableQuantity': 2,
        'category': 'restaurant',
        'status': 'available',
        'pickupStartTime': DateTime.now().add(const Duration(hours: 2)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 6)),
        'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
        'expiresAt': DateTime.now().add(const Duration(hours: 6)),
        'location': const GeoPoint(40.7614, -73.9776),
        'address': '321 Lexington Ave, New York, NY 10016',
        'rating': 4.7,
        'totalReviews': 18,
        'allergens': ['gluten', 'dairy', 'eggs'],
      },
    ];

    for (final bagData in magicBags) {
      final magicBag = MagicBagModel(
        id: bagData['id'] as String,
        vendorId: bagData['vendorId'] as String,
        vendorName: bagData['vendorName'] as String,
        title: (bagData['title'] as Map<String, dynamic>)['en'] as String, // Default to English
        description: (bagData['description'] as Map<String, dynamic>)['en'] as String, // Default to English
        foodItems: List<String>.from(bagData['foodItems'] as List),
        images: List<String>.from(bagData['images'] as List),
        originalPrice: bagData['originalPrice'] as double,
        discountedPrice: bagData['discountedPrice'] as double,
        quantity: bagData['quantity'] as int,
        availableQuantity: bagData['availableQuantity'] as int,
        category: FoodCategory.values.firstWhere(
          (e) => e.toString() == 'FoodCategory.${bagData['category']}',
        ),
        status: MagicBagStatus.values.firstWhere(
          (e) => e.toString() == 'MagicBagStatus.${bagData['status']}',
        ),
        pickupStartTime: bagData['pickupStartTime'] as DateTime,
        pickupEndTime: bagData['pickupEndTime'] as DateTime,
        createdAt: bagData['createdAt'] as DateTime,
        expiresAt: bagData['expiresAt'] as DateTime,
        location: bagData['location'] as GeoPoint,
        address: bagData['address'] as String,
        rating: bagData['rating'] != null 
            ? (bagData['rating'] as num).toDouble()
            : null,
        totalReviews: bagData['totalReviews'] as int?,
        allergens: bagData['allergens'] != null 
            ? List<String>.from(bagData['allergens'] as List)
            : null,
      );

      // Store the localized data separately
      final localizedData = {
        'title': bagData['title'] as Map<String, dynamic>,
        'description': bagData['description'] as Map<String, dynamic>,
      };

      final firestoreData = magicBag.toFirestore();
      firestoreData['localized'] = localizedData;

      await _firestore.collection('magic_bags').doc(magicBag.id).set(firestoreData);
      print('✅ Created magic bag: ${magicBag.title}');
    }
  }

  // Seed orders collection
  Future<void> _seedOrders() async {
    print('📦 Seeding orders collection...');
    
    final orders = [
      {
        'id': 'order1',
        'customerId': 'customer1',
        'customerName': 'John Doe',
        'vendorId': 'vendor1',
        'vendorName': 'Fresh Bakery',
        'magicBagId': 'magicbag1',
        'magicBagTitle': 'Surprise Pastry Bag',
        'quantity': 1,
        'totalAmount': 8.99,
        'originalAmount': 25.0,
        'discountAmount': 16.01,
        'status': 'confirmed',
        'paymentStatus': 'paid',
        'orderDate': DateTime.now().subtract(const Duration(hours: 2)),
        'pickupStartTime': DateTime.now().add(const Duration(hours: 2)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 6)),
        'pickupCode': 'ABC123',
        'paymentIntentId': 'pi_1234567890',
        'receiptUrl': 'https://example.com/receipt1.pdf',
      },
      {
        'id': 'order2',
        'customerId': 'customer1',
        'customerName': 'John Doe',
        'vendorId': 'vendor2',
        'vendorName': 'Pizza Palace',
        'magicBagId': 'magicbag3',
        'magicBagTitle': 'Pizza Surprise Box',
        'quantity': 1,
        'totalAmount': 12.99,
        'originalAmount': 35.0,
        'discountAmount': 22.01,
        'status': 'ready',
        'paymentStatus': 'paid',
        'orderDate': DateTime.now().subtract(const Duration(hours: 1)),
        'pickupStartTime': DateTime.now().add(const Duration(hours: 1)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 5)),
        'pickupCode': 'DEF456',
        'paymentIntentId': 'pi_0987654321',
        'receiptUrl': 'https://example.com/receipt2.pdf',
      },
      {
        'id': 'order3',
        'customerId': 'customer2',
        'customerName': 'Sarah Wilson',
        'vendorId': 'vendor3',
        'vendorName': 'Coffee Corner',
        'magicBagId': 'magicbag4',
        'magicBagTitle': 'Coffee & Pastry Bundle',
        'quantity': 1,
        'totalAmount': 9.99,
        'originalAmount': 22.0,
        'discountAmount': 12.01,
        'status': 'pending',
        'paymentStatus': 'paid',
        'orderDate': DateTime.now().subtract(const Duration(hours: 30)),
        'pickupStartTime': DateTime.now().add(const Duration(hours: 4)),
        'pickupEndTime': DateTime.now().add(const Duration(hours: 8)),
        'pickupCode': 'GHI789',
        'paymentIntentId': 'pi_1122334455',
        'receiptUrl': 'https://example.com/receipt3.pdf',
      },
      {
        'id': 'order4',
        'customerId': 'customer1',
        'customerName': 'John Doe',
        'vendorId': 'vendor1',
        'vendorName': 'Fresh Bakery',
        'magicBagId': 'magicbag2',
        'magicBagTitle': 'Artisan Bread Collection',
        'quantity': 1,
        'totalAmount': 6.99,
        'originalAmount': 18.0,
        'discountAmount': 11.01,
        'status': 'completed',
        'paymentStatus': 'paid',
        'orderDate': DateTime.now().subtract(const Duration(days: 1)),
        'pickupStartTime': DateTime.now().subtract(const Duration(hours: 4)),
        'pickupEndTime': DateTime.now().subtract(const Duration(hours: 2)),
        'pickedUpAt': DateTime.now().subtract(const Duration(hours: 3)),
        'pickupCode': 'JKL012',
        'paymentIntentId': 'pi_5566778899',
        'receiptUrl': 'https://example.com/receipt4.pdf',
        'rating': 5.0,
        'review': 'Amazing bread! Fresh and delicious. Will definitely order again.',
      },
    ];

    for (final orderData in orders) {
      final order = OrderModel(
        id: orderData['id'] as String,
        customerId: orderData['customerId'] as String,
        customerName: orderData['customerName'] as String,
        vendorId: orderData['vendorId'] as String,
        vendorName: orderData['vendorName'] as String,
        magicBagId: orderData['magicBagId'] as String,
        magicBagTitle: orderData['magicBagTitle'] as String,
        quantity: orderData['quantity'] as int,
        totalAmount: orderData['totalAmount'] as double,
        originalAmount: orderData['originalAmount'] as double,
        discountAmount: orderData['discountAmount'] as double,
        status: OrderStatus.values.firstWhere(
          (e) => e.toString() == 'OrderStatus.${orderData['status']}',
        ),
        paymentStatus: PaymentStatus.values.firstWhere(
          (e) => e.toString() == 'PaymentStatus.${orderData['paymentStatus']}',
        ),
        orderDate: orderData['orderDate'] as DateTime,
        pickupStartTime: orderData['pickupStartTime'] as DateTime,
        pickupEndTime: orderData['pickupEndTime'] as DateTime,
        pickedUpAt: orderData['pickedUpAt'] as DateTime?,
        pickupCode: orderData['pickupCode'] as String?,
        paymentIntentId: orderData['paymentIntentId'] as String?,
        receiptUrl: orderData['receiptUrl'] as String?,
        rating: orderData['rating'] != null 
            ? (orderData['rating'] as num).toDouble()
            : null,
        review: orderData['review'] as String?,
      );

      await _firestore.collection('orders').doc(order.id).set(order.toFirestore());
      print('✅ Created order: ${order.magicBagTitle}');
    }
  }

  // Clear all collections (for testing)
  Future<void> clearAllCollections() async {
    print('🗑️ Clearing all collections...');
    
    try {
      // Clear users
      final usersSnapshot = await _firestore.collection('users').get();
      for (final doc in usersSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Clear magic bags
      final magicBagsSnapshot = await _firestore.collection('magic_bags').get();
      for (final doc in magicBagsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Clear orders
      final ordersSnapshot = await _firestore.collection('orders').get();
      for (final doc in ordersSnapshot.docs) {
        await doc.reference.delete();
      }
      
      print('✅ All collections cleared successfully!');
    } catch (e) {
      print('❌ Error clearing collections: $e');
      rethrow;
    }
  }
} 
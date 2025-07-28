# Too Good To Go Clone

A comprehensive Flutter mobile application inspired by TooGoodToGo, designed to connect customers with local food businesses offering surplus food at discounted prices. This app helps reduce food waste while providing great deals to customers.

## 🚀 Features

### Customer Features
- **User Authentication**: Email/password, Google, and Apple sign-in
- **Magic Bag Browsing**: Browse nearby Magic Bags with beautiful cards
- **Map View**: Interactive map showing Magic Bag locations
- **Filtering & Search**: Filter by distance, food type, and pickup time
- **Order Management**: Reserve and pay for Magic Bags
- **Order History**: View past orders and receipts
- **Push Notifications**: Get reminders and deal alerts
- **Favorites**: Save favorite vendors and Magic Bags

### Vendor Features
- **Vendor Registration**: Business onboarding with verification
- **Magic Bag Creation**: Create and manage Magic Bag listings
- **Order Management**: View and manage incoming orders
- **Dashboard Analytics**: Track sales, orders, and ratings
- **Real-time Updates**: Live order status updates
- **Business Profile**: Manage business information and photos

### Shared Features
- **Location Services**: GPS-based store discovery
- **Real-time Database**: Firebase Firestore integration
- **Payment Processing**: Stripe integration for secure payments
- **Push Notifications**: Real-time updates and reminders
- **Modern UI**: Material 3 design with beautiful animations

## 🛠 Tech Stack

- **Frontend**: Flutter (cross-platform mobile)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Maps**: Google Maps SDK
- **Payments**: Stripe SDK
- **State Management**: Riverpod
- **UI**: Material 3 with Google Fonts
- **Image Handling**: Cached Network Image
- **Location**: Geolocator package

## 📱 Screenshots

### Customer Interface
- Splash Screen with app branding
- Login/Signup with social authentication
- Home screen with Magic Bag browsing
- Map view with store locations
- Magic Bag details with food items
- Order confirmation and payment
- Order history and tracking

### Vendor Interface
- Vendor dashboard with analytics
- Magic Bag creation form
- Order management interface
- Business profile management
- Sales analytics and insights

## 🏗 Project Structure

```
lib/
├── models/
│   ├── user_model.dart          # User data model
│   ├── magic_bag_model.dart     # Magic Bag data model
│   └── order_model.dart         # Order data model
├── services/
│   ├── auth_service.dart        # Authentication service
│   ├── magic_bag_service.dart   # Magic Bag operations
│   ├── order_service.dart       # Order management
│   └── payment_service.dart     # Payment processing
├── providers/
│   ├── auth_provider.dart       # Authentication state
│   ├── magic_bag_provider.dart  # Magic Bag state
│   └── order_provider.dart      # Order state
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart    # Login interface
│   │   └── signup_screen.dart   # Registration interface
│   ├── customer/
│   │   ├── customer_home_screen.dart
│   │   ├── magic_bag_details_screen.dart
│   │   ├── order_confirmation_screen.dart
│   │   └── widgets/
│   │       ├── magic_bag_card.dart
│   │       ├── map_view.dart
│   │       └── filter_bottom_sheet.dart
│   └── vendor/
│       ├── vendor_home_screen.dart
│       ├── create_magic_bag_screen.dart
│       ├── order_details_screen.dart
│       └── widgets/
│           ├── dashboard_card.dart
│           └── order_list_item.dart
├── utils/
│   ├── constants.dart           # App constants
│   ├── helpers.dart             # Helper functions
│   └── validators.dart          # Form validators
└── main.dart                    # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.2.3 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project
- Google Maps API key
- Stripe account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/too-good-to-go-clone.git
   cd too_good_to_go_clone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password, Google, Apple)
   - Enable Firestore Database
   - Enable Storage
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **Google Maps Setup**
   - Get Google Maps API key from Google Cloud Console
   - Enable Maps SDK for Android and iOS
   - Add API key to platform-specific files

5. **Stripe Setup**
   - Create Stripe account
   - Get publishable and secret keys
   - Configure webhook endpoints

6. **Platform Configuration**

   **Android (`android/app/build.gradle`)**:
   ```gradle
   android {
       compileSdkVersion 34
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 34
       }
   }
   ```

   **iOS (`ios/Runner/Info.plist`)**:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>This app needs location access to show nearby Magic Bags</string>
   <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
   <string>This app needs location access to show nearby Magic Bags</string>
   ```

7. **Environment Variables**
   Create a `.env` file in the root directory:
   ```
   STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   ```

8. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Configuration
1. Enable Authentication methods in Firebase Console
2. Set up Firestore security rules
3. Configure Storage rules for image uploads
4. Set up Firebase Cloud Functions for notifications

### Google Maps Configuration
1. Enable Maps SDK for Android and iOS
2. Add API key to `android/app/src/main/AndroidManifest.xml`
3. Add API key to `ios/Runner/AppDelegate.swift`

### Stripe Configuration
1. Set up Stripe account and get API keys
2. Configure webhook endpoints
3. Test payment flow in development

## 📊 Database Schema

### Users Collection
```javascript
{
  id: string,
  email: string,
  name: string,
  userType: 'customer' | 'vendor',
  phoneNumber: string,
  profileImageUrl: string,
  location: GeoPoint,
  address: string,
  businessName: string, // vendor only
  businessDescription: string, // vendor only
  businessCategory: string, // vendor only
  rating: number,
  totalOrders: number,
  createdAt: timestamp,
  lastActive: timestamp
}
```

### Magic Bags Collection
```javascript
{
  id: string,
  vendorId: string,
  vendorName: string,
  title: string,
  description: string,
  foodItems: string[],
  images: string[],
  originalPrice: number,
  discountedPrice: number,
  quantity: number,
  availableQuantity: number,
  category: string,
  status: 'available' | 'reserved' | 'sold' | 'expired',
  pickupStartTime: timestamp,
  pickupEndTime: timestamp,
  location: GeoPoint,
  address: string,
  rating: number,
  totalReviews: number,
  allergens: string[],
  createdAt: timestamp,
  expiresAt: timestamp
}
```

### Orders Collection
```javascript
{
  id: string,
  customerId: string,
  customerName: string,
  vendorId: string,
  vendorName: string,
  magicBagId: string,
  magicBagTitle: string,
  quantity: number,
  totalAmount: number,
  originalAmount: number,
  discountAmount: number,
  status: 'pending' | 'confirmed' | 'ready' | 'pickedUp' | 'cancelled' | 'completed',
  paymentStatus: 'pending' | 'paid' | 'failed' | 'refunded',
  orderDate: timestamp,
  pickupStartTime: timestamp,
  pickupEndTime: timestamp,
  pickupCode: string,
  paymentIntentId: string,
  receiptUrl: string,
  rating: number,
  review: string
}
```

## 🎨 UI/UX Features

- **Material 3 Design**: Modern, accessible interface
- **Dark/Light Theme**: Automatic theme switching
- **Smooth Animations**: Delightful micro-interactions
- **Responsive Layout**: Works on all screen sizes
- **Accessibility**: Screen reader support and high contrast
- **Loading States**: Beautiful shimmer effects
- **Error Handling**: User-friendly error messages

## 🔒 Security Features

- **Firebase Authentication**: Secure user authentication
- **Firestore Security Rules**: Data access control
- **Stripe Integration**: PCI-compliant payment processing
- **Input Validation**: Client and server-side validation
- **Data Encryption**: Sensitive data encryption
- **Rate Limiting**: API abuse prevention

## 🚀 Deployment

### Android
1. Generate signed APK:
   ```bash
   flutter build apk --release
   ```
2. Upload to Google Play Console

### iOS
1. Build for iOS:
   ```bash
   flutter build ios --release
   ```
2. Archive and upload to App Store Connect

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by TooGoodToGo's mission to reduce food waste
- Built with Flutter and Firebase
- Uses various open-source packages

## 📞 Support

For support, email support@toogoodtogoclone.com or create an issue in the repository.

---

**Note**: This is a demonstration project. For production use, ensure proper security measures, testing, and compliance with local regulations.

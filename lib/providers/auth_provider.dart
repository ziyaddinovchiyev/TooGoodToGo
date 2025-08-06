import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user data provider
final currentUserDataProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  
  final authService = ref.watch(authServiceProvider);
  try {
    UserModel? userData = await authService.getUserData(user.uid);
    
    // If user doesn't exist in Firestore, create a default profile
    if (userData == null) {
      print("User not found in Firestore, creating default profile...");
      userData = UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
        profileImageUrl: user.photoURL,
        userType: UserType.customer, // Default to customer
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
        isVerified: false,
      );
      
      // Save the default profile to Firestore
      try {
        await authService.saveUserData(userData);
        print("Default user profile created successfully");
      } catch (e) {
        print("Warning: Could not save default profile to Firestore: $e");
        // Continue with the default profile even if Firestore save fails
      }
    }
    
    return userData;
  } catch (e) {
    print("Error getting user data: $e");
    return null;
  }
});

// Navigation provider - determines which screen to show
final navigationProvider = Provider<NavigationState>((ref) {
  final authState = ref.watch(authStateProvider);
  final userData = ref.watch(currentUserDataProvider);
  
  if (authState.isLoading || userData.isLoading) {
    return NavigationState.loading;
  }
  
  if (authState.hasError) {
    return NavigationState.error;
  }
  
  final user = authState.value;
  if (user == null) {
    return NavigationState.login;
  }
  
  // User is authenticated, check if we have user data
  if (userData.hasError || userData.value == null) {
    // No user data or error, default to customer
    return NavigationState.customer;
  }
  
  // User data exists, check user type
  final userModel = userData.value!;
  if (userModel.userType == UserType.customer) {
    return NavigationState.customer;
  } else {
    return NavigationState.vendor;
  }
});

// User type provider
final userTypeProvider = Provider<UserType?>((ref) {
  final userData = ref.watch(currentUserDataProvider).value;
  return userData?.userType;
});

// Is customer provider
final isCustomerProvider = Provider<bool>((ref) {
  final userType = ref.watch(userTypeProvider);
  return userType == UserType.customer;
});

// Is vendor provider
final isVendorProvider = Provider<bool>((ref) {
  final userType = ref.watch(userTypeProvider);
  return userType == UserType.vendor;
});

// Navigation state enum
enum NavigationState {
  loading,
  error,
  login,
  customer,
  vendor,
} 
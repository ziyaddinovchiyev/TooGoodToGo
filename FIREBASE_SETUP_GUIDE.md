# Firebase Project Configuration Guide

This guide will walk you through setting up Firebase for your TooGoodToGo clone Flutter app.

## Prerequisites
- Google account
- Flutter project set up (already completed)
- Android Studio / Xcode (for platform-specific setup)

## Step 1: Create Firebase Project

1. **Go to Firebase Console**
   - Visit [https://console.firebase.google.com/](https://console.firebase.google.com/)
   - Sign in with your Google account

2. **Create New Project**
   - Click "Add project" or "Create a project"
   - Enter project name: `TooGoodToGoClone` (or your preferred name)
   - (Optional) Enable Google Analytics
   - Click "Create project"
   - Wait for project provisioning

## Step 2: Add Android App to Firebase

1. **Register Android App**
   - In Firebase Console, click the Android icon (🤖)
   - **Android package name**: `com.example.too_good_to_go_clone`
   - **App nickname**: `TooGoodToGo Clone`
   - **Debug signing certificate SHA-1** (optional but recommended):
     ```bash
     cd android
     ./gradlew signingReport
     ```
     Copy the SHA1 from the debug variant

2. **Download Configuration File**
   - Click "Register app"
   - Download `google-services.json`
   - Place it in: `android/app/google-services.json`

3. **Configure Android Build Files**

   **Update `android/build.gradle` (project-level):**
   ```gradle
   buildscript {
       repositories {
           google()
           mavenCentral()
       }
       dependencies {
           classpath 'com.android.tools.build:gradle:7.3.0'
           classpath 'com.google.gms:google-services:4.4.1' // Add this line
       }
   }

   allprojects {
       repositories {
           google()
           mavenCentral()
       }
   }
   ```

   **Update `android/app/build.gradle` (app-level):**
   ```gradle
   apply plugin: 'com.android.application'
   apply plugin: 'com.google.gms.google-services' // Add this line

   android {
       // ... existing configuration
   }
   ```

## Step 3: Add iOS App to Firebase

1. **Register iOS App**
   - In Firebase Console, click the iOS icon (🍎)
   - **iOS bundle ID**: `com.example.tooGoodToGoClone`
   - **App nickname**: `TooGoodToGo Clone iOS`
   - Click "Register app"

2. **Download Configuration File**
   - Download `GoogleService-Info.plist`
   - Place it in: `ios/Runner/GoogleService-Info.plist`

3. **Configure iOS Build Files**

   **Update `ios/Runner/AppDelegate.swift`:**
   ```swift
   import UIKit
   import Flutter
   import Firebase // Add this line

   @UIApplicationMain
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       FirebaseApp.configure() // Add this line
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
   }
   ```

## Step 4: Enable Firebase Services

### Authentication Setup
1. **Go to Authentication**
   - In Firebase Console, click "Authentication" → "Get started"
   - Click "Sign-in method" tab

2. **Enable Email/Password**
   - Click "Email/Password"
   - Toggle "Enable"
   - Click "Save"

3. **Enable Google Sign-in**
   - Click "Google"
   - Toggle "Enable"
   - Add support email
   - Click "Save"

### Firestore Database Setup
1. **Create Database**
   - Go to "Firestore Database" → "Create database"
   - Choose "Start in production mode"
   - Select location (choose closest to your users)
   - Click "Enable"

2. **Set Up Security Rules** (Later)
   - Go to "Rules" tab
   - Update rules for your app's security requirements

### Cloud Storage Setup
1. **Create Storage**
   - Go to "Storage" → "Get started"
   - Click "Next"
   - Choose location
   - Click "Done"

## Step 5: Update Firebase Options

1. **Get Configuration Values**
   - In Firebase Console, go to "Project settings" (gear icon)
   - Under "Your apps", select each app (Android, iOS)
   - Copy the configuration values

2. **Update `lib/firebase_options.dart`**
   Replace the placeholder values with your actual Firebase configuration:

   ```dart
   // Example configuration (replace with your actual values)
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'AIzaSyYourActualApiKeyHere',
     appId: '1:123456789:android:abcdef123456',
     messagingSenderId: '123456789',
     projectId: 'toogoodtogo-clone',
     storageBucket: 'toogoodtogo-clone.appspot.com',
   );

   static const FirebaseOptions ios = FirebaseOptions(
     apiKey: 'AIzaSyYourActualApiKeyHere',
     appId: '1:123456789:ios:abcdef123456',
     messagingSenderId: '123456789',
     projectId: 'toogoodtogo-clone',
     storageBucket: 'toogoodtogo-clone.appspot.com',
     iosClientId: '123456789-abcdef.apps.googleusercontent.com',
     iosBundleId: 'com.example.tooGoodToGoClone',
   );
   ```

## Step 6: Test Configuration

1. **Clean and Get Dependencies**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Test Authentication**
   - Try signing up with email/password
   - Try Google sign-in
   - Check Firebase Console → Authentication → Users

## Step 7: Set Up Firestore Security Rules

1. **Go to Firestore Rules**
   - In Firebase Console, go to "Firestore Database" → "Rules"

2. **Update Rules** (Basic example):
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users can read/write their own data
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Magic bags are readable by all authenticated users
       match /magicBags/{bagId} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && 
           get(/databases/$(database)/documents/users/$(request.auth.uid)).data.userType == 'vendor';
       }
       
       // Orders are readable by involved parties
       match /orders/{orderId} {
         allow read, write: if request.auth != null && 
           (resource.data.customerId == request.auth.uid || 
            resource.data.vendorId == request.auth.uid);
       }
     }
   }
   ```

## Step 8: Set Up Storage Security Rules

1. **Go to Storage Rules**
   - In Firebase Console, go to "Storage" → "Rules"

2. **Update Rules**:
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       // Users can upload their own profile images
       match /users/{userId}/{allPaths=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       // Magic bag images are readable by all authenticated users
       match /magicBags/{bagId}/{allPaths=**} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && 
           firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.userType == 'vendor';
       }
     }
   }
   ```

## Troubleshooting

### Common Issues:

1. **"google-services.json not found"**
   - Ensure `google-services.json` is in `android/app/`
   - Check file permissions

2. **"GoogleService-Info.plist not found"**
   - Ensure `GoogleService-Info.plist` is in `ios/Runner/`
   - Add to Xcode project if needed

3. **Authentication not working**
   - Check Firebase Console → Authentication → Sign-in methods
   - Verify SHA-1 fingerprint for Android
   - Check bundle ID for iOS

4. **Firestore permission denied**
   - Check security rules
   - Ensure user is authenticated
   - Verify data structure matches rules

### Verification Checklist:

- [ ] Firebase project created
- [ ] Android app registered with `google-services.json` in place
- [ ] iOS app registered with `GoogleService-Info.plist` in place
- [ ] Authentication enabled (Email/Password, Google)
- [ ] Firestore Database created
- [ ] Cloud Storage created
- [ ] `firebase_options.dart` updated with real values
- [ ] Security rules configured
- [ ] App runs without Firebase errors
- [ ] Authentication works (sign up/sign in)
- [ ] Data can be read/written to Firestore

## Next Steps

After completing this setup:

1. **Test the app thoroughly** with real authentication
2. **Set up Google Maps API** for location features
3. **Configure Stripe** for payment processing
4. **Set up push notifications** using Firebase Cloud Messaging
5. **Deploy to app stores** when ready

## Support

If you encounter issues:
1. Check Firebase Console for error messages
2. Review Flutter logs for detailed error information
3. Consult Firebase documentation for specific services
4. Check Flutter Firebase plugin documentation

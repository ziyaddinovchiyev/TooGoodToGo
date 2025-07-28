import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
    String? businessName,
    String? businessDescription,
    String? businessCategory,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        userType: userType,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
        businessName: businessName,
        businessDescription: businessDescription,
        businessCategory: businessCategory,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toFirestore());

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last active (handle permission errors gracefully)
      try {
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({'lastActive': Timestamp.now()});
      } catch (firestoreError) {
        print("Warning: Could not update lastActive in Firestore: $firestoreError");
        // Continue with sign in even if Firestore update fails
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google sign in was cancelled';

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // Create new user document
          UserModel userModel = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName ?? 'User',
            profileImageUrl: userCredential.user!.photoURL,
            userType: UserType.customer, // Default to customer
            createdAt: DateTime.now(),
            lastActive: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userModel.toFirestore());
        } else {
          // Update last active
          try {
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .update({'lastActive': Timestamp.now()});
          } catch (updateError) {
            print("Warning: Could not update lastActive in Firestore: $updateError");
          }
        }
      } catch (firestoreError) {
        print("Warning: Could not access Firestore: $firestoreError");
        // Continue with sign in even if Firestore operations fail
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }



  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user data: $e';
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    String? businessName,
    String? businessDescription,
    String? businessCategory,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
      if (businessName != null) updates['businessName'] = businessName;
      if (businessDescription != null) updates['businessDescription'] = businessDescription;
      if (businessCategory != null) updates['businessCategory'] = businessCategory;

      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).delete();
      await _auth.currentUser!.delete();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Handle authentication errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many requests. Try again later.';
        case 'operation-not-allowed':
          return 'This operation is not allowed.';
        default:
          return 'Authentication failed: ${error.message}';
      }
    }
    return 'An error occurred: $error';
  }
} 
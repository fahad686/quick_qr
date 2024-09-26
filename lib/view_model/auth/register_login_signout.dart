import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/auth_model.dart';
import '../../view/gen_qr_screen.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> _uploadProfileImage(File image, String uid) async {
    try {
      final ref = _storage.ref().child('profile_images/$uid.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    BuildContext context,
    File? imageFile,
  ) async {
    state = const AsyncValue.loading();
    try {
      // Sign up user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        String? profileImageUrl;
        if (imageFile != null) {
          profileImageUrl = await _uploadProfileImage(imageFile, user.uid);
        }

        // Create new user model
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          name: name,
          profileImageUrl: profileImageUrl ?? '',
        );

        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        // Update state
        state = AsyncValue.data(newUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GenerateQRCode()),
        );
      }
    } catch (e) {
      print("Sign-up error: $e");
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    state = const AsyncValue.loading();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        UserModel fetchedUser = UserModel.fromMap(userDoc.data()!);
        state = AsyncValue.data(fetchedUser);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GenerateQRCode()),
        );
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = const AsyncValue.data(null);
  }

  final FirebaseAuth _forget = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      state = const AsyncValue.loading();
      await _forget.sendPasswordResetEmail(email: email);
      state = const AsyncValue.data(null); // Reset success
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print(e.toString());
    }
  }
}

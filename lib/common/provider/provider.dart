import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/auth_model.dart';
import '../../view_model/auth/pic_img.dart';
import '../../view_model/auth/register_login_signout.dart';
import '../../view_model/qr_image_scan_gallery.dart';
import '../../view_model/qr_scanner.dart';
import '../../view_model/share_save_qr.dart';

// Define a provider for QRCodeNotifier
final shareSaveqr = StateNotifierProvider<QRCodeNotifier, void>((ref) {
  return QRCodeNotifier();
});

/////////////////////////////////////////////////////

final qrProvider = StateNotifierProvider<QrScanner, AsyncValue<String?>>(
  (ref) => QrScanner(),
);

final imgprovider =
    StateNotifierProvider<Imgfunction, File?>((ref) => Imgfunction());

///////////////////////
final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, File?>(
    (ref) => ImagePickerNotifier());
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier();
});

//////Single login user fetch data
final userProvider = StreamProvider<UserModel>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.error('No user is logged in');
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
    return UserModel.fromMap(doc.data()!);
  });
});

/////fetch all userss
final allusersProvider = StreamProvider<List<UserModel>>((ref) {
  return FirebaseFirestore.instance.collection('users').snapshots().map(
    (snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    },
  );
});

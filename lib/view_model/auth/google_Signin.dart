import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_qr/view/home/home_screen.dart';

class GoogleAuthState extends StateNotifier<AsyncValue<User?>> {
  GoogleAuthState() : super(AsyncValue.data(null));

  Future<void> signInWithGoogle(BuildContext context) async {
    state = AsyncValue.loading(); // Set loading state

    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the user cancels the sign-in (e.g. closes the popup)
      if (googleUser == null) {
        state = AsyncValue.data(null); // Set to null
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in canceled by user')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the credentials
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      state = AsyncValue.data(userCredential.user); // Update the state

      // Navigate to the next screen after successful login
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
            //NextScreen(user: userCredential.user!),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e, StackTrace.current); // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed: ${e.message}')),
      );
    } catch (e) {
      state =
          AsyncValue.error(e, StackTrace.current); // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }

  Future<void> signOutFromGoogle(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      state = AsyncValue.data(null); // Clear user state
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully logged out')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}

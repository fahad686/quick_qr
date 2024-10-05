import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/provider/provider.dart';

class GoogleSignInScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuthState = ref.watch(googleAuthProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Google Sign-In Screen')),
      body: googleAuthState.when(
        data: (user) {
          return Center(
            child: user == null
                ? ElevatedButton(
                    onPressed: () {
                      ref
                          .read(googleAuthProvider.notifier)
                          .signInWithGoogle(context); // Trigger sign-in
                    },
                    child: Text('Sign in with Google'),
                  )
                : NextScreen(
                    user: user!), // User is logged in, show next screen
          );
        },
        loading: () => Center(
            child: CircularProgressIndicator()), // Show loading indicator
        error: (error, stack) =>
            Center(child: Text('Error: $error')), // Handle error
      ),
    );
  }
}

// Next screen after login
class NextScreen extends StatelessWidget {
  final User user;

  const NextScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ${user.displayName}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
            SizedBox(height: 20),
            Text(user.displayName ?? 'No display name'),
            SizedBox(height: 20),
            Text(user.email ?? 'No email'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

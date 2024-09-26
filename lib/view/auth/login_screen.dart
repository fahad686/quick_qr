import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:quick_qr/view/auth/forget_screen.dart';
import 'package:quick_qr/view/auth/registration.dart';

import '../../common/provider/provider.dart';
import '../../common/widget/textfield.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    child: LottieBuilder.asset(
                      'lottie/login.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    // Regular expression to validate all email addresses
                    final emailPattern =
                        RegExp(r'^[\w\.\-]+@[a-zA-Z\d\-]+\.[a-zA-Z]{2,}$');
                    if (!emailPattern.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }

                    // Regular expression for password validation
                    final passwordPattern = RegExp(
                        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

                    if (!passwordPattern.hasMatch(value)) {
                      return 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.';
                    }

                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetScreen()));
                        },
                        child: const Text(
                          "Forget password ?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Consumer(
                  builder: (context, WidgetRef ref, child) {
                    final authState = ref.watch(authProvider);

                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(authProvider.notifier).login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              context);
                        }
                      },
                      child: authState.when(
                        data: (_) => const Text(
                          'LogIn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        error: (err, stack) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Something went wrong!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                          return const Text(
                            'LogIn',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 42, 28, 246),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()));
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 42, 28, 246),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

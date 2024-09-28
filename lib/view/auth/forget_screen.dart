import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../common/provider/provider.dart';
import '../../common/widget/textfield.dart';

class ForgetScreen extends ConsumerWidget {
  ForgetScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgetPasswordState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(),
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
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: LottieBuilder.asset(
                      'lottie/forget.json',
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
                    final emailPattern =
                        RegExp(r'^[\w\.\-]+@[a-zA-Z\d\-]+\.[a-zA-Z]{2,}$');
                    if (!emailPattern.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                forgetPasswordState.when(
                    data: (_) => ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(authProvider.notifier)
                                  .resetPassword(_emailController.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 42, 28, 246),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Something went wrong!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                      return const SizedBox();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

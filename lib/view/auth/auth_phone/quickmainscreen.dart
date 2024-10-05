import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_qr/view/auth/auth_email/login_screen.dart';
import 'package:quick_qr/view/auth/auth_phone/add_num_screen.dart';
import '../../../common/provider/provider.dart';
import '../../../common/widget/cliper.dart';

class QuickMainScreen extends StatefulWidget {
  const QuickMainScreen({Key? key}) : super(key: key);

  @override
  State<QuickMainScreen> createState() => _QuickMainScreenState();
}

class _QuickMainScreenState extends State<QuickMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Center(child: Text("Test")),
          ),
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              height: 530,
              width: 800,
              color: Color.fromARGB(255, 20, 122, 223),
              child: Center(child: Text("Test")),
            ),
          ),
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                color: Colors.white,
                height: 400,
                width: 360,
                child: Image.asset("images/ic_launcher.gif"),
              ),
            ),
          ),
          Positioned(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 315,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogInScreen()));
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 100,
                              child:
                                  Image.asset("images/ic_launcher-remove.png"),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Register with Quick",
                            style: TextStyle(
                              color: Color.fromARGB(255, 20, 122, 223),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text('Are You LogIn with Accounts '),
                  SizedBox(
                    height: 30,
                  ),
                  Consumer(
                    builder: (context, WidgetRef ref, child) {
                      final googleAuthState = ref.watch(googleAuthProvider);

                      return googleAuthState.when(
                        data: (user) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                ref
                                    .read(googleAuthProvider.notifier)
                                    .signInWithGoogle(context);
                              },
                              child: Container(
                                height: 50,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Color.fromARGB(255, 20, 122, 223),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 30,
                                        width: 100,
                                        child: Image.asset("images/google.png"),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Register with Google",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        loading: () => Center(
                            child:
                                CircularProgressIndicator()), // Show loading spinner
                        error: (error, stack) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(googleAuthProvider.notifier)
                                      .signInWithGoogle(context);
                                },
                                child: Text('Try Again somthing wrong'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneNumScreen()));
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: const Color.fromARGB(255, 223, 158, 158),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 100,
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Register with Phone",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../common/widget/cliper.dart';
import 'otp_verify_screen.dart';

class PhoneNumScreen extends StatefulWidget {
  const PhoneNumScreen({super.key});

  @override
  State<PhoneNumScreen> createState() => _PhoneNumScreenState();
}

class _PhoneNumScreenState extends State<PhoneNumScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'PK';
  PhoneNumber number = PhoneNumber(
    isoCode: 'PK',
  );
  String? userPhoneNumber;
  bool isValidPhoneNumber = false;

  ///////////////////////////////////////////
  PhoneAuth({
    required String phoneNumber,
  }) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (Context) => PinCodeVerificationScreen(
                      VerificationID: verificationId,
                    )));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 159, 189, 255),
      ),
      body: Form(
        key: formKey,
        child: SizedBox(
          height: 900,
          width: 900,
          child: Stack(
            children: [
              Positioned(
                top: 200,
                child: Container(
                  height: 600,
                  width: 360,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 159, 189, 255),
                                offset: const Offset(1, -2),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                color: const Color.fromARGB(255, 159, 189, 255),
                                offset: const Offset(-1, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              userPhoneNumber = number.phoneNumber;
                              print(userPhoneNumber);
                            },
                            onInputValidated: (bool value) {
                              setState(() {
                                isValidPhoneNumber = value;
                              });
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            initialValue: number,
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 17),
                            textFieldController: controller,
                            inputDecoration: const InputDecoration(
                              hintText: 'Enter phone number',
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              border: InputBorder.none,
                            ),
                            formatInput: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 159, 189, 255),
                                offset: const Offset(1, -2),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                color: const Color.fromARGB(255, 159, 189, 255),
                                offset: const Offset(-1, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: ButtonTheme(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                if (isValidPhoneNumber) {
                                  PhoneAuth(
                                      phoneNumber: userPhoneNumber.toString());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PinCodeVerificationScreen(
                                        phoneNumber: userPhoneNumber!,
                                        VerificationID: '123456',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a valid phone number.'),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Text(
                                  "SEND".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: ClipPath(
                  clipper: TopWaveClipper(),
                  child: Container(
                    color: const Color.fromARGB(255, 159, 189, 255),
                    height: 300,
                    child: Image.asset(
                      'images/scene (3).png',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

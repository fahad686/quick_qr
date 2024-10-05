// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lottie/lottie.dart';
// import '../../common/provider/provider.dart';
// import '../../common/widget/textfield.dart';

// class Ph_RegistrationScreen extends StatelessWidget {
//   Ph_RegistrationScreen({super.key});
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(22.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 40),
//                 Consumer(builder: (context, WidgetRef ref, child) {
//                   final imageFile = ref.watch(imagePickerProvider);
//                   return Center(
//                     child: SizedBox(
//                       height: 150,
//                       width: 200,
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             top: 30,
//                             left: 50,
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 CircleAvatar(
//                                   radius: 55,
//                                   backgroundColor: Colors.grey.shade200, //
//                                   child: ClipOval(
//                                     child: Container(
//                                       width: 120,
//                                       height: 120,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black26,
//                                             blurRadius: 10,
//                                             offset: Offset(
//                                                 0, 5), // Soft shadow for depth
//                                           ),
//                                         ],
//                                       ),
//                                       child: imageFile != null
//                                           ? Image.file(
//                                               imageFile,
//                                               fit: BoxFit.cover,
//                                             )
//                                           : LottieBuilder.asset(
//                                               'lottie/profile_animation.json',
//                                               fit: BoxFit.cover,
//                                             ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: 118,
//                             left: 145,
//                             child: GestureDetector(
//                               onTap: () {
//                                 _showImagePickerOptions(context, ref);
//                               },
//                               child: Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.add_a_photo_outlined,
//                                     size: 16,
//                                     color: Color.fromARGB(255, 68, 71, 249),
//                                   )),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 40),
//                 CustomTextField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _nameController,
//                   labelText: "Name",
//                   hintText: 'Enter your Name',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Required Name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _emailController,
//                   labelText: 'Email',
//                   hintText: 'Enter your Email',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Email is required';
//                     }
//                     //Regular expression to validate all email addresses
//                     final emailPattern =
//                         RegExp(r'^[\w\.\-]+@[a-zA-Z\d\-]+\.[a-zA-Z]{2,}$');
//                     if (!emailPattern.hasMatch(value)) {
//                       return 'Please enter a valid email address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   keyboardType: TextInputType.text,
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   hintText: 'Enter Password',
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Password is required';
//                     }

//                     // Regular expression for password validation
//                     final passwordPattern = RegExp(
//                         r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

//                     if (!passwordPattern.hasMatch(value)) {
//                       return 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.';
//                     }

//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 40),
//                 Consumer(
//                   builder: (context, WidgetRef ref, child) {
//                     final authState = ref.watch(authProvider);

//                     return ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           final imageFile = ref.read(imagePickerProvider);
//                           ref.read(authProvider.notifier).signUp(
//                                 _emailController.text.trim(),
//                                 _passwordController.text.trim(),
//                                 _nameController.text.trim(),
//                                 context,
//                                 imageFile,
//                               );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 42, 28, 246),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 12),
//                       ),
//                       child: authState.when(
//                         data: (_) => const Text(
//                           'Register',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         error: (err, stack) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Sign-up failed. Please try again.',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           });
//                           return const Text(
//                             'Sign Up',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                         loading: () => const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showImagePickerOptions(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text(
//                   'Choose an option',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 trailing: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Icon(Icons.cancel, color: Colors.red)),
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Colors.blue),
//                 title:
//                     const Text('Take a photo', style: TextStyle(fontSize: 16)),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   ref.read(imagePickerProvider.notifier).pickImageFromCamera();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Colors.green),
//                 title: const Text('Choose from gallery',
//                     style: TextStyle(fontSize: 16)),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   ref.read(imagePickerProvider.notifier).pickImageFromGallery();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

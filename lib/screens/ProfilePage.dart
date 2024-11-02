// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   String? errorMessage;
//   String? profileImageUrl;
//   File? selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user != null) {
//       emailController.text = user.email!;
//     }
//   }

//   Future<void> updateUserProfile() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user != null) {
//       final response = await Supabase.instance.client.auth.updateUser(
//         UserAttributes(
//           email: emailController.text,
//         ),
//       );

//       if (response.error == null) {
//         if (selectedImage != null) {
//           final filePath =
//               'profile_images/${user.id}/${selectedImage!.path.split('/').last}';
//           final uploadResponse = await Supabase.instance.client.storage
//               .from('profiles')
//               .upload(filePath, selectedImage!);

//           if (uploadResponse.error == null) {
//             profileImageUrl = Supabase.instance.client.storage
//                 .from('profiles')
//                 .getPublicUrl(filePath);
//           } else {
//             setState(() {
//               errorMessage = uploadResponse.error!.message;
//             });
//           }
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully!')),
//         );
//       } else {
//         // عرض رسالة خطأ
//         setState(() {
//           errorMessage = response.error!.message;
//         });
//       }
//     }
//   }

//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xffB81736),
//                 Color(0xff2B1836),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: GestureDetector(
//                 onTap: pickImage,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: selectedImage != null
//                       ? FileImage(selectedImage!)
//                       : profileImageUrl != null
//                           ? NetworkImage(profileImageUrl!)
//                           : const AssetImage('assets/default_profile.png')
//                               as ImageProvider,
//                   child: selectedImage == null && profileImageUrl == null
//                       ? const Icon(Icons.camera_alt,
//                           size: 50, color: Colors.white)
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//               enabled: false, // جعل البريد الإلكتروني غير قابل للتعديل
//             ),
//             const SizedBox(height: 20),
//             if (errorMessage != null) ...[
//               Text(
//                 errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               ),
//               const SizedBox(height: 10),
//             ],
//             ElevatedButton(
//               onPressed: updateUserProfile,
//               child: const Text('Update Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

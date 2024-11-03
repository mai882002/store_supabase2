import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadUserProfile(); // تحميل ملف تعريف المستخدم عند فتح الصفحة
  }

  Future<void> loadUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        setState(() {
          nameController.text = data['name'] ?? '';
          phoneController.text = data['phone'] ?? '';
          emailController.text = data['email'] ?? '';
        });

        // تحميل صورة الملف الشخصي إذا كانت موجودة
        if (data['avatar_url'] != null) {
          final avatarUrl = data['avatar_url'];
          try {
            final response = await http.get(Uri.parse(avatarUrl));
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/avatar.png';
            final file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);

            setState(() {
              _imageFile = file;
            });
          } catch (e) {
            print('Failed to load avatar: $e');
          }
        }
      } catch (e) {
        print('Failed to load user data: $e');
      }
    } else {
      print('No user');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // رفع الصورة إلى Supabase
      await Supabase.instance.client.storage.from("avatars").upload(
          '${Supabase.instance.client.auth.currentUser!.id}/avatar.png',
          _imageFile!);
    }
  }

  Future<void> updateProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response =
            await Supabase.instance.client.from('profiles').update({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
        }).eq('id', user.id);

        if (response.error == null) {
          print("Profile updated successfully.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        } else {
          setState(() {
            errorMessage =
                'Failed to update profile: ${response.error!.message}';
          });
          print("Failed to update profile: ${response.error!.message}");
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Error updating profile: $e';
        });
        print("Error updating profile: $e");
      }
    } else {
      setState(() {
        errorMessage = "No user is currently logged in.";
      });
      print("No user is currently logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffB81736),
              Color(0xff2B1836),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // فراغ أعلى الصفحة
              const Text(
                'Your Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                    child: _imageFile == null
                        ? const Icon(Icons.camera_alt,
                            size: 50, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // الجزي الأبيض الذي يحتوي على الاسم ورقم الهاتف والبريد الإلكتروني
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (errorMessage != null) ...[
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                    ],
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

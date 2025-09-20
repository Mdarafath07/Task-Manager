import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../widgets/photo_picker_field.dart';
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEContreoller = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController =
  TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker =ImagePicker();
  XFile? _selectedImagel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromUpdateProfile: true,
      ),

      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _fromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  const SizedBox(height: 24,),
                  Text("Update Profile",style: TextTheme.of(context).titleLarge,),
                  const SizedBox(height: 24,),
                  PhotoPickerField(
                    onTap: _pickImage,
                    selectedPhoto: _selectedImagel,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: "First Name"),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: "Last Name"),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileNumberTEController,
                    decoration: InputDecoration(hintText: "Mobile Number"),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEContreoller,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                  const SizedBox(height: 35),
        
                ],
        
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _pickImage() async{
    XFile? pickImage= await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickImage != null){
      _selectedImagel =pickImage;
      setState(() {

      });
    }
  }
  void dispose() {
    _emailTEController.dispose();
    _passwordTEContreoller.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileNumberTEController.dispose();
    super.dispose();
  }
}



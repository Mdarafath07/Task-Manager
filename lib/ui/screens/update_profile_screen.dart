import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/utils/urls.dart';
import '../widgets/photo_picker_field.dart';
import '../widgets/snack_ber_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = "/update-profile";

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
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImagel;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserModel user = AuthController.userModel!;
    _emailTEController.text = user.email;
    _firstNameTEController.text = user.firstName;
    _lastNameTEController.text = user.lastName;
    _mobileNumberTEController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromUpdateProfile: true),

      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _fromKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "Update Profile",
                    style: TextTheme.of(context).titleLarge,
                  ),
                  const SizedBox(height: 24),
                  PhotoPickerField(
                    onTap: _pickImage,
                    selectedPhoto: _selectedImagel,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: "First Name"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "First Name is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: "Last Name"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Last Name is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    enabled: false,
                    decoration: InputDecoration(hintText: "Email"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Email is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileNumberTEController,
                    decoration: InputDecoration(hintText: "Mobile Number"),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Mobile Number is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEContreoller,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password (Optional)",
                    ),
                    validator: (String? value) {
                      if ((value != null && value.isNotEmpty) &&
                          value.length < 6) {
                        return "Enter a password more then 6 letters";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: CenteredProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapUpdateButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
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

  void _onTapUpdateButton() {
    if (_fromKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text,
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileNumberTEController.text.trim(),
    };
    if (_passwordTEContreoller.text.isNotEmpty) {
      requestBody["password"] = _passwordTEContreoller.text;
    }
    String? encodedPhoto;

    if (_selectedImagel != null) {
     List<int> bytes = await _selectedImagel!.readAsBytes();
     encodedPhoto = jsonEncode(bytes);

      requestBody["photo"] = encodedPhoto;
    }
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    _updateProfileInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _passwordTEContreoller.clear();
      UserModel model = UserModel(
        id: AuthController.userModel!.id,
        email: _emailTEController.text,
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileNumberTEController.text.trim(),
        photo: encodedPhoto ?? AuthController.userModel!.id,
      );
      await AuthController.updateUserData(model);
      showSnackBarMessage(context, "Profile Updated Successfully");
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  Future<void> _pickImage() async {
    XFile? pickImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickImage != null) {
      _selectedImagel = pickImage;
      setState(() {});
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

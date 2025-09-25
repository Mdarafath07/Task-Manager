import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

import '../../data/utils/urls.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_ber_message.dart';

class SingupScreen extends StatefulWidget {
  const SingupScreen({super.key});

  static const String name = "/Sing-up";

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEContreoller = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileNumberTEController =
  TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  bool _singUpInprogress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(

              key: _fromKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 85),
                  Text(
                    "Join With Us",
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: "First Name"),
                    validator: (String? value) {
                      if (value
                          ?.trim()
                          .isEmpty ?? false) {
                        return "Enter a valid first name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: "Last Name"),
                    validator: (String? value) {
                      if (value
                          ?.trim()
                          .isEmpty ?? false) {
                        return "Enter a valid last name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: "Email"),
                    validator: (String? value) {
                      String inputText = value ?? "";
                      if (EmailValidator.validate(inputText) == false) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _mobileNumberTEController,
                    decoration: InputDecoration(hintText: "Mobile Number"),
                    validator: (String? value) {
                      if (value
                          ?.trim()
                          .isEmpty ?? false) {
                        return "Enter your valid mobile number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEContreoller,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                    validator: (String? value) {
                      if ((value?.length ?? 0) <= 6) {
                        return "Enter a password more than 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: _singUpInprogress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: FilledButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            text: "Already have an account?",
                            children: [
                              TextSpan(
                                text: " Login",
                                style: TextStyle(color: Colors.green),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapLoginButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_fromKey.currentState!.validate()) {
      _singup();

    }
  }

  void _onTapLoginButton() {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => LoginScreen())
    );
  }


  Future<void> _singup() async {
    _singUpInprogress = true;
    setState(() {

    });
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileNumberTEController.text.trim(),
      "password": _passwordTEContreoller.text,
    };
    final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.registrationUrl,
      body: requestBody
    );
    _singUpInprogress =false;
    setState(() {

    });
    if(response.isSuccess){
      _clearTextFields();
      showSnackBarMessage(context, "Registration Success!");

    }else{
      showSnackBarMessage(context, response.errorMessage!);

    }

  }
  void _clearTextFields() {
    _emailTEController.clear();
    _passwordTEContreoller.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileNumberTEController.clear();
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

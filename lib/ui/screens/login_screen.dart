import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager/ui/screens/singup_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_ber_message.dart';

import 'forget_password_verify_email_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String name = "/Login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEContreoller = TextEditingController();
  final TextEditingController _passwordTEContreoller = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  bool _loginInProgress = false;

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
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEContreoller,
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
                    controller: _passwordTEContreoller,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                    validator: (String? value) {
                      if ((value?.length ?? 0) <= 6) {
                        return "Password should more than 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: _loginInProgress == false,
                    replacement: CenteredProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapLoginButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgetPasswordButton,
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            text: "Don't have an account?",
                            children: [
                              TextSpan(
                                text: " Sing up",
                                style: TextStyle(color: Colors.purple),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSingupButton,
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

  void _onTapSingupButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SingupScreen()),
    );
  }

  void _onTapForgetPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgetPasswordVerifyEmailScreen(),
      ),
    );
  }

  void _onTapLoginButton() {
    if (_fromKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    _loginInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEContreoller.text,
      "password": _passwordTEContreoller.text,
    };
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );
    if (response.isSuccess && response.responseData["status"] == "success") {
      UserModel model = UserModel.fromJson(response.responseData["data"]);
      String accessToken = response.responseData["token"];
      await AuthController.saveUserData(model, accessToken);
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainNavBarHolderScreen.name,
        (protected) => false,
      );
    } else {
      _loginInProgress = false;
      setState(() {});
      final message = response.responseData["data"];
      showSnackBarMessage(context, message ?? response.errorMessage!);
    }
  }

  void dispose() {
    _emailTEContreoller.dispose();
    _passwordTEContreoller.dispose();
    super.dispose();
  }
}

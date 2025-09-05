import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/singup_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ForgetPasswordVerifyOTPScreen extends StatefulWidget {
  const ForgetPasswordVerifyOTPScreen({super.key});

  @override
  State<ForgetPasswordVerifyOTPScreen> createState() => _ForgetPasswordVerifyOTPScreenState();
}

class _ForgetPasswordVerifyOTPScreenState extends State<ForgetPasswordVerifyOTPScreen> {
  final TextEditingController _otpTEContreoller = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _fromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 85),
                  Text(
                    "Enter Your OTP",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "A  6 digit OTP has been sent to your email address",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    controller: _otpTEContreoller,
                     appContext: context,
                  ),

                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_circle_right_outlined),
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

  void _onTapLoginButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
        (protected) => false,
    );
  }


  void dispose() {
    _otpTEContreoller.dispose();
    super.dispose();
  }
}

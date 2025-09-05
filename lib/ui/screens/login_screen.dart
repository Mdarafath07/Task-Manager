
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEConreoller = TextEditingController();
  final TextEditingController _passwordTEConreoller = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _fromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 85,
                ),
                Text("Get Started With",
                  style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24,),
                TextFormField(
                  controller: _emailTEConreoller,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: _passwordTEConreoller,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
                const SizedBox(height: 8,),
                FilledButton(
                    onPressed: (){}, child: Icon(Icons.arrow_circle_right_outlined)),
                const SizedBox(height: 35,),
                Center(
                  child: Column(
                    children: [
                      TextButton(onPressed: (){}, child: Text("Forget Password?",style: TextStyle(
                        color: Colors.grey
                      ),)),
                      RichText(text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        text: "Don't have an account?",
                        children: [
                          TextSpan(
                            text: " Sing up",style: TextStyle(
                            color: Colors.green,

                          ),
                              recognizer: TapGestureRecognizer()..onTap = (){

                              },
                          ),

                        ]
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
  void dispose(){
    _emailTEConreoller.dispose();
    _passwordTEConreoller.dispose();
    super.dispose();
  }
}

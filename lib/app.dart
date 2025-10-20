import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager/ui/screens/completed_task_screen.dart';
import 'package:task_manager/ui/screens/forget_password_verify_email_screen.dart';
import 'package:task_manager/ui/screens/forget_password_verify_otp_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/main_nav_bar_holder_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/singup_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigator,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.purple,
            fixedSize: Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name: (_) => SplashScreen(),
        LoginScreen.name: (_) => LoginScreen(),
        SingupScreen.name: (_) => SingupScreen(),
        MainNavBarHolderScreen.name: (_) => MainNavBarHolderScreen(),
        UpdateProfileScreen.name: (_) => UpdateProfileScreen(),
        ForgetPasswordVerifyEmailScreen.name: (_) =>
            ForgetPasswordVerifyEmailScreen(),
        ForgetPasswordVerifyOTPScreen.name: (_) =>
            ForgetPasswordVerifyOTPScreen(),
        AddNewTaskScreen.name: (_) => AddNewTaskScreen(),
        NewTaskScreen.name: (_) => NewTaskScreen(),
        ProgressTaskScreen.name: (_) => ProgressTaskScreen(),
        CancelledTaskScreen.name: (_) => CancelledTaskScreen(),
        CompletedTaskScreen.name: (_) => CompletedTaskScreen(),
        ResetPasswordScreen.name: (_) => ResetPasswordScreen(),
      },
    );
  }
}

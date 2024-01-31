import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/screens/login_screen.dart';
import 'package:foodpanda_seller/authentication/screens/register_screen.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';

class AuthenticationScreen extends StatefulWidget {
  static const String routeName = '/authentication-screen';

  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff041C32),
      appBar: AppBar(
        backgroundColor: Color(0xff041C32),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Center(
                child: Text(
                  'DS Finance',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            CustomTextButton(
              text: 'تسجيل حساب جديد',
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.routeName);
              },
              isDisabled: false,
            ),
            CustomTextButton(
              text: 'تسجيل الدخول',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              isDisabled: false,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}

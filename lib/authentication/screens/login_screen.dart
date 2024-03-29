import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/screens/send_verification_email_screen.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/home/screens/home_screen.dart';
import 'package:foodpanda_seller/providers/authentication_provider.dart';
import 'package:foodpanda_seller/providers/internet_provider.dart';
import 'package:foodpanda_seller/widgets/custom_textfield.dart';
import 'package:foodpanda_seller/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isFocus = false;
  bool isObscure = false;
  String emailText = '';
  String passwordText = '';
  String errorText = '';
  String errorEmailText = '';

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : '';
  }

  String? validPassword(String? value) {
    return value!.length < 6
        ? 'Password has to be at least 6 characters long'
        : '';
  }

  handleLogin() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    setState(() {
      errorEmailText = validateEmail(emailController.text.trim().toString())!;
      errorText = validPassword(passwordController.text.toString())!;
    });

    if (errorText.isEmpty && errorEmailText.isEmpty) {
      await internetProvider.checkInternetConnection();
      if (internetProvider.hasInternet == false) {
        Navigator.pop(context);
        openSnackbar(context, 'Check your internet connection', scheme.primary);
      } else {
        await authenticationProvider
            .signInWithEmailAndPassword(
          emailController.text.trim().toString(),
          passwordController.text.toString(),
        )
            .then((value) async {
          if (authenticationProvider.hasError) {
            openSnackbar(
              context,
              authenticationProvider.errorCode,
              scheme.primary,
            );
            authenticationProvider.resetError();
          } else {
            await authenticationProvider
                .getUserDataFromFirestore(authenticationProvider.uid);
            await authenticationProvider.saveDataToSharedPreferences();
            await authenticationProvider.setSignIn();
            if (authenticationProvider.emailVerified) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
              Navigator.pushNamed(
                  context, SendVerificationEmailScreen.routeName);
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff041C32),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff041C32),
        actions: [
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20),
                      child: Image.asset(
                        'assets/images/login_icon.png',
                        width: 60,
                      ),
                    ),
                    const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    CustomTextField(
                      controller: emailController,
                      labelText: 'البريد الالكتروني',
                      onChanged: (value) {
                        setState(() {
                          emailText = value;
                        });
                      },
                      errorText: errorEmailText,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      labelText: 'كلمه المرور',
                      noIcon: false,
                      onChanged: (value) {
                        setState(() {
                          passwordText = value;
                        });
                      },
                      errorText: errorText,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push (
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()
                          ),
                        );
                      },
                      child: Text(
                        'نسيت كلمه المرور؟',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Continue',
              onPressed: handleLogin,
              isDisabled: passwordText.isEmpty || emailText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}

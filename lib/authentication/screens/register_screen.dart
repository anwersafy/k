import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:foodpanda_seller/authentication/screens/send_verification_email_screen.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/home/screens/home_screen.dart';
import 'package:foodpanda_seller/providers/authentication_provider.dart';
import 'package:foodpanda_seller/providers/internet_provider.dart';
import 'package:foodpanda_seller/widgets/custom_textfield.dart';
import 'package:foodpanda_seller/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register-screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool isFocus = false;
  bool isObscure = false;
  String firstNameText = '';
  String lastNameText = '';
  String emailText = '';
  String passwordText = '';
  String errorText = '';
  String errorEmailText = '';
  bool isError = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
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

  String? validPassword() {
    return isError ? 'Please complete the requirement.' : '';
  }

  handleRegister() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    setState(() {
      errorEmailText = validateEmail(emailController.text.trim().toString())!;
      errorText = validPassword()!;
    });
    if (errorText.isEmpty && errorEmailText.isEmpty) {
      await internetProvider.checkInternetConnection();
      if (internetProvider.hasInternet == false) {
        Navigator.pop(context);
        openSnackbar(context, 'Check your internet connection', scheme.primary);
      } else {
        await authenticationProvider
            .registerWithEmail(
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
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
            // save to firestore
            await authenticationProvider.saveUserDataToFirestore();
            await authenticationProvider.saveDataToSharedPreferences();
            await authenticationProvider.setSignIn();

            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.routeName, (route) => false);
            Navigator.pushNamed(context, SendVerificationEmailScreen.routeName);
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
        backgroundColor:Color(0xff041C32),

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
                    const Text(
                      'انشاء حساب جديد',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(right: 7),
                          child: CustomTextField(
                            controller: firstNameController,
                            labelText: 'الاسم الاول',
                            onChanged: (value) {
                              setState(() {
                                firstNameText = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(left: 7),
                          child: CustomTextField(
                            controller: lastNameController,
                            labelText: 'الاسم الاخير',
                            onChanged: (value) {
                              setState(() {
                                lastNameText = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    // FlutterPwValidator(
                    //   controller: passwordController,
                    //   minLength: 6,
                    //   uppercaseCharCount: 1,
                    //   lowercaseCharCount: 1,
                    //   numericCharCount: 1,
                    //   specialCharCount: 1,
                    //   width: 400,
                    //   defaultColor: Colors.grey[400]!,
                    //   failureColor: Colors.red,
                    //   height: 150,
                    //   onSuccess: () {
                    //     setState(() {
                    //       isError = false;
                    //     });
                    //   },
                    //   onFail: () {
                    //     setState(() {
                    //       isError = true;
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'انشاء الحساب ',
              onPressed: handleRegister,
              isDisabled: firstNameText.isEmpty ||
                  lastNameText.isEmpty ||
                  passwordText.isEmpty ||
                  emailText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}

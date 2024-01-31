import 'dart:async';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/home/screens/home_screen.dart';
import 'package:foodpanda_seller/providers/authentication_provider.dart';
import 'package:foodpanda_seller/providers/internet_provider.dart';
import 'package:foodpanda_seller/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class SendVerificationEmailScreen extends StatefulWidget {
  static const String routeName = '/send_verification_email_screen';
  const SendVerificationEmailScreen({super.key});

  @override
  State<SendVerificationEmailScreen> createState() =>
      _SendVerificationEmailScreenState();
}

class _SendVerificationEmailScreenState
    extends State<SendVerificationEmailScreen> {
  bool alreadySent = false;
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendEmailVerification() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      setState(() {
        alreadySent = true;
      });

      await authenticationProvider.sendEmailVerification();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future resendEmail() async {
    final authenticationProvider = context.read<AuthenticationProvider>();

    await authenticationProvider.sendEmailVerification();
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      final authenticationProvider = context.read<AuthenticationProvider>();

      // save to firestore
      await authenticationProvider
          .saveEmailVerified(FirebaseAuth.instance.currentUser?.uid);
      await authenticationProvider.saveDataToSharedPreferences();
      // save to share preference

      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.routeName,
        (route) => false,
      );

      timer?.cancel();
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !alreadySent
                        ? 'سنرسل رابط التحقق الى بريدك الالكتروني'
                        : 'تحقق من بريدك الالكتروني',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    !alreadySent
                        ? 'يرجى الضغط على الرابط المرسل لتأكيد البريد الالكتروني'
                        : 'تم ارسال رابط التحقق الى بريدك الالكتروني',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            alreadySent
                ? CustomTextButton(
                    text: 'فتح بريد Gmail',
                    onPressed: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.google.android.gm',
                        // iosUrlScheme: 'pulsesecure://',
                        // appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                        // openStore: false
                      );
                    },
                    isDisabled: false,
                  )
                : const SizedBox(),
            CustomTextButton(
              text: !alreadySent
                  ? 'Send verification email'
                  : 'Resend verification link',
              onPressed: !alreadySent ? sendEmailVerification : resendEmail,
              isDisabled: false,
              isOutlined: alreadySent,
            ),
          ],
        ),
      ),
    );
  }
}

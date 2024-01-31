import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/home/screens/home_screen.dart';
import 'package:foodpanda_seller/home/screens/home_screen_no_approve.dart';
import 'package:foodpanda_seller/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final ap = context.read<AuthenticationProvider>();

    super.initState();

    Timer(const Duration(seconds: 2), () async {
      if (!ap.isSignedIn) {
        Navigator.pushReplacementNamed(context, AuthenticationScreen.routeName);
      } else {
        await ap
            .getUserDataFromFirestore(FirebaseAuth.instance.currentUser!.uid);

        if (ap.isApproved) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(
              context, HomeScreenNoApprove.routeName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff041C32),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 300,
            child: Text('DS Finance',
                style: TextStyle(
                  letterSpacing: 1.5,

                    color: Color(0xffFFF8E3),
                    fontSize: 30,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.bold)),
          ),


          const Positioned(
            bottom: 50,
            child: CupertinoActivityIndicator(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}

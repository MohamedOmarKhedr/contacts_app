import 'dart:async';

import 'package:easy_contacts/core/constants.dart' as screens;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 400), () => Navigator.pushNamedAndRemoveUntil(context, screens.homeLayout, (route) => false) );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

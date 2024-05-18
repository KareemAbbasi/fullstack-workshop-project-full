import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

void goBackToHomeScreen(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}

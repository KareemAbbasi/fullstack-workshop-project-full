import 'package:flutter/material.dart';
// import 'package:flutter_application_1/screens/add_post_screen.dart';
// import 'package:flutter_application_1/screens/auth_screen.dart';

import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Firebasing");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Fun Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      // home: const AddPostScreen(),
      // home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/mock_data.dart';
import 'package:flutter_application_1/screens/add_post_screen.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';

import '../firebase/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: isUserSignedIn()
            ? Text('Welcome, ${FirebaseAuth.instance.currentUser?.displayName}')
            : Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: isUserSignedIn()
                ? () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AddPostScreen()),
                      )
                    }
                : null,
            icon: Icon(
              Icons.add,
            ),
          ),
          IconButton(
            onPressed: () => {
              isUserSignedIn()
                  ? logout()
                  : Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
                    )
            },
            icon: Icon(
              isUserSignedIn() ? Icons.logout : Icons.login,
            ),
          ),
        ],
      ),
      body: Center(
        child: getFeedWidget(texts),
      ),
    );
  }

  Widget getFeedWidget(List feeds) {
    return FutureBuilder(
        future:
            db.collection("posts").orderBy("timestamp", descending: true).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView(
            padding: const EdgeInsets.all(100),
            children: snapshot.data!.docs
                .map((feed) => getPostWidget(
                    feed.data()['username'] ?? '', feed.data()['text'] ?? ''))
                .toList(),
          );
        });
  }

  Widget getPostWidget(String username, String text) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 40,
          ),
          Divider()
        ],
      ),
    );
  }

  void logout() {
    print("Logging out");
    FirebaseAuth.instance.signOut();
    setState(() {});
  }
}

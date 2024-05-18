import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String postText = '';
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add Post"),
      ),
      body: Center(
        child: getWidgets(),
      ),
    );
  }

  Widget getWidgets() {
    return Container(
      padding: EdgeInsets.all(40),
      width: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add a post"),
          TextField(
            maxLines: null,
            minLines: 3,
            onChanged: (value) => setState(() {
              postText = value;
            }),
            decoration: InputDecoration(
                hintText: "Write your post here...",
                border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  await db.collection("posts").add({
                    "username": FirebaseAuth.instance.currentUser?.displayName,
                    "text": postText,
                    "timestamp": DateTime.now().millisecondsSinceEpoch
                  });
                  goBackToHomeScreen(context);
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Submit"))
        ],
      ),
    );
  }
}

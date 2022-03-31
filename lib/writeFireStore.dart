import 'package:flutter/material.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatelessWidget {
  final String name;
  final DateTime time;
  // final int age;
  AddUser(this.name, this.time);
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('InTime');
    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'personName': name, // John Doe
            'entryTime': time, // Stokes and Sons
            // 'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

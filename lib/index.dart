import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'main.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  void initState() {
    this.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[],
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 3) {
              _auth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Index()));
            }
            // else if (index == 1) {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => Search()));
            // }
            // else if (index == 2) {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => Person()));
            // }
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),
          // SalomonBottomBarItem(
          //     icon: Icon(Icons.favorite_border),
          //     title: Text("Likes"),
          //     selectedColor: Colors.pink),
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.logout),
            title: Text("LogOut"),
            selectedColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

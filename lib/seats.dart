import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/adminPanel.dart';
import 'package:loginapp/animation/FadeAnimation.dart';
import 'package:loginapp/index.dart';
import 'package:loginapp/main.dart';
import 'package:loginapp/readFireStore.dart';
import 'package:loginapp/userProfile.dart';
import 'package:loginapp/writeFireStore.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'getUserActivity.dart';

class Busseats extends StatefulWidget {
  const Busseats({Key? key}) : super(key: key);

  @override
  _BusseatsState createState() => _BusseatsState();
}

class _BusseatsState extends State<Busseats> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Rows is adding seats

  var _chairStatus = [
    [1, 3, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 3, 1, 1],
    [1, 1, 1, 1, 1, 3, 3],
    [2, 2, 2, 1, 3, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 2, 1, 1, 2, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1],
  ];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            'Some Text Here',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
                child: FadeAnimation(
              1.2,
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
              ),
            ))
          ];
        },
        // body: Padding(
        //   padding: EdgeInsets.all(20.0),
        //   child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Expanded(
        //           child: GridView.builder(
        //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //                 crossAxisCount: 2,
        //                 childAspectRatio: 1.0,
        //                 crossAxisSpacing: 20.0,
        //                 mainAxisSpacing: 20.0,
        //               ),
        //               physics: NeverScrollableScrollPhysics(),
        //               itemCount: widget.booksGenre.length,
        //               itemBuilder: (BuildContext context, int index) {
        //                 print(widget.booksGenre.length);
        //                 print("here2002");
        //                 return FadeAnimation(
        //                     (1.0 + index) / 4,
        //                     serviceContainer(widget.booksGenre[index].bookImage,
        //                         widget.booksGenre[index].bookGenre, index));
        //               }),
        //         ),
        //       ]),
        // ),
        body: Container(
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 11; i++)
                Container(
                  margin: EdgeInsets.only(top: i == 0 ? 20 : 0),
                  child: Row(
                    children: <Widget>[
                      for (int x = 1; x < 8; x++)
                        Expanded(
                          // x==1 and x==2 and x==3rd column not visible
                          child: (x == 1) || (x == 2) || (x == 3)
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.all(8),
                                  child: _chairStatus[i][x - 1] == 1
                                      ? availableChair(i, x - 1)
                                      : _chairStatus[i][x - 1] == 2
                                          ? selectedChair(i, x - 1)
                                          : reservedChair(),
                                ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Index()));
            } else if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompleteProfileScreen()));
            } else if (index == 2) {
              int flag = 0;
              FirebaseFirestore.instance
                  .collection('librarian')
                  .where('email',
                      isEqualTo: FirebaseAuth.instance.currentUser.email)
                  .where('displayName',
                      isEqualTo: FirebaseAuth.instance.currentUser.displayName)
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                flag = 1;
                print("here");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserTab()));
              });
            }
            if (index == 3) {
              showAlertDialog(context);
            }
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
          // SalomonBottomBarItem(
          //   icon: Icon(Icons.search),
          //   title: Text("Search"),
          //   selectedColor: Colors.orange,
          // ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.admin_panel_settings),
            title: Text("Admin"),
            selectedColor: Colors.redAccent,
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

  showAlertDialog(BuildContext context) {
    // set up the button
    // Widget logOutButton = SalomonBottomBarItem(
    //   icon: Icon(Icons.logout),
    //   title: Text("LogOut"),
    //   selectedColor: Colors.redAccent,
    // );
    Widget okButton = TextButton(
      child: Text("Logout"),
      onPressed: () {
        _auth.signOut();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomePage()));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout Alert!!"),
      content: Text("Are You Sure You Want To LogOut?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget selectedChair(int a, int b) {
    return InkWell(
      onTap: () {
        _chairStatus[a][b] = 1;
        setState(() {});
      },
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(3.0)),
      ),
    );
  }

  Widget availableChair(int a, int b) {
    return InkWell(
      onTap: () {
        _chairStatus[a][b] = 2;
        setState(() {});
      },
      child: Container(
        height: 40.0,
        width: 10.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(
            color: Color.fromRGBO(0, 0, 0, 1),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget reservedChair() {
    return Container(
      height: 40.0,
      width: 10.0,
      decoration: BoxDecoration(
          color: Color.fromRGBO(15, 15, 15, 0.24),
          borderRadius: BorderRadius.circular(3.0)),
    );
  }
}

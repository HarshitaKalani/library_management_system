import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/adminPanel.dart';
import 'package:loginapp/index.dart';
import 'package:loginapp/main.dart';
import 'package:loginapp/temp.dart';
import 'package:loginapp/userProfile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'models/books.dart';
import 'animation/FadeAnimation.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GetUserActivity extends StatefulWidget {
  @override
  State<GetUserActivity> createState() => _GetUserActivityState();
}

class _GetUserActivityState extends State<GetUserActivity> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

  List<Service> _services = [];
  int selectedService = -1;
  int _currentIndex = 0;

  // const GetUserActivity({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser;
    final username = user.displayName;
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('InTime')
        .where('personName', isEqualTo: _auth.currentUser.displayName)
        .snapshots(includeMetadataChanges: true);
    final Future<Null> _listUser = FirebaseFirestore.instance
        .collection('InTime')
        .where('personName', isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        print(doc['entryTime'].toDate().toString());
        // var x = Service(doc["full_name"],
        //     'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png');
        // _services.insert(i, x);
        // print(_services);
      });
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              'Your Past Visits at Library IITJ',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {},
                child: ListTile(
                  title: Text("Date : " +
                      DateFormat.yMMMd()
                          .format(data['entryTime'].toDate())
                          .toString()),
                  subtitle: Text("Time : " +
                      DateFormat.jm()
                          .format(data['entryTime'].toDate())
                          .toString()),
                  // trailing: Text(data['age'].toString()),
                ),
              );
            }).toList(),
          );
        },
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
              FirebaseFirestore.instance
                  .collection('librarian')
                  .where('email',
                      isEqualTo: FirebaseAuth.instance.currentUser.email)
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {
                  // print(doc['entryTime'].toDate().toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserTab()));
                  // var x = Service(doc["full_name"],
                  //     'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png');
                  // _services.insert(i, x);
                  // print(_services);
                });
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => UserTab()));
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
}

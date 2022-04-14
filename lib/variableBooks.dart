import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginapp/adminPanel.dart';
import 'package:loginapp/bookIssue.dart';
import 'package:loginapp/index.dart';
import 'package:loginapp/readFireStore.dart';
import 'package:loginapp/temp.dart';
import 'package:loginapp/userProfile.dart';
import 'package:loginapp/writeFireStore.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:loginapp/bookIssue.dart';
import 'animation/FadeAnimation.dart';
import 'getUserActivity.dart';
import 'main.dart';
import 'models/books.dart';
import 'package:flutter/material.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VariableBooks extends StatefulWidget {
  // const Genre({Key? key}) : super(key: key);
  // final List<Service> services;
  final List<Books> books;

  VariableBooks({required this.books});

  @override
  State<VariableBooks> createState() => _VariableBooksState();
}

class _VariableBooksState extends State<VariableBooks> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedService = -1;
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _searchValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: selectedService >= 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      book: widget.books[selectedService],
                      bookHere: widget.books,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.download,
                size: 20,
              ),
              backgroundColor: Colors.blue,
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
                child: FadeAnimation(
              1.2,
              Padding(
                padding: EdgeInsets.only(top: 120.0, right: 20.0, left: 20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Select book to issue!',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (input) {
                            if (input != null && input.isEmpty)
                              return "Search Something";
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade700,
                            ),
                            border: InputBorder.none,
                            hintText: "Search Book",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                          ),
                          onSaved: (input) => _searchValue = input!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                      ),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.books.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(widget.books.length);
                        print("here2002");
                        return FadeAnimation(
                            (1.0 + index) / 4,
                            serviceContainer(
                                widget.books[index].bookImage,
                                widget.books[index].bookName,
                                widget.books[index].bookAuthor,
                                index));
                      }),
                ),
              ]),
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

  serviceContainer(String image, String name, String authorName, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedService == index)
            selectedService = -1;
          else
            selectedService = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index
                ? Colors.blue
                : Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image, height: 80),
              SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Author : ' + authorName,
                style: TextStyle(fontSize: 12),
              ),
            ]),
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

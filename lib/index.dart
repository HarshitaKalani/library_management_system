import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginapp/seats.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'handleBarcode.dart';
import 'main.dart';
import 'temp.dart';
import 'writeFireStore.dart';
import 'readFireStore.dart';
import 'models/books.dart';
import 'genre.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  // List<Service> services2 = Service.getList(); // to show book in backend.
  List<Service> services2 = <Service>[
    Service('Cleaning',
        'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
  ];
  List<Books> books = <Books>[];

  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;
  int _current = 0;
  dynamic _selectedIndex = {};

  CarouselController _carouselController = new CarouselController();

  List<dynamic> _products = [
    {
      'title': 'Library Sitting Space Arrangement',
      'image': 'assets/Logo_IITJ.png',
      'description': 'Tap to see available spaces'
    },
    {
      'title': 'Books List',
      // 'image':'https://images.unsplash.com/photo-1582588678413-dbf45f4823e9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2265&q=80',
      'image': 'assets/5836.jpg',
      'description': 'Tap to see Availabe Books'
    },
    {
      'title': 'Our Team',
      // 'image':'https://images.unsplash.com/photo-1589188056053-28910dc61d38?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2264&q=80',
      'image': 'assets/54955.jpg',
      'description': 'Wohoo!!'
    },
    {
      'title': 'Mark Presence',
      'image': 'assets/5228739.jpg',
      'description': 'Scan Qr Code to mark presence',
    }
  ];

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser!;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  getService() async {
    final Future<Null> _listUser = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        // print(doc["full_name"]);
        var x = Service(doc["full_name"],
            'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png');
        services2.insert(i, x);
        i = i + 1;
      });
    });
  }

  getBooks() async {
    final Future<Null> _listUser = FirebaseFirestore.instance
        .collection('Books')
        .get()
        .then((QuerySnapshot querySnapshot) {
      var i = 0;
      var flag = 0;
      querySnapshot.docs.forEach((doc) {
        var x = Books(doc['bookName'], doc['bookGenre'], doc['bookImage'],
            doc['bookAuthor']);

        books.insert(i, x);
      });
    });
  }

  @override
  void initState() {
    this.getUser();
    this.getService();
    this.getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex.length > 0
          ? Container(
              child: Align(
                // alignment: Alignment(
                //   (0.0 / MediaQuery.of(context).size.width),
                //   (0.0 / (MediaQuery.of(context).size.height)),
                // ),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    if (_current == 1) {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             SelectService(services: services2)));
                      List<Books> booksGenre = <Books>[];
                      print(books.length);
                      for (var i = 0; i < books.length; i = i + 1) {
                        var flag = 0;
                        if (booksGenre.length == 0) {
                          booksGenre.insert(0, books[i]);
                        } else {
                          for (var j = 0; j < booksGenre.length; j = j + 1) {
                            if (booksGenre[j].bookGenre == books[i].bookGenre) {
                              flag = 1;
                              break;
                            }
                          }
                          if (flag == 0) {
                            booksGenre.insert(0, books[i]);
                          }
                        }
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Genre(
                                    booksGenre: booksGenre,
                                  )));
                    } else if (_current == 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Busseats()));
                    } else if (_current == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRViewExample()));
                    }
                  },
                  child: _current == 3
                      ? Icon(
                          Icons.camera_alt_outlined,
                        )
                      : Icon(
                          Icons.arrow_forward_ios,
                        ),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'You are @Library IIT Jodhpur',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
                height: 450.0,
                aspectRatio: 16 / 9,
                viewportFraction: 0.70,
                enlargeCenterPage: true,
                pageSnapping: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: _products.map((movie) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedIndex == movie) {
                          _selectedIndex = {};
                        } else {
                          _selectedIndex = movie;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: _selectedIndex == movie
                              ? Border.all(
                                  color: Colors.blue.shade500, width: 3)
                              : null,
                          boxShadow: _selectedIndex == movie
                              ? [
                                  BoxShadow(
                                      color: Colors.blue.shade100,
                                      blurRadius: 30,
                                      offset: Offset(0, 10))
                                ]
                              : [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: Offset(0, 5))
                                ]),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 320,
                              margin: EdgeInsets.only(top: 10),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // child: Image.network(movie['image'],
                              //     fit: BoxFit.cover),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      movie['image'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              movie['title'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              movie['description'],
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList()),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 3) {
              showAlertDialog(context);
              // _auth.signOut();
              // // Navigator.push(
              // //     context, MaterialPageRoute(builder: (context) => HomePage()));
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (context) => HomePage()),
              //     (route) => false);
            }
            // else if (index == 0) {
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => Verificatoin()));
            // }
            else if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddUser("Hereit is", "Flipkart", 20)));
            } else if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GetUserName()));
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

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      3.14,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

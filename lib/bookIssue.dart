// import 'package:book_app/consttants.dart';
// import 'package:book_app/widgets/book_rating.dart';
// import 'package:book_app/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/adminPanel.dart';
import 'package:loginapp/index.dart';
import 'package:loginapp/readFireStore.dart';
import 'package:loginapp/userProfile.dart';
import 'package:loginapp/writeFireStore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'animation/FadeAnimation.dart';
import 'getUserActivity.dart';
import 'main.dart';
import 'models/books.dart';
import 'models/chapterCard.dart';
import 'models/rating.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';

const kBlackColor = Color(0xFF393939);
const kLightBlackColor = Color(0xFF8F8F8F);
const kIconColor = Color(0xFFF48A37);
const kProgressIndicator = Color(0xFFBE7066);

final kShadowColor = Color(0xFFD3D3D3).withOpacity(.84);

class DetailsScreen extends StatefulWidget {
  final Books book;
  final List<Books> bookHere;

  DetailsScreen({
    required this.book,
    required this.bookHere,
  });
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int selectedService = -1;
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final User user = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        top: size.height * .12,
                        left: size.width * .1,
                        right: size.width * .02),
                    height: size.height * .48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bg.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: BookInfo(
                      book: widget.book,
                      size: size,
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headline5,
                      children: [
                        TextSpan(
                          text: "You might also ",
                        ),
                        TextSpan(
                          text: "like….",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    // padding: EdgeInsets.only(top: size.height * .48 - 20),
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (var i = 0; i < widget.bookHere.length; i = i + 1)
                          if (widget.bookHere[i].bookName !=
                              widget.book.bookName)
                            ChapterCard(
                              name: widget.bookHere[i].bookName,
                              chapterNumber: i + 1,
                              author: widget.bookHere[i].bookAuthor,
                              press: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                            book: widget.bookHere[i],
                                            bookHere: widget.bookHere,
                                          )),
                                  (route) => false,
                                );
                              },
                            ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
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

class BookInfo extends StatelessWidget {
  final Books book;
  const BookInfo({
    required this.book,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "TITLE: " + book.bookName,
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: this.size.height * .005),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      "By: " + book.bookAuthor,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: this.size.width * .3,
                            padding:
                                EdgeInsets.only(top: this.size.height * .02),
                            child: Text(
                              book.bookDescription,
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: 10,
                                color: kLightBlackColor,
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: this.size.height * .015),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: book.bookIssued
                                ? Text(
                                    "Currently \nUnavailable",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  )
                                : FlatButton(
                                    onPressed: () async {
                                      sendMail(
                                          FirebaseAuth
                                              .instance.currentUser.email
                                              .toString(),
                                          FirebaseAuth
                                              .instance.currentUser.displayName
                                              .toString(),
                                          book.bookName);
                                      CollectionReference bookIssuedDetails =
                                          FirebaseFirestore.instance
                                              .collection('IssuedBooks');
                                      bookIssuedDetails
                                          .add({
                                            'bookDetails':
                                                book.bookId, // John Doe
                                            'issuedBy': FirebaseAuth
                                                .instance
                                                .currentUser
                                                .displayName, // Stokes and Sons
                                            // 'age': age // 42
                                            'issuedTime': DateTime.now(),
                                            'bookName': book.bookName,
                                          })
                                          .then((value) => print("Book Added"))
                                          .catchError((error) => print(
                                              "Failed to add user: $error"));

                                      FirebaseFirestore.instance
                                          .collection('Books')
                                          .doc(book.bookId)
                                          .update({'bookIssued': true})
                                          .then((value) => {
                                                print("User Updated"),
                                                showAlertDialog2(context),
                                              })
                                          .catchError((error) => print(
                                              "Failed to update user: $error"));

                                      // await FlutterEmailSender.send(email);
                                    },
                                    child: Text(
                                      "Issue",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                          BookRating(score: 4.9),
                        ],
                      )
                    ],
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.transparent,
                child: Image.network(
                  book.bookImage,
                  height: double.infinity,
                  alignment: Alignment.topRight,
                  fit: BoxFit.fitWidth,
                ),
              )),
        ],
      ),
    );
  }

  showAlertDialog2(BuildContext context) {
    // set up the button
    // Widget logOutButton = SalomonBottomBarItem(
    //   icon: Icon(Icons.logout),
    //   title: Text("LogOut"),
    //   selectedColor: Colors.redAccent,
    // );
    Widget okButton = TextButton(
      child: Text("Go Back"),
      onPressed: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomePage()));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Index()), (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Book Issued!!"),
      content: Text("You have successfully Issued the book!!"),
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

// void sendMail(String s, String t, String u) {}
void sendMail(String email, String personName, String bookName) async {
  String username = 'goswamipranav11@gmail.com';
  String password = 'Pranav@2002';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, username.toString())
    ..recipients.add(email)
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Book Issue @Library IITJ::  ${DateTime.now()}'
    ..text = 'Heyy ' +
        personName +
        '!' +
        '\nYou have successfully Issued ' +
        bookName +
        ' on ${DateTime.now()}' +
        '\nYou will have to return the book within 7 working days else you will be penalised!!' +
        '\nRegards.';
  // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
  // DONE

  // Let's send another message using a slightly different syntax:
  //
  // Addresses without a name part can be set directly.
  // For instance `..recipients.add('destination@example.com')`
  // If you want to display a name part you have to create an
  // Address object: `new Address('destination@example.com', 'Display name part')`
  // Creating and adding an Address object without a name part
  // `new Address('destination@example.com')` is equivalent to
  // adding the mail address as `String`.

  // final equivalentMessage = Message()
  //   ..from = Address(username, 'Your name 😀')
  //   ..recipients.add(Address('goswamipranav11@gmail.com'))
  //   // ..ccRecipients
  //   //     .addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
  //   // ..bccRecipients.add('bccAddress@example.com')
  //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
  //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
  //   ..html =
  //       '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>'
  //   ..attachments = [
  //     // FileAttachment(File('exploits_of_a_mom.png'))
  //     //   ..location = Location.inline
  //     //   ..cid = '<myimg@3.141>'
  //   ];

  final sendReport2 = await send(message, smtpServer);

  // Sending multiple messages with the same connection
  //
  // Create a smtp client that will persist the connection
  var connection = PersistentConnection(smtpServer);

  // Send the first message
  await connection.send(message);

  // send the equivalent message
  // await connection.send(equivalentMessage);

  // close the connection
  await connection.close();
}

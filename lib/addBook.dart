import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loginapp/adminPanel.dart';
import 'package:loginapp/login.dart';
import 'package:loginapp/userProfile.dart';
import 'main.dart';
import 'index.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:loginapp/index.dart';
import 'package:loginapp/userProfile.dart';

class AddBook extends StatefulWidget {
  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  // late AnimationController loadingController;
  File? _file;
  PlatformFile? _platformFile;
  String path = "";
  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _bookAuthor,
      _bookDescription,
      _bookGenre,
      _bookImage,
      _bookName,
      _bookPdf;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);
    // loadingController.forward();
    if (file != null) {
      setState(() async {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
        var request = http.MultipartRequest(
            "POST", Uri.parse("https://api.imgur.com/3/image"));

        request.fields['title'] = "profileImage";
        request.headers['Authorization'] = "Client-ID " + "88086886d6517aa";

        // var picture = http.MultipartFile.fromBytes('image',
        //     (await rootBundle.load('assets/5228739.jpg')).buffer.asUint8List(),
        //     filename: 'testImage.jpg');
        // var picture = http.MultipartFile.fromBytes('image',
        //     (await rootBundle.load('assets/5228739.jpg')).buffer.asUint8List(),
        //     filename: 'testImage.jpg');
        // var picture = http.MultipartFile.fromPath('image', _file!.path,
        //     filename: 'testImage.jpg');
        // request.files.add(picture);
        request.files
            .add(await http.MultipartFile.fromPath('image', _file!.path));

        var response = await request.send();
        var responseData = await response.stream.toBytes();

        var result = String.fromCharCodes(responseData);
        print("resultHere");
        for (var i = 0; i < result.length - 8; i = i + 1) {
          if (result[i] == 'l') {
            if (result[i + 1] == "i") {
              if (result[i + 2] == "n") {
                if (result[i + 3] == "k") {
                  var j = i + 7;
                  while (result[j] != "}") {
                    if (result[j] != '\\') {
                      path = path + result[j];
                    }
                    j = j + 1;
                  }
                  break;
                }
              }
            }
          }
        }
        print(result);
        path = path.substring(0, path.length - 1);
        print(path);

        // FirebaseAuth.instance.currentUser.updateProfile(photoURL: path);

        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Index(),
        //   ),
        //   (route) => false,
        // );
      });
    }
  }

  CollectionReference book = FirebaseFirestore.instance.collection('Books');
  addBook() {
    // if (_formKey.currentState!.validate()) {
    // _formKey.currentState!.save();
    // }
    _formKey.currentState!.save();
    if (_bookAuthor == null ||
        _bookName == null ||
        _bookDescription == null ||
        _bookGenre == null ||
        path == null) {
      print("hererere");
      showError("Invalid Details, Some details are missing!!");
    }
    // Call the user's CollectionReference to add a new user
    else {
      try {
        // selectFile();
        print(path);
        return book
            .add({
              'bookAuthor': _bookAuthor!, // John Doe
              'bookName': _bookName!, // Stokes and Sons
              'bookDescription': _bookDescription,
              'bookGenre': _bookGenre,
              'bookImage': path,
              'bookIssued': false,
              'bookPdf': 'cheel',
              // 'age': age // 42
            })
            .then((value) => print("book Added"))
            .catchError((error) => print("Failed to add user: $error"));
      } catch (e) {
        showError("error Here");
      }
    }
  }

  showError(String errormessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ERROR'),
          content: Text(errormessage),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        title: Text(
          '\n Add New Book',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
          ),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Column(
              //   children: <Widget>[
              //     Text(
              //       "Add New Book",
              //       style: TextStyle(
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     SizedBox(
              //       height: 20,
              //     ),
              //   ],
              // ),
              Column(
                children: <Widget>[
                  Container(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                validator: (input) {
                                  if (input != null && input.isEmpty)
                                    return "Enter Name";
                                },
                                decoration: InputDecoration(
                                  labelText: "Book Name",
                                  prefixIcon: Icon(Icons.book),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 10),
                                  enabledBorder: (OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  )),
                                ),
                                onSaved: (input) => _bookName = input!,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: TextFormField(
                                validator: (input) {
                                  if (input != null && input.isEmpty)
                                    return "Confirm Username";
                                },
                                decoration: InputDecoration(
                                  labelText: "Book Author",
                                  prefixIcon: Icon(Icons.person),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 10),
                                  enabledBorder: (OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  )),
                                ),
                                onSaved: (input) => _bookAuthor = input!,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: TextFormField(
                                validator: (input) {
                                  if (input != null && input.isEmpty)
                                    return "Confirm Username";
                                },
                                decoration: InputDecoration(
                                  labelText: "Book Genre",
                                  prefixIcon:
                                      Icon(Icons.generating_tokens_rounded),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 10),
                                  enabledBorder: (OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  )),
                                ),
                                onSaved: (input) => _bookGenre = input!,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: TextFormField(
                                validator: (input) {
                                  if (input != null && input.isEmpty)
                                    return "Confirm Username";
                                },
                                decoration: InputDecoration(
                                  labelText: "Book Description",
                                  prefixIcon: Icon(Icons.description_outlined),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 10),
                                  enabledBorder: (OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  )),
                                ),
                                onSaved: (input) => _bookDescription = input!,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              // child: TextFormField(
                              //   validator: (input) {
                              //     if (input != null && input.isEmpty)
                              //       return "Confirm Username";
                              //   },
                              //   decoration: InputDecoration(
                              //     labelText: "Book Image",
                              //     prefixIcon: Icon(Icons.image),
                              //     contentPadding: EdgeInsets.symmetric(
                              //         vertical: 30, horizontal: 10),
                              //     enabledBorder: (OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //         color: Colors.grey,
                              //       ),
                              //     )),
                              //   ),
                              //   onSaved: (input) => _bookImage = input!,
                              // ),
                              child: GestureDetector(
                                onTap: selectFile,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 20.0),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(10),
                                      dashPattern: [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: Colors.blue.shade400,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade50
                                                .withOpacity(.3),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Iconsax.folder_open,
                                              color: Colors.blue,
                                              size: 40,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              'Select Book Image',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            // _platformFile != null
                            //     ? Container(
                            //         padding: EdgeInsets.all(20),
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               'Selected File',
                            //               style: TextStyle(
                            //                 color: Colors.grey.shade400,
                            //                 fontSize: 15,
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               height: 10,
                            //             ),
                            //             Container(
                            //                 padding: EdgeInsets.all(8),
                            //                 decoration: BoxDecoration(
                            //                     borderRadius:
                            //                         BorderRadius.circular(10),
                            //                     color: Colors.white,
                            //                     boxShadow: [
                            //                       BoxShadow(
                            //                         color: Colors.grey.shade200,
                            //                         offset: Offset(0, 1),
                            //                         blurRadius: 3,
                            //                         spreadRadius: 2,
                            //                       )
                            //                     ]),
                            //                 child: Row(
                            //                   children: [
                            //                     ClipRRect(
                            //                         borderRadius:
                            //                             BorderRadius.circular(8),
                            //                         child: Image.file(
                            //                           _file!,
                            //                           width: 70,
                            //                         )),
                            //                     SizedBox(
                            //                       width: 10,
                            //                     ),
                            //                     Expanded(
                            //                       child: Column(
                            //                         crossAxisAlignment:
                            //                             CrossAxisAlignment.start,
                            //                         children: [
                            //                           Text(
                            //                             _platformFile!.name,
                            //                             style: TextStyle(
                            //                                 fontSize: 13,
                            //                                 color: Colors.black),
                            //                           ),
                            //                           SizedBox(
                            //                             height: 5,
                            //                           ),
                            //                           Text(
                            //                             '${(_platformFile!.size / 1024).ceil()} KB',
                            //                             style: TextStyle(
                            //                                 fontSize: 13,
                            //                                 color: Colors
                            //                                     .grey.shade500),
                            //                           ),
                            //                           SizedBox(
                            //                             height: 5,
                            //                           ),
                            //                           Container(
                            //                               height: 5,
                            //                               clipBehavior:
                            //                                   Clip.hardEdge,
                            //                               decoration:
                            //                                   BoxDecoration(
                            //                                 borderRadius:
                            //                                     BorderRadius
                            //                                         .circular(5),
                            //                                 color: Colors
                            //                                     .blue.shade50,
                            //                               ),
                            //                               child:
                            //                                   LinearProgressIndicator(
                            //                                 value:
                            //                                     loadingController
                            //                                         .value,
                            //                               )),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                     SizedBox(
                            //                       width: 10,
                            //                     ),
                            //                   ],
                            //                 )),
                            //             SizedBox(
                            //               height: 20,
                            //             ),
                            //             // MaterialButton(
                            //             //   minWidth: double.infinity,
                            //             //   height: 45,
                            //             //   onPressed: () {},
                            //             //   color: Colors.black,
                            //             //   child: Text('Upload', style: TextStyle(color: Colors.white),),
                            //             // )
                            //           ],
                            //         ))
                            //     : Container(),
                            // SizedBox(height: 10),
                            // Container(
                            //   child: TextFormField(
                            //     validator: (input) {
                            //       if (input != null && input.length < 6)
                            //         return "Provide Minimum 6 character";
                            //     },
                            //     decoration: InputDecoration(
                            //       labelText: "Password",
                            //       prefixIcon: Icon(Icons.lock),
                            //       contentPadding: EdgeInsets.symmetric(
                            //           vertical: 30, horizontal: 10),
                            //       enabledBorder: (OutlineInputBorder(
                            //         borderSide: BorderSide(
                            //           color: Colors.grey,
                            //         ),
                            //       )),
                            //     ),
                            //     obscureText: true,
                            //     onSaved: (input) => _password = input!,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FloatingActionButton(
                // onPressed: () => showAlertDialog(context),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    showAlertDialog(context);
                  }
                  // _formKey.currentState!.save();
                  // addBook();
                  // showAlertDialog(context);
                },

                child: Icon(
                  Icons.add_box_rounded,
                ),
              ),
              // Column(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.only(top: 3, left: 3),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(50),
              //         border: Border(
              //           bottom: BorderSide(color: Colors.black),
              //           top: BorderSide(color: Colors.black),
              //           left: BorderSide(color: Colors.black),
              //           right: BorderSide(color: Colors.black),
              //         ),
              //       ),
              //       // child: FloatingActionButton(
              //       //   onPressed: () => {},
              //       //   child: Icon(
              //       //     Icons.add_box,
              //       //   ),
              //       // ),
              //       // child: MaterialButton(
              //       //   minWidth: double.infinity,
              //       //   height: 60,
              //       //   onPressed: () => {},
              //       //   color: Colors.greenAccent,
              //       //   elevation: 0,
              //       //   shape: RoundedRectangleBorder(
              //       //     borderRadius: BorderRadius.circular(
              //       //       50,
              //       //     ),
              //       //   ),
              //       //   // child: Text(
              //       //   //   "Update",
              //       //   //   style: TextStyle(
              //       //   //     fontWeight: FontWeight.w600,
              //       //   //     fontSize: 18,
              //       //   //   ),
              //       //   // ),
              //       //   child: Icon(Icons.add_box_rounded),
              //       // ),
              //     ),
              //     SizedBox(height: 10),
              //     // Row(
              //     //   mainAxisAlignment: MainAxisAlignment.center,
              //     //   children: <Widget>[
              //     //     Text("Already have an account?"),
              //     //     GestureDetector(
              //     //         child: Text(
              //     //           "  Login",
              //     //           style: TextStyle(
              //     //             fontWeight: FontWeight.w600,
              //     //             fontSize: 18,
              //     //           ),
              //     //         ),
              //     //         onTap: () {
              //     //           Navigator.pushAndRemoveUntil(
              //     //               context,
              //     //               MaterialPageRoute(
              //     //                   builder: (context) => LoginPage()),
              //     //               (route) => false);
              //     //         }),
              //     //   ],
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
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
      child: Text("Confirm Add Book"),
      onPressed: () {
        _formKey.currentState!.save();

        if (_bookAuthor == null ||
            _bookName == null ||
            _bookDescription == null ||
            _bookGenre == null ||
            path == null) {
          showError("Invalid Details, Some details are missing!!");
        } else {
          addBook();
        }
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomePage()));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => UserTab()),
            (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Book Alert!!"),
      content: Column(
        children: <Widget>[
          Text('Book Name: ' + _bookName!),
          Text('Book Author: ' + _bookAuthor!),
          Text('Book Description: ' + _bookDescription!),
          Text('Book Genre: ' + _bookGenre!),
        ],
      ),
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

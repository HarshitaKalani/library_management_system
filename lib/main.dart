import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }
void main() {
  runApp(
    const MaterialApp(
      title: 'Library Management System',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: Text('Library IIT Jodhpur'),
        ),
      ),
      body: Container(
        child: Container(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BooksList()),
              );
            },
            child: new Center(
              child: Container(
                child: Text("Books List"),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          height: 200.0,
          width: 200.0,
          margin: EdgeInsets.all(130),
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class BooksList extends StatelessWidget {
  const BooksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List of Books",
        ),
      ),
      body: Container(
        child: Text(
          "List of Books will be displayed Here",
        ),
      ),
    );
  }
}

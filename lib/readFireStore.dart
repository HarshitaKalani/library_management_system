import 'package:flutter/material.dart';
import 'models/books.dart';
import 'animation/FadeAnimation.dart';

// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserName extends StatefulWidget {
  @override
  State<GetUserName> createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  List<Service> _services = [];
  int selectedService = -1;
  // const GetUserName({ Key? key }) : super(key: key);

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    final Future<Null> _listUser = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      var i = 0;
      querySnapshot.docs.forEach((doc) {
        // print(doc["full_name"]);
        var x = Service(doc["full_name"],
            'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png');
        _services.insert(i, x);
        print(_services);
      });
    });
    return Scaffold(
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
              return ListTile(
                title: Text(data["full_name"]),
                subtitle: Text(data["company"]),
                trailing: Text(data['age'].toString()),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

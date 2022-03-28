import 'package:loginapp/variableBooks.dart';

import 'animation/FadeAnimation.dart';
import 'models/books.dart';
import 'package:flutter/material.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Genre extends StatefulWidget {
  // const Genre({Key? key}) : super(key: key);
  // final List<Service> services;
  final List<Books> booksGenre;

  Genre({required this.booksGenre});

  @override
  _GenreState createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  // List<Service> services = [
  //   Service('Cleaning',
  //       'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
  //   Service('Plumber',
  //       'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
  //   Service('Electrician',
  //       'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'),
  //   Service('Painter',
  //       'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'),
  //   Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
  //   Service('Gardener',
  //       'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png'),
  //   Service('Tailor', 'https://img.icons8.com/fluency/2x/sewing-machine.png'),
  //   Service('Maid', 'https://img.icons8.com/color/2x/housekeeper-female.png'),
  //   Service('Driver',
  //       'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/2x/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png'),
  //   Service('Cook',
  //       'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-cooking-daily-routine-wanicon-flat-wanicon.png'),
  // ];
  // List<Service> services = [
  //   Service('Genre 1',
  //       'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
  //   Service('Genre 2',
  //       'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
  //   Service('Genre 3',
  //       'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'),
  //   // Service('Painter',
  //   //     'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'),
  //   // Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
  //   // Service('Gardener',
  //   //     'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png'),
  //   // Service('Tailor', 'https://img.icons8.com/fluency/2x/sewing-machine.png'),
  //   // Service('Maid', 'https://img.icons8.com/color/2x/housekeeper-female.png'),
  //   // Service('Driver',
  //   //     'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/2x/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png'),
  //   // Service('Cook',
  //   //     'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-cooking-daily-routine-wanicon-flat-wanicon.png'),
  // ];

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: selectedService >= 0
            ? FloatingActionButton(
                onPressed: () {
                  // print(selectedService);
                  var genre = widget.booksGenre[selectedService].bookGenre;
                  print(genre);
                  List<Books> selectedBooks = <Books>[];
                  final Future<Null> _listUser = FirebaseFirestore.instance
                      .collection('Books')
                      .where('bookGenre', isEqualTo: genre)
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    var i = 0;
                    var flag = 0;
                    querySnapshot.docs.forEach(
                      (doc) {
                        var x = Books(doc['bookName'], doc['bookGenre'],
                            doc['bookImage'], doc['bookAuthor']);

                        selectedBooks.insert(i, x);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VariableBooks(
                                      books: selectedBooks,
                                    )));

                        // print(selectedBooks);
                      },
                    );
                  });
                },
                child: Icon(
                  Icons.arrow_forward_ios,
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
                  child: Text(
                    'Select Genre!',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
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
                        itemCount: widget.booksGenre.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(widget.booksGenre.length);
                          print("here2002");
                          return FadeAnimation(
                              (1.0 + index) / 4,
                              serviceContainer(
                                  widget.booksGenre[index].bookImage,
                                  widget.booksGenre[index].bookGenre,
                                  index));
                        }),
                  ),
                ]),
          ),
        ));
  }

  serviceContainer(String image, String name, int index) {
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
                style: TextStyle(fontSize: 20),
              )
            ]),
      ),
    );
  }
}

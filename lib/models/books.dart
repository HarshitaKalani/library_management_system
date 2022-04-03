import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String name;
  final String imageURL;

  Service(this.name, this.imageURL);
  static List<Service> getList() {
    List<Service> services2 = <Service>[
      Service('Cleaning',
          'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
    ];
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
      });
    });
    print(services2);
    return services2;
  }
}

class Books {
  late final String bookName;
  late final String bookGenre;
  late final String bookImage;
  late final String bookAuthor;
  late final String bookDescription;
  late final bool bookIssued;
  late final String bookId;

  Books(this.bookName, this.bookGenre, this.bookImage, this.bookAuthor,
      this.bookDescription, this.bookIssued, this.bookId);
}

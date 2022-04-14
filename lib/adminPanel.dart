import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
// import 'package:shop_app/enums.dart';

// import 'components/body.dart';

// import 'profile_menu.dart';
// import 'profile_pic.dart';
import 'package:flutter_svg/flutter_svg.dart';

// import '../../../constants.dart';
// import 'package:shop_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/addBook.dart';
import 'package:loginapp/allAvailablebooks.dart';
import 'package:loginapp/allIssuedBooks.dart';
import 'package:loginapp/getUserIssuedBooks.dart';
import 'package:loginapp/index.dart';
import 'package:loginapp/main.dart';
import 'package:loginapp/readFireStore.dart';
import 'package:loginapp/updateProfileImage.dart';
import 'package:loginapp/updateUsername.dart';
import 'package:loginapp/userProfile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'getUserActivity.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

enum MenuState { home, favourite, message, profile }

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // CircleAvatar(
          //   backgroundImage: AssetImage("assets/54955.jpg"),
          //   // backgroundImage:
          //   //     AssetImage(FirebaseAuth.instance.currentUser.photoURL),
          // ),
          FirebaseAuth.instance.currentUser.photoURL != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    FirebaseAuth.instance.currentUser.photoURL,
                  ),
                )
              : CircleAvatar(
                  // backgroundImage: AssetImage("assets/54955.jpg"),

                  backgroundImage: AssetImage('assets/54955.jpg'),
                ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  primary: Colors.black,
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadImage(),
                    ),
                    (route) => false,
                  );
                },
                child: Icon(Icons.edit),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
    required this.color,
    required this.iconRight,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;
  final Color color;
  final IconData iconRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: color,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            // SvgPicture.asset(
            //   icon,
            //   color: kPrimaryColor,
            //   width: 22,
            // ),
            Icon(icon),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            // Icon(Icons.arrow_forward_ios),
            Icon(iconRight),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('InTime')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    final User user = _auth.currentUser;
    final username = user.displayName;
    final Future<Null> _listUser = FirebaseFirestore.instance
        .collection('InTime')
        .where('personName', isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // var i = 0;
      querySnapshot.docs.forEach((doc) {
        // print(doc['entryTime'].toString());
        // print(doc['personName']);

        // // print(doc["full_name"]);
        // var x = Service(doc["full_name"],
        //     'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png');
        // _services.insert(i, x);
        // print(_services);
      });
    });
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(height: 20),
            Text(
              _auth.currentUser.displayName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            ProfileMenu(
              text: "Available Books",
              icon: Icons.book,
              press: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllAvailableBooks(),
                  ),
                ),
              },
              color: Colors.black,
              iconRight: Icons.arrow_forward_ios,
            ),
            ProfileMenu(
              text: "Issued Books",
              icon: Icons.book_online_outlined,
              press: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllIssuedBooks(),
                  ),
                ),
              },
              color: Colors.black,
              iconRight: Icons.arrow_forward_ios,
            ),
            ProfileMenu(
              text: "Add Book",
              icon: Icons.book_online_rounded,
              press: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBook(),
                  ),
                ),
              },
              color: Colors.red,
              iconRight: Icons.add_circle,
            ),
            // ProfileMenu(
            //   text: "My Activity",
            //   icon: Icons.local_activity_rounded,
            //   press: () => {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => GetUserActivity(),
            //       ),
            //     ),
            //   },
            //   color: Colors.orangeAccent,
            //   iconRight: Icons.arrow_forward_ios_rounded,
            // ),
            // ProfileMenu(
            //   text: "My Account",
            //   icon: Icons.verified_user_rounded,
            //   press: () => {},
            // ),
            // ProfileMenu(
            //   text: "Notifications",
            //   icon: Icons.notification_add_rounded,
            //   press: () {},
            // ),
            // ProfileMenu(
            //   text: "Settings",
            //   icon: Icons.settings_accessibility_rounded,
            //   press: () {},
            // ),
            // ProfileMenu(
            //   text: "My Issued Books",
            //   icon: Icons.book_sharp,
            //   press: () => {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => GetUserIssuedBooks(),
            //       ),
            //     ),
            //   },
            //   color: Colors.orangeAccent,
            //   iconRight: Icons.arrow_forward_ios_rounded,
            // ),
            // ProfileMenu(
            //   text: "Report Query",
            //   icon: Icons.question_mark_rounded,
            //   press: () {},
            //   color: Colors.orangeAccent,
            //   iconRight: Icons.arrow_forward_ios_rounded,
            // ),

            // ProfileMenu(
            //   text: "Log Out",
            //   icon: Icons.logout_rounded,
            //   press: () {},
            // ),
            // RichText(
            //   text: TextSpan(
            //     style: Theme.of(context).textTheme.headline5,
            //     children: [
            //       TextSpan(
            //         text: "InTime Records",
            //       ),
            //       TextSpan(
            //         text: "....",
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Body(),
      // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}

// import 'package:flutter/material.dart';

// import 'components/body.dart';

class UserTab extends StatefulWidget {
  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  int _currentIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Body(),
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

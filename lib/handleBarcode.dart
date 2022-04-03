import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/index.dart';
import 'package:loginapp/writeFireStore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';

// void main() => runApp(const MaterialApp(home: MyHome()));

// class MyHome extends StatelessWidget {
//   const MyHome({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flutter Demo Home Page')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => const QRViewExample(),
//             ));
//           },
//           child: const Text('qrView'),
//         ),
//       ),
//     );
//   }
// }

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  int flag = 0;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  CollectionReference users = FirebaseFirestore.instance.collection('InTime');
  markPresence() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    DateTime now = DateTime.now();

    final User user = _auth.currentUser;
    final username = user.displayName;
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'personName': username, // John Doe
          'entryTime': now, // Stokes and Sons
          // 'age': age // 42
        })
        .then(
          (value) => {
            print("User Added"),
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Index(),
              ),
              (route) => false,
            ),
          },
        )
        .catchError((error) => print("Failed to add user: $error"));
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void initState() {
    // this.addUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text(
                      'Scan QR Code',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: FlatButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            // builder: (context, snapshot) {
                            //   return Text('Flash: ${snapshot.data}');
                            // },
                            builder: (context, snapshot) {
                              return snapshot.data == true
                                  ? Icon(
                                      Icons.flash_off_rounded,
                                    )
                                  : Icon(
                                      Icons.flash_on_rounded,
                                    );
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: FlatButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: Icon(
                            Icons.cameraswitch_rounded,
                          ),
                          // child: FutureBuilder(
                          //   future: controller?.getCameraInfo(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.data != null) {
                          //       return Text(
                          //           'Camera facing ${describeEnum(snapshot.data!)}');
                          //     } else {
                          //       return const Text('loading');
                          //     }
                          //   },
                          // ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: FlatButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                            // markPresence();
                          },
                          // child: const Text('pause',
                          //     style: TextStyle(fontSize: 20)),
                          child: Icon(
                            Icons.pause_circle_rounded,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: FlatButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          // child: const Text('resume',
                          //     style: TextStyle(fontSize: 20)),
                          child: Icon(
                            Icons.play_arrow_rounded,
                          ),
                        ),
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.pauseCamera();
                  //           markPresence();
                  //         },
                  //         // child: const Text('pause',
                  //         //     style: TextStyle(fontSize: 20)),
                  //         child: Icon(
                  //           Icons.pause_circle_rounded,
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(8),
                  //       child: ElevatedButton(
                  //         onPressed: () async {
                  //           await controller?.resumeCamera();
                  //         },
                  //         // child: const Text('resume',
                  //         //     style: TextStyle(fontSize: 20)),
                  //         child: Icon(
                  //           Icons.play_arrow_rounded,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(
        () {
          //entire procedure to mark boolean true or false
          result = scanData;
          if (flag == 0) {
            markPresence();
            flag = 1;
          }
        },
      );
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

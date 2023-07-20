import 'dart:convert';
import 'dart:typed_data';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_app/screens/order_detail.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String? order_id;
  bool cameraPermissionGranted = true;

  @override
  void initState() {
    super.initState();

    permissionHandler();
  }

  void permissionHandler() async {
    await Permission.camera.request();
    var permissionStatus = await Permission.camera.status;
    if (permissionStatus == PermissionStatus.granted) {
      setState(() {
        cameraPermissionGranted = true;
      });
    } else {
      cameraPermissionGranted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.brown,
        title: Text("Scan QR"),
      ),
      body: Stack(
        children: <Widget>[
          cameraPermissionGranted
              ? MobileScanner(
                  fit: BoxFit.cover,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    // final Uint8List? image = capture.image;
                    print("barcodes ${barcodes}");
                    for (final barcode in barcodes) {
                      print('Barcode found! ${barcode?.rawValue}');

                      Map<String, dynamic> data =
                          jsonDecode(barcode?.rawValue as String);
                      print("Scanned data: ${data}");
                      if (data.containsKey("order_id")) {
                        setState(() {
                          order_id = data["order_id"];
                        });
                      }
                    }
                  },
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Camera permission not granted"),
                    ElevatedButton(
                        onPressed: () {
                          permissionHandler();
                        },
                        child: Text("Grant Permission"))
                  ],
                )),
          if (order_id != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderDetail(
                              id: order_id,
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Order details",
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 30,
                        ),
                      ],
                    ),
                  )),
            )
        ],
      ),
    );
  }
}

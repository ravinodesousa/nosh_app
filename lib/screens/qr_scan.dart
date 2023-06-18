import 'dart:convert';
import 'dart:typed_data';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nosh_app/screens/order_detail.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:nosh_app/config/palette.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  String? order_id;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.brown,
        title: Text("Scan QR"),
      ),
      body: Stack(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
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
          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null)
          //           Text(
          //               'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         else
          //           const Text('Scan a code'),
          //         //         // Row(
          //         //         //   mainAxisAlignment: MainAxisAlignment.center,
          //         //         //   crossAxisAlignment: CrossAxisAlignment.center,
          //         //         //   children: <Widget>[
          //         //         //     // Container(
          //         //         //     //   margin: const EdgeInsets.all(8),
          //         //         //     //   child: ElevatedButton(
          //         //         //     //       onPressed: () async {
          //         //         //     //         await controller?.toggleFlash();
          //         //         //     //         setState(() {});
          //         //         //     //       },
          //         //         //     //       child: FutureBuilder(
          //         //         //     //         future: controller?.getFlashStatus(),
          //         //         //     //         builder: (context, snapshot) {
          //         //         //     //           return Text('Flash: ${snapshot.data}');
          //         //         //     //         },
          //         //         //     //       )),
          //         //         //     // ),
          //         //         //     // Container(
          //         //         //     //   margin: const EdgeInsets.all(8),
          //         //         //     //   child: ElevatedButton(
          //         //         //     //       onPressed: () async {
          //         //         //     //         await controller?.flipCamera();
          //         //         //     //         setState(() {});
          //         //         //     //       },
          //         //         //     //       child: FutureBuilder(
          //         //         //     //         future: controller?.getCameraInfo(),
          //         //         //     //         builder: (context, snapshot) {
          //         //         //     //           if (snapshot.data != null) {
          //         //         //     //             return Text(
          //         //         //     //                 'Camera facing ${describeEnum(snapshot.data!)}');
          //         //         //     //           } else {
          //         //         //     //             return const Text('loading');
          //         //         //     //           }
          //         //         //     //         },
          //         //         //     //       )),
          //         //         //     // )
          //         //         //   ],
          //         //         // ),
          //         //         // Row(
          //         //         //   mainAxisAlignment: MainAxisAlignment.center,
          //         //         //   crossAxisAlignment: CrossAxisAlignment.center,
          //         //         //   children: <Widget>[
          //         //         //     Container(
          //         //         //       margin: const EdgeInsets.all(8),
          //         //         //       child: ElevatedButton(
          //         //         //         onPressed: () async {
          //         //         //           await controller?.pauseCamera();
          //         //         //         },
          //         //         //         child: const Text('pause',
          //         //         //             style: TextStyle(fontSize: 20)),
          //         //         //       ),
          //         //         //     ),
          //         //         //     Container(
          //         //         //       margin: const EdgeInsets.all(8),
          //         //         //       child: ElevatedButton(
          //         //         //         onPressed: () async {
          //         //         //           await controller?.resumeCamera();
          //         //         //         },
          //         //         //         child: const Text('resume',
          //         //         //             style: TextStyle(fontSize: 20)),
          //         //         //       ),
          //         //         //     )
          //         //         //   ],
          //         //         // ),
          //       ],
          //     ),
          //   ),
          // )
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
      print(scanData);

      if (scanData != null) {
        Map<String, dynamic> data = jsonDecode(scanData.code as String);
        print("Scanned data: ${data}");
        if (data.containsKey("order_id")) {
          setState(() {
            order_id = data["order_id"];
          });
        }
      }
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

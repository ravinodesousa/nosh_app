import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        fit: BoxFit.cover,
        onDetect: (capture) {
          print(capture);
          // final List<Barcode> barcodes = capture.barcodes;
          // final Uint8List? image = capture.image;
          // for (final barcode in barcodes) {
          //   debugPrint('Barcode found! ${barcode.rawValue}');
          // }
        },
      ),
    );
  }
}

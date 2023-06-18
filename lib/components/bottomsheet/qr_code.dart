import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeBottomSheet extends StatefulWidget {
  const QrCodeBottomSheet({super.key, required this.id});
  final String? id;

  @override
  State<QrCodeBottomSheet> createState() => _QrCodeBottomSheetState();
}

class _QrCodeBottomSheetState extends State<QrCodeBottomSheet> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {}

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      color: Colors.black54,
      opacity: 0.7,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Colors.blue,
        strokeWidth: 5.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, size: 40),
                  )),
            ),
            QrImageView(
              data: jsonEncode({"order_id": widget.id ?? ''}),
              version: QrVersions.auto,
              size: 300.0,
            ),
          ],
        ),
      ),
    );
  }
}

typedef Callback = void Function(BuildContext context);

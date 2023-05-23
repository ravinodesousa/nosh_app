import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

Future<String> uploadFile(File file) async {
  final fileName = basename(file.path);
  final destination = 'files/$fileName';

  try {
    final _firebaseStorage = FirebaseStorage.instance;

    var snapshot = await _firebaseStorage
        .ref(fileName)
        .child(destination)
        .putFile(file)
        .snapshot;

    var downloadUrl = await snapshot.ref.getDownloadURL();

    print(downloadUrl);

    return downloadUrl;
  } catch (e) {
    print('error occured ${e}');
    return '';
  }
}

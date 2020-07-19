import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitfunction/screens/loginPage.dart';

import 'adapter.dart';

class Post {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  Firestore userModel ;
  static String captions;
  String urlPost;
  String timestamp;

//  // File file;
//  Post({this.captions, this.urlPost, this.timestap});

  Future<String> uploadImageToStorage(File file) async {
    Random random = Random();
    int i = random.nextInt(100000);
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference reference = storage.ref().child('posts/postss$i');

    StorageUploadTask uploadTask = reference.putFile(file);
    String urlPhoto = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(urlPhoto);
    uploadToFireStore(urlPhoto);
    return urlPhoto;
  }

  Future<void> uploadToFireStore(String urlPhoto) async {
//    Firestore _fireStore = Firestore.instance;
    userModel = Firestore.instance;
//    FirebaseAuth auth = FirebaseAuth.instance;
//    FirebaseUser user = await auth.currentUser();
    Map<String, dynamic> map = Map();
    map['caption'] = captions;
    map['urlPhoto'] = urlPhoto;
    map['userID'] = currentUser.uid;
    map['timestamp']=timestamp;

    await userModel
        .collection('Posts')
        .document()
        .setData(map)
        .then((value) => print('upload success'));
  }
}

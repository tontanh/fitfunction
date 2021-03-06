import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitfunction/models/adapter.dart';
import 'package:flutter/cupertino.dart';

class Users {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final Firestore userModel = Firestore.instance;
  String _name;
  String _surname;
  String _email;
  String _password;
  String _birthDay;
  String _gender;
  String _urlProfile='https://firebasestorage.googleapis.com/v0/b/fitfunction-e5947.appspot.com/o/profile%20.png?alt=media&token=9a6e3f28-c830-4add-bb3d-fca840d9fef7';
  String _urlCover='https://firebasestorage.googleapis.com/v0/b/fitfunction-e5947.appspot.com/o/cover.png?alt=media&token=5468272f-7c78-4593-9db0-47ab97fdc971';
  String _relationship;
  String _caption;
  String _level;
  String _weight;
  String _height;

  Users();

  String get weight => _weight;

  set weight(String value) {
    _weight = value;
  }

  String get caption => _caption;

  set caption(String value) {
    _caption = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get surname => _surname;

  set surname(String value) {
    _surname = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get birthDay => _birthDay;

  set birthDay(String value) {
    _birthDay = value;
  }

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
  }

  String get urlProfile => _urlProfile;

  set urlProfile(String value) {
    _urlProfile = value;
  }

  String get urlCover => _urlCover;

  set urlCover(String value) {
    _urlCover = value;
  }

  String get relationship => _relationship;

  set relationship(String value) {
    _relationship = value;
  }

  String get level => _level;

  set level(String value) {
    _level = value;
  }
  String get height => _height;

  set height(String value) {
    _height = value;
  }

  Future<FirebaseUser> createUserWithEmail() async {
    try {
      FirebaseUser user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      final String uid = user.uid;
      Map<String, dynamic> maps = Map();
      maps['name'] = name;
      maps['surname'] = surname;
      maps['gender'] = gender;
      maps['birthDay'] = birthDay;
      maps['email'] = email;
      maps['password'] = password;
      maps['urlProfile'] = urlProfile;
      maps['urlCover'] = urlCover;
      maps['relationship'] = relationship;
      maps['caption'] = caption;
      maps['level'] = level;
      maps['weight']=weight;
      maps['height']=height;
      await userModel.collection('Users').document(uid).setData(maps);
      return user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future<void> updateProfile() async {
    auth.currentUser();
    Map<String, dynamic> maps = Map();
    maps['name'] = name;
    maps['surname'] = surname;
    maps['caption'] = caption;
    // maps['gender'] = gender;
    maps['birthDay'] = birthDay;
    // maps['email'] = email;
    // maps['password'] = password;
    // maps['urlProfile'] = urlProfile;
    // maps['urlCover'] = urlCover;
    // maps['relationship'] = relationship;
    maps['weight']=weight;
    maps['height']=height;
    await userModel
        .collection('Users')
        .document(currentUser.uid)
        .updateData(maps);
  }

  Future<void> uploadImageToStorage(File file) async {
    Random random = Random();
    int i = random.nextInt(100000);
    final StorageReference storageReference =
        FirebaseStorage().ref().child('covers/cover_$i');
    final StorageUploadTask uploadTask = storageReference.putFile(file);

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    updateCover(url);
    //urlCover=url;
  }

  Future<void> updateCover(String url) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    await userModel.collection('Users').document(firebaseUser.uid).updateData({
      'urlCover': url,
    });
  }


}

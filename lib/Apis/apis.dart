

import 'dart:developer';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Model/product.dart';
import 'package:e_commerce/Model/slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis{

  //for access firebase cloud store
  static   FirebaseFirestore firestore=FirebaseFirestore.instance;

  //for access firebase storage
  static FirebaseStorage firebaseStorage=FirebaseStorage.instance;


  static Future<void> sendSliderImage(File file) async {
    //getting image file extension
    final ext=file.path.split('.').last;

    //storage file ref with path
    final ref=firebaseStorage.ref().child('slider/${DateTime.now().millisecondsSinceEpoch}.$ext');
    //uploading image
    ref.putFile(file,SettableMetadata(contentType: 'slider/$ext')).then((p0) async {
      log('Data transferred: ${p0.bytesTransferred/1000} kb');
      // log('message');
      //upload image in firestore
      final imageUrl= await ref.getDownloadURL();
      //message sending time

      final time=DateTime.now().microsecondsSinceEpoch.toString();
      final Cursol_Slider slider=Cursol_Slider(photo: imageUrl);
      final ref1=firestore.collection('slider');
      await ref1.doc(time).set(slider.toJson());
    });



  }
  static Future<void> sendProductAndImage(File file,String pro_name,String pro_description,String pro_price) async {
    //getting image file extension
    final ext=file.path.split('.').last;

    //storage file ref with path
    final ref=firebaseStorage.ref().child('product/${DateTime.now().millisecondsSinceEpoch}.$ext');
    //uploading image
    ref.putFile(file,SettableMetadata(contentType: 'product/$ext')).then((p0) async {
      log('Data transferred: ${p0.bytesTransferred/1000} kb');
      // log('message');
      //upload image in firestore
      final imageUrl= await ref.getDownloadURL();
      //message sending time

      final time=DateTime.now().microsecondsSinceEpoch.toString();
      Product product=Product(proPrice: pro_price, proImage: imageUrl, proDescription: pro_description, proName: pro_name);
      final ref1=firestore.collection('product');
      await ref1.doc(time).set(product.toJson());
    });



  }

  //for getting all messages of a specific conversion from firestore database
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllSlider(){
    return firestore.collection('slider').snapshots();
  }

  //for getting all messages of a specific conversion from firestore database
  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllProduct(){
    return firestore.collection('product')
        .snapshots();
  }

  //for getting all cart item
  static Stream<QuerySnapshot<Map<String,dynamic>>> getCartItem() {
    //FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").snapshots(),
    return firestore.collection('users-cart-items')
        .doc(FirebaseAuth.instance.currentUser!.email).collection("items")
        .snapshots();
  }

  //for getting all favourite
  static Stream<QuerySnapshot<Map<String,dynamic>>> getFavoriteItem() {
    //FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").snapshots(),
    return firestore.collection('users-favourite-items')
        .doc(FirebaseAuth.instance.currentUser!.email).collection("items")
        .snapshots();
  }
}
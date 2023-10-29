import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Apis/apis.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Model/cart _model.dart';


class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Cart_model> cart=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("My Cart Item"),
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder (
            stream:  Apis.getCartItem(),
            builder: (context,snapshot){
              final data=snapshot.data!.docs;
              cart=data?.map((e) => Cart_model.fromJson(e.data())).toList()??[];

              return ListView.builder(
                // itemCount: snapshot.data!.docs.length,
                itemCount: cart.length,
                  itemBuilder:(context,index){
                    DocumentSnapshot _docSnap=snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        leading: Text('${cart[index].name}'),
                        title: Text("${cart[index].price}"),
                        trailing: GestureDetector(
                          child: CircleAvatar(
                            child: Icon(Icons.remove_circle),
                          ),
                          
                          onTap: (){
                            FirebaseFirestore.instance.collection("users-cart-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").doc(_docSnap.id).delete();
                          },
                        ),
                      ),
                    );
                  }
              );
            },
          ),
        ),
      ),
    );
  }
}

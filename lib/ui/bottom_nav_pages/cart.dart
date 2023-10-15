import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Apis/apis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
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
              if(snapshot.hasError){
                return Center(child: Text("Something went wrong"),);
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder:(_,index){
                    DocumentSnapshot _docSnap=snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        leading: Text(_docSnap['name']),
                        title: Text("৳ ${_docSnap['price']}"),
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

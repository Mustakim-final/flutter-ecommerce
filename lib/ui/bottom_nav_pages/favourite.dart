import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Apis/apis.dart';


class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("My Favourite Items"),
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder (
            stream:  Apis.getFavoriteItem(),
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
                            FirebaseFirestore.instance.collection("users-favourite-items").doc(FirebaseAuth.instance.currentUser!.email).collection("items").doc(_docSnap.id).delete();
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
    );;
  }
}

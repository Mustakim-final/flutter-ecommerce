import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Apis/dialogs.dart';
import 'package:e_commerce/const/app_calors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {

  var product;
  ProductDetails(this.product, {Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  addToCart() async{
    final FirebaseAuth _auth=FirebaseAuth.instance;
    var currentUser=_auth.currentUser;
    CollectionReference ref=FirebaseFirestore.instance.collection("users-cart-items");
    return ref.doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
    "name":widget.product["product-name"],
      "price":widget.product["product-price"],
      "image":widget.product["product-image"],
    }).then((msg){Dialogs.showSnackbar(context, "Add to cart");});
  }

  addToFavourite() async{
    final FirebaseAuth _auth=FirebaseAuth.instance;
    var currentUser=_auth.currentUser;
    CollectionReference ref=FirebaseFirestore.instance.collection("users-favourite-items");
    return ref.doc(currentUser!.email)
        .collection("items")
        .doc()
        .set({
      "name":widget.product["product-name"],
      "price":widget.product["product-price"],
      "image":widget.product["product-image"],
    }).then((msg){Dialogs.showSnackbar(context, "Add to favourite");});
  }
  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading:  Padding(
          padding:  EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          StreamBuilder<Object>(
            stream: FirebaseFirestore.instance.collection("users-favourite-items").doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items").where("name",isEqualTo: widget.product['product-name']).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.data==null){
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: AppColors.deep_orange,
                  child: IconButton(
                    onPressed: ()=> snapshot.data.docs.length==0?addToFavourite():Dialogs.showSnackbar(context, "Already add"),
                    icon: snapshot.data.docs.length==0?
                    Icon(Icons.favorite_outline,color: Colors.white,):
                        Icon(Icons.favorite,color: Colors.white,)
                  ),
                ),
              );
            }
          )
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.only(left: 12,right: 12,top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: mq.height*.3,
                width: mq.width*.6,
                child: Image.network(widget.product['product-image']),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0,top: 10.0),
              child: Text(widget.product['product-name'],style: TextStyle(fontSize: 22),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 60.0,top: 10.0),
              child: Text("৳ ${widget.product['product-price'].toString()}",style: TextStyle(fontSize: 22),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 60.0,top: 10.0),
              child: Text(widget.product['product-description'],style: TextStyle(fontSize: 22),),
            ),

            Divider(),

            Center(
              child: SizedBox(
                height: mq.height*.06,
                width: mq.width*.8,
                child: ElevatedButton(
                    onPressed: (){addToCart();},
                    child: Text("Add to cart"),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.deep_orange,
                    elevation: 3
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

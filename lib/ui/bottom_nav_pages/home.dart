

import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce/Apis/apis.dart';
import 'package:e_commerce/Model/product.dart';
import 'package:e_commerce/const/app_calors.dart';
import 'package:e_commerce/ui/product_details_screen.dart';
import 'package:e_commerce/ui/serach_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> cursolImage=[];
  // //final list=[];
  var dotPosition=0;
  // fetchCarsulImage()async{
  //   var firestoreInstance=FirebaseFirestore.instance;
  //   QuerySnapshot qn=await firestoreInstance.collection("slider").get();
  //
  //   setState(() {
  //     for(int i=0;i<qn.docs.length;i++){
  //       cursolImage.add(qn.docs[i]["photo"]);
  //       print(qn.docs[i]["photo"]);
  //       log("Data:${qn.docs[i]["photo"]}");
  //     }
  //   });
  //
  //   return qn.docs;
  // }

  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  List<Product> products=[];

  fetchProducts()async{
    QuerySnapshot qn= await _firestoreInstance.collection("product").get();
    setState(() {
      for(int i=0;i<qn.docs.length;i++){
        _products.add({
          "product-name":qn.docs[i]["pro_name"],
          "product-description":qn.docs[i]["pro_description"],
          "product-image":qn.docs[i]["pro_image"],
          "product-price":qn.docs[i]["pro_price"],
        });
      }
    });

    return qn.docs;
  }



  late Stream<QuerySnapshot> imageStrem;
  int currentSliderIndex=1;
  CarouselController carouselController=CarouselController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
    var firebase=FirebaseFirestore.instance;
    imageStrem=firebase.collection("slider").snapshots();

  }




  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Scaffold(

      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text("E-Commerce",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w500),),
              SizedBox(height: mq.height*.03,),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: BorderSide(color: Colors.blue)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          hintText: "Search products here",
                          hintStyle: TextStyle(fontSize: 15)
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));},
                      child: Container(
                        height: mq.height*.07,
                        width: mq.width*.2,
                        color: AppColors.deep_orange,
                        child: Center(
                          child: Icon(Icons.search,color: Colors.white,size: mq.height*.04,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: mq.height*.03,),
              SizedBox(
                height: mq.height*.2,
                width: double.infinity,
                child: StreamBuilder<QuerySnapshot>(
                  stream: imageStrem,
                  builder: (_,snapshot){
                    if(snapshot.hasData && snapshot.data!.docs.length>1){
                      final data=snapshot.data?.docs;
                      for(var i in data! ){
                        log('Data: ${jsonEncode(i.data())}');
                      }
                      return CarouselSlider.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_,index,__){
                            DocumentSnapshot sliderImage=snapshot.data!.docs[index];
                            return Image.network(
                                sliderImage['photo'],
                              fit: BoxFit.contain,
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            onPageChanged: (index,_){
                              setState(() {
                                currentSliderIndex=index;
                              });
                            }
                          )
                      );
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: mq.height*.03,),
              DotsIndicator(
                dotsCount: currentSliderIndex+1,
                position: dotPosition,
                decorator: DotsDecorator(
                    activeColor: AppColors.deep_orange,
                    color: AppColors.deep_orange.withOpacity(0.5),
                    spacing: EdgeInsets.all(2),
                    activeSize: Size(8,8),
                    size: Size(6,6)
                ),
              ),
              SizedBox(height: mq.height*.03,),

              Expanded(
                  child: StreamBuilder(
                    stream: Apis.getAllProduct(),
                    builder: (context,snapshot){
                      final data=snapshot.data!.docs;
                      products=data.map((e) => Product.fromJson(e.data())).toList()??[];
                      return GridView.builder(
                        scrollDirection: Axis.horizontal,

                        itemCount: products.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1
                          ), 
                          itemBuilder: (context,index){
                            return Card(
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 2,
                                    child: Container(
                                       child: Image.network(products[index].proImage),
                                    ),
                                  ),
                                  Text('${products[index].proName}')
                                ],
                              ),
                            );
                          }
                      );
                    },
                  )
              )

            ],
          ),
        )
      ),
    );
  }
}



// GridView.builder(
// scrollDirection: Axis.horizontal,
// itemCount: _products.length,
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 2,
// childAspectRatio: 1,
// ),
// itemBuilder: (_,index){
// return GestureDetector(
// onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(_products[index])));} ,
// child: Card(
// elevation: 3,
// child: Column(
// children: [
// AspectRatio(
// aspectRatio: 2,
// child: Container(
// child: Image.network(_products[index]["product-image"]),
// ),
//
// ),
// Text("${_products[index]["product-name"]}"),
// Text("${_products[index]["product-price"].toString()}"),
// ],
// ),
// ),
// );
// }
// )

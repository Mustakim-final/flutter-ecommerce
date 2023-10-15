
import 'dart:developer';
import 'dart:io';

import 'package:e_commerce/Apis/apis.dart';
import 'package:e_commerce/Model/slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Cursol_Slider extends StatefulWidget {
  const Cursol_Slider({Key? key}) : super(key: key);

  @override
  State<Cursol_Slider> createState() => _Cursol_SliderState();
}

class _Cursol_SliderState extends State<Cursol_Slider> {

  List<Cursol_Slider> list=[];
  bool isScrolling=false;
  String? _image;
  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 2,right: 2),
                  child: Container(
                    height: mq.height*.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      border: Border.all(width: 2)
                    ),

                    child: Row(
                      children: [
                        _image==null?
                        IconButton(
                          iconSize: mq.height*.1,
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image.
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                            if(image!=null){
                              log('Image path: ${image.path} -- MimeType: ${image.mimeType}');

                              setState(() {
                                _image=image.path;
                              });
                            }
                          },
                          icon: Icon(Icons.image),
                          color: Colors.blueAccent,
                        ):
                          ClipRRect(
                          child: Image.file(
                            File(_image!),
                            height: mq.height*0.2,
                            width: mq.height*.2,
                            fit: BoxFit.fill,
                          ),
                        ),
                          SizedBox(width: mq.width*.3,),
                          ElevatedButton(
                            onPressed: (){
                              Apis.sendSliderImage(File(_image!));
                              _image="";
                            },
                            child: Text("Submit")
                        )
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: Apis.getAllSlider(),
                    builder: (context,snapshot){
                    final data=snapshot.data?.docs;
                    //list=data?.map((e) => Cursol_Slider.fromJson(e.data())).toList() ?? [];
                    return Text("");
                    }
                )
              ],
            ),
          ),
        )
    );
  }
}


// if(snapshot.hasData){
//   final data=snapshot.data?.docs;
//   for(var i in data!){
//     log('Data: ${jsonEncode(i.data())}');
//   }
// }

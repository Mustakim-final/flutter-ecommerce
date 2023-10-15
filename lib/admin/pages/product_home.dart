import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:e_commerce/Apis/apis.dart';
import 'package:e_commerce/Apis/dialogs.dart';
import 'package:e_commerce/const/app_calors.dart';
import 'package:e_commerce/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Product_Home extends StatefulWidget {
  const Product_Home({Key? key}) : super(key: key);

  @override
  State<Product_Home> createState() => _Product_HomeState();
}

class _Product_HomeState extends State<Product_Home> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String? _image;


  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Product Add Form",style: TextStyle(fontSize: 23),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Select Image: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
                    _image==null?
                    IconButton(
                      iconSize: 50,
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
                    ):
                    ClipRRect(
                      child: Image.file(
                        File(_image!),
                        height: mq.height*0.2,
                        width: mq.height*.2,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Product Name',
                      labelText: 'Name'

                  ),
                ),
              ),
              SizedBox(height: mq.height*.03,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Product Description',
                      labelText: 'Description'

                  ),
                ),
              ),
              SizedBox(height: mq.height*.03,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _priceController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Product Price',
                    labelText: 'Price'

                  ),
                ),
              ),

              SizedBox(height: mq.height*.03,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: customButton(
                    "Submit",
                    (){
                      Apis.sendProductAndImage(File(_image!), _productNameController.text.trim(),
                          _descriptionController.text.trim(), _priceController.text.trim()).then((msg){
                            Dialogs.showSnackbar(context, "Product upload successfully");
                      });

                      _image="";
                    },
                    context
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}

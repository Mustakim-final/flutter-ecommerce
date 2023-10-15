import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/const/app_calors.dart';
import 'package:e_commerce/ui/bottom_nav_controller.dart';
import 'package:e_commerce/widgets/custom_button.dart';
import 'package:e_commerce/widgets/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender=["Male","Female","Other"];

  Future<void> _selectedDateFormPicker(BuildContext context) async {
    final DateTime? picked=await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year-20),
        firstDate: DateTime(DateTime.now().year-30),
        lastDate: DateTime(DateTime.now().year),
    );

    if(picked!=null){
      setState(() {
        _dobController.text="${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  sendUserData(){
    final FirebaseAuth _auth=FirebaseAuth.instance;
    var currentUser=_auth.currentUser;
    final ref=FirebaseFirestore.instance.collection("users-form-data");
    return ref.doc(currentUser!.email).set({
      "name":_nameController.text,
      "phone":_phoneController.text,
      "dob":_dobController.text,
      "gender":_genderController.text,
      "age":_ageController.text
    }).then((value) => 
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavController()))).catchError((error)=>Fluttertoast.showToast(msg: error));
  }

  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height*.03,),
                const Text("Submit the form to continue",style: TextStyle(fontSize: 20,color: AppColors.deep_orange),),
                const Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFBBBBBB),
                  ),
                ),

                SizedBox(height: mq.height*.03,),
                myTextField('enter your name', TextInputType.text, _nameController),
                myTextField('enter your phone number', TextInputType.text, _phoneController),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "date of birth",
                    suffixIcon: IconButton(
                      onPressed: (){
                        _selectedDateFormPicker(context);
                      },
                      icon: Icon(Icons.calendar_today_outlined),
                    )
                  ),
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'choose your gender',
                    prefixIcon: DropdownButton<String>(
                      items: gender.map((String value){
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: (){
                            setState(() {
                              _genderController.text=value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_){},
                    )
                  ),
                ),

                myTextField("enter your age",TextInputType.number,_ageController),
                SizedBox(height: mq.height*.03,),
                customButton("Continue", (){
                  sendUserData();
                }, context)
              ],
            ),
          ),
        )
      ),
    );
  }
}

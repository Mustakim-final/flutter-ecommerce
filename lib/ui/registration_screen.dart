import 'dart:developer';

import 'package:e_commerce/const/app_calors.dart';
import 'package:e_commerce/ui/login_screen.dart';
import 'package:e_commerce/ui/user_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/custom_button.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  TextEditingController _eamilController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  bool _obscureText = true;

   void signUp() async {
     try{
       FirebaseAuth firebaseAuth=FirebaseAuth.instance;
       final User? user=(await firebaseAuth.createUserWithEmailAndPassword(email: _eamilController.text.trim(), password: _passwordController.text.trim())).user;

       if(user!.uid.isNotEmpty){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserForm()));
       }else{
         Fluttertoast.showToast(msg: "Something is Wrong");
       }
     }on FirebaseAuthException catch(e){
       if(e.code=='weak-password'){
         Fluttertoast.showToast(msg: "The password provided is too weak.");
       }else if (e.code == 'email-already-in-use') {
         Fluttertoast.showToast(msg: "The account already exists for that email.");
       }
     }catch(e){
       log('Auth Exception:$e');
     }
   }

  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: mq.height*.2,
              width: mq.width*.5,
              child: Padding(
                padding: EdgeInsets.only(left: mq.width*.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.light,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(mq.height*.03),
                          topLeft: Radius.circular(mq.height*.03)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: mq.height*.03,),
                          Text("Welcome Back",style: TextStyle(fontSize: 22,color: AppColors.deep_orange),),
                          Text(
                            "Glad to see you back my buddy.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                          SizedBox(height: mq.height*.03,),

                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.deep_orange,
                                    borderRadius: BorderRadius.circular(2)
                                ),
                                child: Center(child: Icon(Icons.email_outlined,color: Colors.white,size: 22,)),
                              ),
                              SizedBox(width: mq.width*.03,),
                              Expanded(
                                child: TextField(
                                  controller: _eamilController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF414041)
                                      ),
                                      labelText: 'Email'
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: mq.height*.03,),

                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: AppColors.deep_orange,
                                    borderRadius: BorderRadius.circular(2)
                                ),
                                child: Center(child: Icon(Icons.lock_outline,color: Colors.white,size: 22,)),
                              ),
                              SizedBox(width: mq.width*.03,),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF414041)
                                      ),
                                      labelText: 'Password',
                                      suffixIcon: _obscureText==true?
                                      IconButton(
                                          onPressed: (){
                                            _obscureText=false;
                                          },
                                          icon: Icon(Icons.remove_red_eye)
                                      ):IconButton(
                                          onPressed: (){
                                            setState(() {
                                              _obscureText=true;
                                            });
                                          },
                                          icon: Icon(Icons.visibility_off)
                                      )

                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: mq.height*.03,),

                          //elevated button

                          customButton("Sign Up",(){
                            signUp();
                          },context),

                          SizedBox(height: mq.height*.05,),
                          Wrap(
                            children: [
                              const Text(
                                "Have an account?",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFBBBBBB),
                                ),
                              ),

                              GestureDetector(
                                child: Text("Sign In",style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.deep_orange
                                ),),

                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                },
                              )
                            ],
                          )
                        ],
                      ),

                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
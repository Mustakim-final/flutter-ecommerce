import 'dart:async';
import 'dart:developer';

import 'package:e_commerce/const/app_calors.dart';
import 'package:e_commerce/ui/bottom_nav_controller.dart';
import 'package:e_commerce/ui/login_screen.dart';
import 'package:e_commerce/ui/user_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      //splash screen off
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.black,statusBarColor: Colors.black));

      if(FirebaseAuth.instance.currentUser!=null){
        log('\nUser: ${FirebaseAuth.instance.currentUser}');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavController()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      }

    });


    

  }
  @override
  Widget build(BuildContext context) {
    var mq=MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.deep_orange,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("E-Commerce",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 44),),
              SizedBox(height: mq.height*.05,),
              CircularProgressIndicator(color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }
}

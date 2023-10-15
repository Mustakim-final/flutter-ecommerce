
import 'package:e_commerce/const/app_calors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customButton(String buttonText,onPressed,BuildContext context){
  var mq=MediaQuery.of(context).size;
  return SizedBox(
    width: mq.width*1,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,fontSize: 18
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: AppColors.deep_orange,
        elevation: 3,
      ),
    ),
  );
}
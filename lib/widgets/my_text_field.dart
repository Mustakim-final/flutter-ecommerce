import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myTextField(String hintText,keyBordType,controller){
  return TextField(
    keyboardType: keyBordType,
    controller: controller,
    decoration: InputDecoration(hintText: hintText),
  );
}
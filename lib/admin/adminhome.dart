import 'package:e_commerce/admin/pages/cursol_slider.dart';
import 'package:e_commerce/admin/pages/product_home.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
class Admin_Home extends StatefulWidget {
  const Admin_Home({Key? key}) : super(key: key);

  @override
  State<Admin_Home> createState() => _Admin_HomeState();
}

class _Admin_HomeState extends State<Admin_Home> {
  var page=0;
  final pages=[Product_Home(),Cursol_Slider()];
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            index: 0,
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Colors.blue,
            animationCurve: Curves.easeInOutCirc,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index){
              setState(() {
                page=index;
              });
            },
            items: [
              Icon(Icons.home),
              Icon(Icons.slideshow)
            ],
          ),
          body: pages[page],
        )
    );
  }
}

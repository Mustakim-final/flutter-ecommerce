import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_commerce/ui/bottom_nav_pages/cart.dart';
import 'package:e_commerce/ui/bottom_nav_pages/favourite.dart';
import 'package:e_commerce/ui/bottom_nav_pages/home.dart';
import 'package:e_commerce/ui/bottom_nav_pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({Key? key}) : super(key: key);

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  var page=0;
  final pages=[Home(),Cart(),Favourite(),Profile()];

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

          items: const [
            Icon(Icons.home),
            Icon(Icons.shopping_cart),
            Icon(Icons.favorite),
            Icon(Icons.person),
          ],


        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          child: Icon(Icons.logout),
        ),

        body: pages[page],
      ),
    );
  }
}

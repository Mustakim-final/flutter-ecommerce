import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Apis/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController? _nameController;
  TextEditingController? _ageController;
  TextEditingController? _phoneController;
   setDataToTextField(data){
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
         children: [
           SizedBox(height: 60,),
           const Text("User Profile",style: TextStyle(fontSize: 20,),),
           SizedBox(height: 20,),
           TextFormField(
             controller: _nameController=TextEditingController(text: data['name']),
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: 'name',
               label: Text("name")
             ),
           ),
           SizedBox(height: 20,),
           TextFormField(
             controller: _ageController=TextEditingController(text: data['age']),
             decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 hintText: 'age',
                 label: Text("age")
             ),
           ),
           SizedBox(height: 20,),
           TextFormField(
             controller: _phoneController=TextEditingController(text: data['phone']),
               decoration: InputDecoration(
                   border: OutlineInputBorder(),
                   hintText: 'phone',
                   label: Text("phone")
               )
           ),
           SizedBox(height: 20,),
           ElevatedButton(onPressed: (){updateData();}, child: Text("Update"))
         ],
       ),
     );
   }

   updateData(){
     CollectionReference _ref=FirebaseFirestore.instance.collection("users-form-data");
     return _ref.doc(FirebaseAuth.instance.currentUser!.email).update(
       {
         "name":_nameController!.text.trim(),
         "age":_ageController!.text.trim(),
         "phone":_phoneController!.text.trim()
       }
     ).then((msg) {Dialogs.showSnackbar(context, "Profile Update Successfully");});
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users-form-data").doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
          builder: (context,snapshot){
            var data=snapshot.data;
            if(data==null){
              return Center(child: CircularProgressIndicator(),);
            }
            return setDataToTextField(data);
          },
        ),
      ),
    );
  }
}

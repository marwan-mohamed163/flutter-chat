import 'package:chat_app/dataBase/DataBaseHelper.dart';
import 'package:chat_app/modal/User.dart' as MyUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
   MyUser.User? CurrentUser;
   bool checkedLoggedInUser(){
     final firebaseUser = FirebaseAuth.instance.currentUser;
     if(firebaseUser!=null){
       getUserCollectionWithConverter().doc(firebaseUser.uid)
       .get()
       .then((retUser) =>{
     if(retUser.data()!=null){
       CurrentUser=retUser.data()
   }
   });
   }
   return firebaseUser!=null;
}
   void updateUser (MyUser.User? user){
     CurrentUser =user;
     notifyListeners();
   }

   void  signoutUser(){
     FirebaseAuth.instance.signOut();
   }
}


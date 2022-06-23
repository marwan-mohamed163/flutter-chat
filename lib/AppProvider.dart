import 'package:chat_app/modal/User.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
   User? CurrentUser;

   void updateUser (User? user){
     CurrentUser =user;
     notifyListeners();
   }
}


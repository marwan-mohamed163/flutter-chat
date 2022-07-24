import 'package:chat_app/AppProvider.dart';
import 'package:chat_app/addRoom/AddRoom.dart';
import 'package:chat_app/auth/LoginScreen.dart';
import 'package:chat_app/auth/RegisterationScreen.dart';
import 'package:chat_app/home/HomeScreen.dart';
import 'package:chat_app/roomsDetails/RoomsDetails.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyAplication());

}

class MyAplication extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>AppProvider(),
      builder:(context,Widget){
          final provider = Provider.of<AppProvider>(context);
          final isLoadingUser = provider.checkedLoggedInUser();
          return MaterialApp(
            routes: {
              RegisterationScreen.ROUTE_NAME:(context)=>RegisterationScreen(),
              LoginScreen.ROUTE_NAME:(context)=>LoginScreen(),
              HomeScreen.ROUTE_NAME:(context)=>HomeScreen(),
              AddRoom.ROUTE_NAME:(context)=>AddRoom(),
              RoomDetails.ROUTE_NAME:(context)=>RoomDetails()
            },
            initialRoute: isLoadingUser?HomeScreen.ROUTE_NAME:LoginScreen.ROUTE_NAME,
          );
      },
    );
  }
}

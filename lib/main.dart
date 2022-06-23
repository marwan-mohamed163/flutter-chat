import 'package:chat_app/AppProvider.dart';
import 'package:chat_app/auth/LoginScreen.dart';
import 'package:chat_app/auth/RegisterationScreen.dart';
import 'package:chat_app/home/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main()async {
  runApp(MyAplication());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyAplication extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context)=>AppProvider(),
      builder:(context,Widget){
          return MaterialApp(
            routes: {
              RegisterationScreen.ROUTE_NAME:(context)=>RegisterationScreen(),
              LoginScreen.ROUTE_NAME:(context)=>LoginScreen(),
              HomeScreen.ROUTE_NAME:(context)=>HomeScreen()
            },
            initialRoute: LoginScreen.ROUTE_NAME,
          );
      },
    );
  }
}

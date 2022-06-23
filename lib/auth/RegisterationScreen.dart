import 'package:chat_app/AppProvider.dart';
import 'package:chat_app/auth/LoginScreen.dart';
import 'package:chat_app/dataBase/DataBaseHelper.dart';
import 'package:chat_app/home/HomeScreen.dart';
import 'package:chat_app/modal/User.dart' as MyUser;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class RegisterationScreen extends StatefulWidget {
  RegisterationScreen({Key? key}) : super(key: key);
  static final String ROUTE_NAME ='register';

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _RegisterformKey = GlobalKey<FormState>();

  String userName = '';

  String password = '';

  String email = '' ;

  late AppProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Image.asset('assets/images/BackGround.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
          ),

        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar:AppBar(title: Center(child: Text('Create Account')),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body:Container(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(key: _RegisterformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        onChanged: (textValue){
                          userName = textValue;
                        },
                        decoration:InputDecoration(
                        labelText: 'User name',
                        floatingLabelBehavior:FloatingLabelBehavior.auto
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter user name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onChanged: (textValue){
                          email = textValue;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                        validator: (value) {
                        if (value==null || value.isEmpty){
                            return 'please enter email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onChanged: (textValue){
                          password =textValue;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }else if(value.length <6){
                            return 'password should at leaste 6 character';
                          }
                          return null;
                        },
                      ),
                      isLoading?Center(child: CircularProgressIndicator(),):
                      ElevatedButton(onPressed: ()=>createAccount(), child: Text('Create Account')),
                      TextButton(onPressed:(){ Navigator.pushReplacementNamed(context,LoginScreen.ROUTE_NAME);

                      }, child: Text('Already have account'))
                    ],
                  ),
                )
              ],
            ),
          )

          ),
      ],
    );
  }
  bool isLoading =false;
  void createAccount(){
    if(_RegisterformKey.currentState!.validate()==true){
      registerUser();
  }
}
  final db = FirebaseFirestore.instance;
  void registerUser()async{
    setState(() {
      isLoading=true;
    });
  try {
    UserCredential usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

  final userCollectionRef = getUserCollectionWithConverter();

  final user =MyUser.User(id:usercredential.user!.uid ,userName: userName,email: email);
  userCollectionRef.doc(user.id)
   .set(user)
  .then((value) => { //save user
  provider.updateUser(user),
    
      Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME)
  });
    showErrorMessage("Userl registered successfully");
  } on FirebaseAuthException catch (e) {
    showErrorMessage(e.message??"something went wrong please try again");
    /*if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }*/
  } catch (e) {
    print(e);
  }
  setState(() {
    isLoading=false;
  });
  }

  void showErrorMessage(String message){
    showDialog(context: context, builder: (buildContext){
      return AlertDialog(
        content: Text(message),
        actions: [
          TextButton(onPressed:(){
            Navigator.pop(context);
          }, child:Text('ok'))
        ],
      );
    });
  }
}

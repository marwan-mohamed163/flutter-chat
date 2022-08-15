
import 'package:chat_app/AppProvider.dart';
import 'package:chat_app/auth/RegisterationScreen.dart';
import 'package:chat_app/dataBase/DataBaseHelper.dart';
import 'package:chat_app/home/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static final String ROUTE_NAME = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _LoginFormKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
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
            appBar: AppBar(title: Center(child: Text('Login your account')),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(key: _LoginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          onChanged: (textValue) {
                            email = textValue;
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              floatingLabelBehavior: FloatingLabelBehavior.auto
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please enter email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          onChanged: (textValue) {
                            password = textValue;
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              floatingLabelBehavior: FloatingLabelBehavior.auto
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            } else if (value.length < 6) {
                              return 'password should at leaste 6 character';
                            }
                            return null;
                          },
                        ),

                        // isLoading?Center(child: CircularProgressIndicator(),)

                        ElevatedButton(
                            onPressed: () => login(), child: Text('Login')),

                        TextButton(onPressed:(){ Navigator.pushReplacementNamed(context,RegisterationScreen.ROUTE_NAME);},
                            child:Text('Do not have an account? Register Now!!'))

                      ],
                    ),
                  )
                ],
              ),
            )

        )
      ],
    );
  }

  void login() {
    if (_LoginFormKey.currentState!.validate() == true) {
      loginAccount();
    }
  }

  void loginAccount() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if (userCredential.user == null) {
        showErrorMessage(
            'Invail credientails no user exist with this email and password');
      } else {
        //navigate to home
        getUserCollectionWithConverter().doc(userCredential.user!.uid)
            .get()
            .then((retrieveduser) {
          provider.updateUser(retrieveduser.data());
          Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
            });

      };
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message!);
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  void showErrorMessage(String message){
    showDialog(context: context, builder: (BuildContext){
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




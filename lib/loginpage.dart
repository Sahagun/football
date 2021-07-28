

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String password = '';
  String email = '';

  FutureBuilder onPressLoginButton() {
    print('onPressLoginButton');
    print(email);
    print(password);

    Future<String> loginOutcome =  _login( email, password);

    return FutureBuilder(
        future: loginOutcome,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text(snapshot.data);
          }
          else if (snapshot.hasData){
            return Text(snapshot.data);
          }
          else{
            return Text('Loading');
          }
        }
    );
  }

  FutureBuilder onPressRegisterButton(){
    print('onPressRegisterButton');
    print(email);
    print(password);

    Future<String> registerOutcome =  _register( email, password);

    return FutureBuilder(
        future: registerOutcome,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text(snapshot.data);
          }
          else if (snapshot.hasData){
            return Text(snapshot.data);
          }
          else{
          }
        }
    );
  }

  Future<String> _register(String _email, String _password) async{
    String result = 'Unknown Error.';
    if (_email.isEmpty){
      return "Please enter your email.";
    }
    if (_password.isEmpty){
      return "Please enter your password.";
    }
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      result = 'Successfully registered ' + _email;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        result = "Error: The password provided is too weak.";
      }
      else if (e.code == 'email-already-in-use') {
        result = 'Error: The account already exists for that email';
      }
      else {
        result = "Unknown Error.";
      }
    }
    return result;
  }

  Future<String> _login(String _email, String _password) async{
    String result = 'Unknown Error.';
    if (_email.isEmpty){
      return "Please enter your email.";
    }
    if (_password.isEmpty){
      return "Please enter your password.";
    }
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      result = 'Successfully signed in ' + _email;
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        result = "Error: No user found for that email.";
      }
      else if (e.code == 'wrong-password') {
        result = "Error: Wrong password provided for that user.";
      }
      else {
        result = "Unknown Error.";
      }
    }
    return result;
  }

  void onChangeEmailField(String value){
    email = value;
  }

  void onChangePasswordField(String value){
    password = value;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Football Tracking'),
        ),
        body: Builder(
          builder: (context) => Center(

              child:

              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter Your Email',
                        labelText: 'Email*'
                    ),
                    onChanged: onChangeEmailField,

                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter Your Password',
                        labelText: 'Password*'
                    ),
                    obscureText: true,
                    onChanged: onChangePasswordField,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      // Register Button
                      ElevatedButton(
                          onPressed: (){
                            FutureBuilder futureBuilder = onPressRegisterButton();
                            Scaffold.of(context).showSnackBar(SnackBar(content: futureBuilder));
                            futureBuilder.future.then( (value){
                                if(FirebaseAuth.instance.currentUser != null){
                                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                                }
                              }
                            );
                          },
                          child: Text('Register')
                      ),

                      // spacing
                      SizedBox(width: 20,),

                      // Login Button
                      ElevatedButton(
                          onPressed: (){


                            FutureBuilder futureBuilder = onPressLoginButton();
                            Scaffold.of(context).showSnackBar(SnackBar(content: futureBuilder));
                            futureBuilder.future.then( (value){

                              if(FirebaseAuth.instance.currentUser != null){
                                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                              }

                              }
                            );
                          },
                          child: Text('Login')
                      ),
                    ],
                  )
                ],
              )
              )
          ),
        )
      );
  }
}
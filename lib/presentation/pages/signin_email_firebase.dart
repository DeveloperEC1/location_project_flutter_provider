import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locationprojectflutter/presentation/pages/register_email_firebase.dart';
import 'package:locationprojectflutter/presentation/widgets/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/tff_firebase.dart';
import 'list_map.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success, _loading = false;
  String _userEmail;

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return ListMap();
          } else {
            return Scaffold(
              body: Form(
                key: _formKey,
                child: Container(
                  color: Colors.blueGrey,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                fontSize: 40),
                          ),
                          SizedBox(
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 70),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: ResponsiveScreen()
                                    .heightMediaQuery(context, 20)),
                            child: TFFFirebase(
                                icon: Icon(Icons.email),
                                hint: "Email",
                                controller: _emailController,
                                obSecure: false),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: ResponsiveScreen()
                                    .heightMediaQuery(context, 20)),
                            child: TFFFirebase(
                                icon: Icon(Icons.lock),
                                hint: "Password",
                                controller: _passwordController,
                                obSecure: true),
                          ),
                          SizedBox(
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 20),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ResponsiveScreen()
                                    .widthMediaQuery(context, 20),
                                right: ResponsiveScreen()
                                    .widthMediaQuery(context, 20),
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              child: RaisedButton(
                                highlightElevation: 0.0,
                                splashColor: Colors.greenAccent,
                                highlightColor: Colors.lightGreenAccent,
                                elevation: 0.0,
                                color: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _loginFirebase();
                                  }
                                },
                              ),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _success == null
                                  ? ''
                                  : (_success ? '' : 'Sign in failed'),
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ));
                            },
                            child: Text(
                              'Don' +
                                  "'" +
                                  't Have an account? click here to register',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveScreen()
                                .heightMediaQuery(context, 20),
                          ),
                          !_loading ? Container() : CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  void _loginFirebase() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    _loading = true;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        print(_userEmail);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListMap(),
            ));
      });
    } else {
      _success = false;
      _loading = false;
    }
  }
}
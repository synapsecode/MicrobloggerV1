import 'dart:io';

import 'package:MicroBlogger/Screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/fetcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username;
  String password;
  @override
  void initState() {
    super.initState();
    if (!Platform.isWindows) {
      SharedPreferences.getInstance().then((pref) {
        //Get user if exists
        String user = pref.getString('loggedInUser');
        if (user.isNotEmpty) {
          //Navigator.of(context).pushNamed('/HomePage');
        } else {
          print("Stored User not found. Please login");
        }
      });
    } else {
      print("Load User feature unsupported! Please login!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('assets/env.png')),
              Text(
                'MicroBlogger',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Made by Manas Hejmadi',
                // style: TextStyle(color: Colors.white30),
              ),
              Text(
                'v0.0.1',
                // style: TextStyle(color: Colors.white30),
              ),
              Container(
                width: 270.0,
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Username:'),
                        onChanged: (x) {
                          setState(() {
                            username = x;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password:'),
                        onChanged: (x) {
                          setState(() {
                            password = x;
                          });
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 115.0),
                        color: Color.fromARGB(200, 220, 20, 60),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (username != null && password != null) {
                            Map loginObject = await login(username, password);
                            if (loginObject['code'] == 'S1') {
                              print(loginObject);
                              print(loginObject['user']['username']);
                              setCurrentUser(loginObject['user']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            currentUser: loginObject['user'],
                                          )));
                            } else if (loginObject['code'] == 'INCP') {
                              print("Either Username or password is incorrect");
                            } else {
                              print("There was an error!");
                            }
                          } else {
                            print(
                                "Please enter both the username and password to login");
                          }
                          //Navigator.pushNamed(context, '/HomePage');
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        child: Text("Do not have an account? Register",
                            style: TextStyle(color: Colors.white54)),
                        onTap: () {
                          Navigator.pushNamed(context, '/Register');
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

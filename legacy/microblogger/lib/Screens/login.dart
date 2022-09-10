import 'package:microblogger/Backend/datastore.dart';
import 'package:microblogger/Screens/homepage.dart';
import 'package:microblogger/Screens/register.dart';
import 'package:flutter/material.dart';
import 'package:microblogger/Backend/server.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";
  String password = "";

  void showAlert(title, content) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("$title"),
              content: Text("$content"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Back"))
              ],
            ));
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
              InkWell(
                  child: Image(image: AssetImage('assets/env.png')),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Connect to a Development Server"),
                              content: Container(
                                height: 140.0,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Server URL:'),
                                        onChanged: (x) =>
                                            setState(() => serverURL = x)),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Color.fromARGB(
                                                200, 220, 20, 60),
                                          ),
                                          child: Text("Initialize Server"),
                                          onPressed: () async {
                                            print(serverURL);
                                            setServerURL(serverURL);
                                            Navigator.pop(context);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                  }),
              Text(
                'microblogger',
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
                'v0.1.0',
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 12.0),
                            primary: Color.fromARGB(200, 220, 20, 60),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (username.isNotEmpty && password.isNotEmpty) {
                              print(username);
                              print(password);
                              Fluttertoast.showToast(
                                msg: "Logging In",
                                backgroundColor:
                                    Color.fromARGB(200, 220, 20, 60),
                              );
                              //LOGIN
                              Map loginObject = await login(username, password);
                              if (loginObject['code'] == 'S1') {
                                await saveUserLoginInfo(
                                    loginObject['user']['username']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              } else if (loginObject['code'] == 'INCP') {
                                showAlert("Invalid Credentials",
                                    "Either your username or password is incorrect! Please try again!");
                              } else {
                                showAlert("Login Error",
                                    "Unknown error occured! Please try again later!");
                              }
                            } else {
                              showAlert("Fill all fields",
                                  "Please make sure all the fields are filled!");
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        child: Text("Do not have an account? Register",
                            style: TextStyle(color: Colors.white54)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
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

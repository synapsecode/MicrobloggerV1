import 'package:MicroBlogger/Backend/datastore.dart';
import 'package:MicroBlogger/Screens/editprofile.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:MicroBlogger/Backend/server.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username = "";
  String email = "";
  String password = "";
  String cpassword = "";

  void showAlert(title, content) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("$title"),
              content: Text("$content"),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Back"))
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    checkConnection(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: AssetImage('assets/env.png')),
              Text(
                'Microblogger',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                'Register Account',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: 270.0,
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Username:'),
                        onChanged: (x) => setState(() {
                          username = x;
                        }),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email:'),
                        onChanged: (x) => setState(() {
                          email = x;
                        }),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password:'),
                        obscureText: true,
                        onChanged: (x) => setState(() {
                          password = x;
                        }),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirm Password:'),
                        obscureText: true,
                        onChanged: (x) => setState(() {
                          cpassword = x;
                        }),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 81.0),
                        color: Color.fromARGB(200, 220, 20, 60),
                        child: Text(
                          "Register Account",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (username.isNotEmpty &&
                              password.isNotEmpty &&
                              email.isNotEmpty &&
                              cpassword.isNotEmpty) {
                            if (password == cpassword) {
                              print("$username $password $email");
                              Fluttertoast.showToast(
                                msg: "Creating Account",
                                backgroundColor:
                                    Color.fromARGB(200, 220, 20, 60),
                              );
                              Map registerObject =
                                  await register(username, password, email);
                              if (registerObject['code'] == 'S1') {
                                print(registerObject);
                                await saveUserLoginInfo(
                                    registerObject['user']['username']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfilePage()));
                              } else {
                                showAlert("Register Error",
                                    "Unknown error occured! Please try again later!");
                              }
                            } else {
                              showAlert("Passwords dont match!",
                                  "Please make sure the password entered matches your confirmed password and try again!");
                            }
                          } else {
                            showAlert("Fill all fields!",
                                "Please make sure you fill all the fields to register a user!");
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        child: Text("Already Have an account? Login",
                            style: TextStyle(color: Colors.white54)),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
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

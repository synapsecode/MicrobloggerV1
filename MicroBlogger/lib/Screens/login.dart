import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        validator: (input) => input.length == 0
                            ? 'Username Cannot Be Empty'
                            : null,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password:'),
                        validator: (input) => input.length == 0
                            ? 'Password Cannot be Empty'
                            : null,
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/HomePage');
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

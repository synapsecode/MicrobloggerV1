import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                        validator: (input) {
                          if (input.length == 0) {
                            print("Username cannot be empty");
                            return "Username cannot be empty";
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email:'),
                        validator: (input) {
                          if (!input.contains('@')) {
                            print("Invalid email");
                            return "Invalid email";
                          } else if (input.length > 0) {
                            print("Invalid email");
                            return "Invalid email";
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password:'),
                        validator: (input) => input.length == 0
                            ? 'Password Cannot be Empty'
                            : null,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirm Password:'),
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
                            vertical: 20.0, horizontal: 81.0),
                        color: Color.fromARGB(200, 220, 20, 60),
                        child: Text(
                          "Register Account",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => print("Register Account"),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        child: Text("Already Have an account? Login",
                            style: TextStyle(color: Colors.white54)),
                        onTap: () {
                          Navigator.pushNamed(context, '/Login');
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

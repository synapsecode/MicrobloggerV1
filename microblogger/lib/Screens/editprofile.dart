import 'package:microblogger/Screens/imageupload.dart';
import 'package:flutter/material.dart';
import '../Backend/datastore.dart';
import '../Backend/server.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: EditCard());
  }
}

class EditCard extends StatefulWidget {
  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  String name = "";
  Map user;
  String location = "";
  String profileIcon = "";
  String bio = "";
  String email = "";
  String website = "";

  @override
  void initState() {
    super.initState();
    user = currentUser['user'];
    profileIcon = user['icon'];
    location = user['location'];
    name = user['name'];
    bio = user['bio'];
    email = user['email'];
    website = user['website'];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white10,
        padding: EdgeInsets.all(25.0),
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                print("Update Profile Icon Dialog");
              },
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage("$profileIcon"),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "${user['username']}",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name:'),
              initialValue: "$name",
              onChanged: (x) => setState(() {
                name = x;
              }),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              initialValue: "$location",
              decoration: InputDecoration(labelText: 'Location:'),
              onChanged: (x) => setState(() {
                location = x;
              }),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              initialValue: "$email",
              decoration: InputDecoration(labelText: 'Email:'),
              onChanged: (x) => setState(() {
                email = x;
              }),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Website:'),
              initialValue: "$website",
              onChanged: (x) => setState(() {
                website = x;
              }),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.black12,
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                initialValue: (bio == "") ? "Please enter your bio!" : "$bio",
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                maxLength: 200,
                onChanged: (x) => setState(() {
                  bio = x;
                }),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                  primary: Colors.black26,
                ),
                child: Text(
                  "Update Background Picture",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageCapture(
                                imageFor: 'BACKGROUND',
                              )));
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                  primary: Colors.black26,
                ),
                child: Text(
                  "Update Profile Picture",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageCapture(
                                imageFor: 'PROFILE',
                              )));
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                  primary: Color.fromARGB(200, 220, 20, 60),
                ),
                child: Text(
                  "Update Profile",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  print("Updating Profile");
                  print("$name, $location");
                  print(bio);
                  await updateProfile(name, location, bio, email, website);
                  Navigator.pushReplacementNamed(context, '/ProfilePage');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

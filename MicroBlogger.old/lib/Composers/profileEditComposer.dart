import 'package:flutter/material.dart';

class ProfileEditor extends StatelessWidget {
  final currentUser;
  const ProfileEditor({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Editor"),
      ),
      body: Container(),
    );
  }
}

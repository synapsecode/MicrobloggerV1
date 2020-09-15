import '../Components/Templates/audioelement.dart';
import 'package:flutter/material.dart';
import '../Components/Global/globalcomponents.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AudioElement(),
      ),
    );
  }
}

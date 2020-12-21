import 'package:MicroBlogger/bloc/theme_change_bloc.dart';
import 'package:MicroBlogger/bloc/theme_change_event.dart';
import 'package:MicroBlogger/bloc/theme_change_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: Text("Settings"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}

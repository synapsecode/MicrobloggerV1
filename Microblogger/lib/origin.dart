import 'package:flutter/material.dart';

class Origin extends StatefulWidget {
  final Function(BuildContext) builder;

  const Origin({Key key, this.builder}) : super(key: key);

  @override
  OriginState createState() => new OriginState();

  static OriginState of(BuildContext context) {
    return context.findAncestorStateOfType<OriginState>();
  }
}

class OriginState extends State<Origin> {
  //Globals

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  rebuild() {
    print("Initiating Global Origin Rebuild");
    setState(() {});
  }
}

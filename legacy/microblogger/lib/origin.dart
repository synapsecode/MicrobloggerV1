import 'package:microblogger/palette.dart';
import 'package:flutter/material.dart';

class Origin extends StatefulWidget {
  final Function(BuildContext) builder;

  const Origin({this.builder});

  @override
  OriginState createState() => new OriginState();

  static OriginState of(BuildContext context) {
    return context.findAncestorStateOfType<OriginState>();
  }
}

class OriginState extends State<Origin> {
  //Globals
  bool get isCurrentPaletteDarkTheme => (CurrentPalette == darkThemePalette);

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

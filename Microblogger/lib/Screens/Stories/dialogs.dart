// import 'package:MicroBlogger/Screens/Stories/storymaker.dart';
// import 'package:MicroBlogger/palette.dart';
// import 'package:flutter/material.dart';

// showTextEditDialog(BuildContext context, dynamic e, List mockData, Function setState, ) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         String cVal = e.value;
//         Color tColor = e.textColor ?? Colors.white;
//         Color bColor = e.backgroundColor ?? Colors.transparent;
//         return StatefulBuilder(
//           builder: (context, setBuilderState) {
//             TextEditingController ctrl = new TextEditingController(text: cVal);

//             ctrl.selection = TextSelection.fromPosition(
//                 TextPosition(offset: ctrl.text.length));

//             return AlertDialog(
//               // title: Text(
//               //   'Edit Text',
//               // ),
//               content: Container(
//                 height: 510.0,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       RaisedButton(
//                         padding: EdgeInsets.symmetric(horizontal: 30.0),
//                         color: Colors.yellow,
//                         onPressed: () {
//                           mockData.remove(e);
//                           mockData.add(e);
//                         },
//                         child: Text("Bring to Front"),
//                       ),
//                       SizedBox(height: 5),
//                       Text("Text Preview"),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(10.0),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: CurrentPalette['border'],
//                           ),
//                           color: Colors.white10,
//                         ),
//                         child: Text(
//                           cVal,
//                           style: TextStyle(
//                             color: tColor,
//                             backgroundColor: bColor,
//                           ),
//                         ),
//                       ),
//                       TextField(
//                         maxLines: 3,
//                         controller: ctrl,
//                         onChanged: (x) {
//                           setBuilderState(() {
//                             cVal = x;
//                             nval = x;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 10.0),
//                       Text("Text Colors"),
//                       SizedBox(height: 10.0),
//                       ColorPalette(
//                         stateChanger: (color) =>
//                             setBuilderState(() => tColor = color),
//                       ),
//                       SizedBox(height: 10),
//                       RaisedButton(
//                         padding: EdgeInsets.symmetric(horizontal: 50.0),
//                         color: Colors.black,
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => ColorPickerDialog(
//                               startColor: tColor,
//                               onColorSelected: (color) =>
//                                   setBuilderState(() => tColor = color),
//                               dialogHeading: "Custom Text Color",
//                             ),
//                           );
//                         },
//                         child: Text("Custom Text Color"),
//                       ),
//                       SizedBox(height: 10.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 30.0,
//                           ),
//                           Text("Background Color"),
//                           IconButton(
//                             icon: Icon(Icons.clear),
//                             onPressed: () {
//                               setBuilderState(
//                                   () => bColor = Colors.transparent);
//                             },
//                           )
//                         ],
//                       ),
//                       // SizedBox(height: 5.0),
//                       ColorPalette(
//                         stateChanger: (color) =>
//                             setBuilderState(() => bColor = color),
//                       ),
//                       SizedBox(height: 10),
//                       RaisedButton(
//                         padding: EdgeInsets.symmetric(horizontal: 28.0),
//                         color: Colors.black,
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => ColorPickerDialog(
//                               startColor: bColor,
//                               onColorSelected: (color) =>
//                                   setBuilderState(() => bColor = color),
//                               dialogHeading: "Custom Background Color",
//                             ),
//                           );
//                         },
//                         child: Text("Custom Background Color"),
//                       ),
//                       RaisedButton(
//                         padding: EdgeInsets.symmetric(horizontal: 60.0),
//                         color: CurrentPalette['errorColor'],
//                         onPressed: () {
//                           mockData.remove(e);

//                           setState();
//                           Navigator.pop(context);
//                         },
//                         child: Text("Delete Element"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 FlatButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: CurrentPalette['transparent_text']),
//                   ),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     if (nval == "") nval = "Text";
//                     print("New Value: $nval");

//                     var x = mockData[mockData.indexOf(e)];

//                     x.value = nval;
//                     x.backgroundColor = bColor;
//                     x.textColor = tColor;
//                     setState();
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Done',
//                     style: TextStyle(color: CurrentPalette['transparent_text']),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       });
// }

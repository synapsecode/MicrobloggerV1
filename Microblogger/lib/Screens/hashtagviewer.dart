import 'dart:ui';
import 'package:MicroBlogger/Screens/hashtagposts.dart';
import 'package:flutter/material.dart';
import 'package:MicroBlogger/palette.dart';

import '../origin.dart';

class HashPostsViewer extends StatelessWidget {
  const HashPostsViewer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Microblogger Hashtags"),
          backgroundColor: Colors.black87),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Search Hashtags",
            //   style: TextStyle(
            //       fontSize: 40, color: CurrentPalette['transparent_text']),
            // ),
            SizedBox(
              height: 10.0,
            ),
            CustomInputBox(
              "Search Hashtags",
              hintColor: CurrentPalette['transparent_text'],
              backColor: Colors.transparent,
              textColor: Origin.of(context).isCurrentPaletteDarkTheme
                  ? Colors.white
                  : Colors.black,
              notifier: (x) {
                // print("dd $x");
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            GridView.count(
              crossAxisCount: 2,
              primary: false,
              shrinkWrap: true,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              children: [
                ...[
                  for (int i = 0; i < 10; i++)
                    HashTagGroupItem(
                      hashtag: "Programming",
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HashTagGroupItem extends StatelessWidget {
  final String hashtag;
  final String cta;
  final String thumbnail;
  const HashTagGroupItem({
    this.thumbnail =
        "https://i.pinimg.com/originals/ce/df/85/cedf859f9ac47edc599cda3cd74998f6.jpg",
    this.cta = "Click to view posts",
    this.hashtag,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SpecificHashtaggedPosts(
              hashtag: hashtag,
            ),
          ),
        );
      },
      child: Container(
        width: 170,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
          image: DecorationImage(
            image: NetworkImage(
              thumbnail, //Image
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.colorBurn),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cta,
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "#$hashtag",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInputBox extends StatefulWidget {
  final String type;
  final Function notifier;
  final bool obscure;
  final Color textColor;
  final Color hintColor;
  final Color backColor;
  final bool isFilled;
  final String hintText;
  const CustomInputBox(this.type,
      {this.notifier,
      this.obscure,
      this.textColor,
      this.backColor,
      this.isFilled,
      this.hintColor,
      this.hintText,
      key})
      : super(key: key);

  @override
  _CustomInputBoxState createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  IconData visibility = Icons.visibility;
  bool hide = false;
  Color textColor;
  @override
  void initState() {
    hide = widget.obscure ?? false;
    textColor = widget.textColor ?? Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: TextFormField(
          decoration: InputDecoration(
            // labelText: "  ${widget.type}",
            labelStyle: TextStyle(color: widget.hintColor ?? textColor),
            hintText: (widget.hintText != null)
                ? widget.hintText
                : "  ${widget.type}",
            hintStyle: TextStyle(color: widget.hintColor ?? textColor),
            fillColor:
                (widget.backColor != null) ? widget.backColor : Colors.black45,
            hoverColor: Colors.red,
            focusColor: Colors.red,
            filled: (widget.isFilled != null) ? widget.isFilled : true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(),
            ),
            //fillColor: Colors.green
          ),
          onChanged: (x) =>
              (widget.notifier != null) ? widget.notifier(x) : null,
          obscureText: hide,
          validator: (val) {
            if (val.length == 0) {
              return "${widget.type} cannot be empty";
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
            color: textColor,
          ),
        ),
      ),
      (widget.obscure != null && widget.obscure == true)
          ? Positioned(
              right: 10.0,
              top: 6.0,
              child: IconButton(
                  icon: Icon(visibility, color: Colors.white38),
                  onPressed: () {
                    setState(() {
                      hide = !hide;
                      visibility =
                          (hide) ? Icons.visibility : Icons.visibility_off;
                    });
                  }),
            )
          : const SizedBox()
    ]);
  }
}

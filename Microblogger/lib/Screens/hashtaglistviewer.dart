import 'dart:ui';
import 'package:MicroBlogger/Backend/server.dart';
import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/Screens/hashtagpostviewer.dart';
import 'package:MicroBlogger/globals.dart';
import 'package:flutter/material.dart';
import 'package:MicroBlogger/palette.dart';

import '../origin.dart';

class HashPostsViewer extends StatelessWidget {
  const HashPostsViewer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Microblogger Hashtags"),
          backgroundColor: Colors.black87),
      body: HashtagsListBody(),
    );
  }
}

class HashtagsListBody extends StatefulWidget {
  const HashtagsListBody();

  @override
  _HashtagsListBodyState createState() => _HashtagsListBodyState();
}

class _HashtagsListBodyState extends State<HashtagsListBody> {
  Future htagData;

  @override
  void initState() {
    htagData = getHashtags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: CachedFutureBuilder(
        cacheStore: HashtagsListCache,
        future: htagData,
        onUpdate: (AsyncSnapshot snapshot) {
          // print(snapshot.data);
          print("Updated");
          HashtagsListCache = snapshot.data;
          return HTBody(snapshot.data);
        },
        onCacheUsed: (cache) {
          print("Using Cache");
          return HTBody(cache);
        },
      ),
    );
  }
}

class HTBody extends StatefulWidget {
  final List data;
  HTBody(this.data);

  @override
  _HTBodyState createState() => _HTBodyState();
}

class _HTBodyState extends State<HTBody> {
  String currentSearchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            setState(() => currentSearchQuery = x);
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
          children: widget.data
              .where(
                (e) => e.startsWith(currentSearchQuery),
              )
              .map((e) => HashTagGroupItem(
                    hashtag: e,
                  ))
              .toList(),
        ),
      ],
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
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HashtagPostViewer(
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
          border: Border.all(color: CurrentPalette['border']),
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
      key});

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

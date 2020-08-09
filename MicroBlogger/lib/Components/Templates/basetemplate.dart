import 'package:MicroBlogger/Components/Templates/ViewerTemplate.dart';
import 'package:MicroBlogger/Components/Templates/postTemplates.dart';
import 'package:MicroBlogger/Composers/commentComposer.dart';
import 'package:MicroBlogger/Composers/reshareComposer.dart';
import 'package:MicroBlogger/Screens/editprofile.dart';
import 'package:MicroBlogger/Screens/homepage.dart';
import 'package:MicroBlogger/Screens/profile.dart';
import 'package:MicroBlogger/Views/blog_viewer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Backend/datastore.dart';
import '../../Backend/server.dart';

class BasicTemplate extends StatefulWidget {
  final postObject;
  final isInViewMode;
  final bool isHosted;
  final Widget widgetComponent;

  BasicTemplate(
      {Key key,
      this.postObject,
      this.widgetComponent,
      this.isInViewMode = false,
      this.isHosted = false})
      : super(key: key);

  @override
  _BasicTemplateState createState() => _BasicTemplateState();
}

class _BasicTemplateState extends State<BasicTemplate> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: (widget.isHosted)
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(vertical: 5.0),
        child: InkWell(
          onTap: () {
            Widget page;
            if (!widget.isInViewMode) {
              //if (widget.postObject['type'] == 'microblog') return;
              switch (widget.postObject['type']) {
                case 'microblog':
                  page = BaseViewer(
                    postObject: widget.postObject,
                  );
                  break;
                case 'ResharedWithComment':
                  page = BaseViewer(
                    postObject: widget.postObject,
                  );
                  break;
              }
              //Redirect to Page
              if (page != null) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => page));
              }
            }
          },
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: (widget.isHosted)
                      ? Color.fromARGB(255, 32, 32, 32)
                      : Color.fromARGB(255, 28, 28, 28),
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.white30),
                    left: BorderSide(width: 1.0, color: Colors.white30),
                    right: BorderSide(width: 1.0, color: Colors.white30),
                    bottom: BorderSide(width: 1.0, color: Colors.white24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //----------------------------------------HEADER-------------------------------------------------
                    TopBar(
                      postObject: widget.postObject,
                    ),
                    //----------------------------------------HEADER-------------------------------------------------
                    SizedBox(
                      height: 10.0,
                    ),
                    //----------------------------------------CONTENT-------------------------------------------------

                    Container(
                        padding: (widget.isHosted)
                            ? EdgeInsets.zero
                            : EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.postObject.containsKey('child')) ...[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.postObject['content']}"),
                                  ]),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                            widget.widgetComponent,
                          ],
                        )),
                    //---------------------------------------CONTENT-------------------------------------------------
                  ],
                ),
              ),
              if (!widget.isHosted) ...[
                ActionBar(
                  post: widget.postObject,
                )
              ]
            ],
          ),
        ));
  }
}

class TopBar extends StatelessWidget {
  final postObject;
  const TopBar({Key key, this.postObject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            // print(postObject['author']['username']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          postObject['author']['username'],
                        )));
          },
          child: CircleAvatar(
            radius: 24.0,
            backgroundImage: NetworkImage("${postObject['author']['icon']}"),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${postObject['author']['name']}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                    postObject['author']['username'],
                                  )));
                    },
                    child: Text(
                      "@${postObject['author']['username']}",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${postObject['age']}",
                    style: TextStyle(color: Colors.white30),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  if (postObject['type'] == 'microblog' ||
                      postObject['type'] == 'ResharedWithComment' ||
                      postObject['type'] == 'comment') ...[
                    Text(
                      "${postObject['category']}",
                      style: TextStyle(
                          color: (postObject['category'] == 'Fact')
                              ? Colors.green
                              : Colors.pink),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                  InkWell(
                    onTap: () => print("More clicked"),
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActionBar extends StatefulWidget {
  final post;
  ActionBar({Key key, this.post}) : super(key: key);

  @override
  _ActionBarState createState() => _ActionBarState();
}

class _ActionBarState extends State<ActionBar> {
  final cUser = currentUser['user'];

  bool _liked = false;
  bool _reshared = false;
  bool _bookmarked = false;

  String commentText = "";
  int likeCounter = 0;
  int commentCounter = 0;
  int reshareCounter = 0;

  toggleLike() async {
    setState(() {
      _liked = !_liked;
      likeCounter = (!_liked) ? --likeCounter : ++likeCounter;
      widget.post['likes'] = likeCounter;
      widget.post['isLiked'] = _liked;
    });
    if (widget.post['type'] != 'comment') {
      if (!_liked)
        await unlikePost(widget.post['id'], widget.post['type']);
      else
        await likePost(widget.post['id'], widget.post['type']);
      print("${(_liked) ? "L" : "Unl"}iked Post ID: ${widget.post['id']}");
    } else {
      print("COMMENT OBJ: ${widget.post}");
      //For Comments
      if (!_liked)
        await unlikePost(widget.post['cid'], widget.post['type']);
      else
        await likePost(widget.post['cid'], widget.post['type']);
      print("${(_liked) ? "L" : "Unl"}iked Post ID: ${widget.post['cid']}");
    }
  }

  toggleReshare() async {
    setState(() {
      _reshared = !_reshared;
      reshareCounter = (!_reshared) ? --reshareCounter : ++reshareCounter;
      widget.post['reshares'] = reshareCounter;
      widget.post['isReshared'] = _reshared;
    });
    if (!_reshared) {
      //TODO: Implement RWC Unshare
      await unresharePost(widget.post['id'], widget.post['type']);
      print(
          "${widget.post['id']}, ${widget.post['type']}, ${widget.post['author']['username']}");
      return;
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          RaisedButton(
              onPressed: () async {
                //Initiated a simple reshare from the server
                await resharePost(
                    widget.post['id'], widget.post['type'], "SimpleReshare");
                setState(() {
                  _reshared = !_reshared;
                  reshareCounter =
                      (!_reshared) ? --reshareCounter : ++reshareCounter;
                });
              },
              color: Colors.white10,
              child: Text("Reshare", style: TextStyle(color: Colors.white))),
          SizedBox(
            width: 5.0,
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                _reshared = !_reshared;
                reshareCounter =
                    (!_reshared) ? --reshareCounter : ++reshareCounter;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReshareComposer(
                              postObject: widget.post,
                            )));
              });
              print(
                  "Initiated ResharedWithComment for this post by currentUser (${currentUser['username']})");
            },
            color: Colors.white10,
            child: Text("Reshare with Comment",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    ));
  }

  addComment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CommentComposer(
                  post: widget.post,
                )));
    print("Commented on Post ID: ${widget.post['id']}");
  }

  toggleBookmark() async {
    setState(() {
      _bookmarked = !_bookmarked;
      widget.post['isBookmarked'] = _bookmarked;
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        (_bookmarked) ? "Added To Bookmarks" : "Removed from Bookmarks",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 1),
    ));
    if (!_bookmarked)
      await unbookmarkPost(widget.post['id'], widget.post['type']);
    else
      await bookmarkPost(widget.post['id'], widget.post['type']);
  }

  @override
  void initState() {
    likeCounter = widget.post['likes'];
    reshareCounter = widget.post['reshares'];
    commentCounter =
        (widget.post.containsKey('comments')) ? widget.post['comments'] : 0;
    if (widget.post.containsKey('isLiked')) {
      if (widget.post['isLiked'])
        _liked = true;
      else
        _liked = false;
    }
    if (widget.post.containsKey('isReshared')) {
      if (widget.post['isReshared'])
        _reshared = true;
      else
        _reshared = false;
    }
    if (widget.post.containsKey('isBookmarked')) {
      if (widget.post['isBookmarked'])
        _bookmarked = true;
      else
        _bookmarked = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5.0),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 28, 28, 28),
            border: Border(
                left: BorderSide(width: 1.0, color: Colors.white30),
                right: BorderSide(width: 1.0, color: Colors.white30),
                bottom: BorderSide(width: 1.0, color: Colors.white30))),
        height: 35.0,
        child: Row(
          children: [
            Row(
              children: [
                IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon:
                        Icon((_liked) ? Icons.favorite : Icons.favorite_border),
                    color: (_liked) ? Colors.pink : null,
                    onPressed: () {
                      toggleLike();
                    }),
                Text(
                  "${likeCounter.toString()}",
                  style: TextStyle(color: Colors.white60),
                )
              ],
            ),
            //comment
            if (widget.post['type'] != "poll" &&
                widget.post['type'] != "ResharedWithComment" &&
                widget.post['type'] != "comment") ...[
              Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.only(bottom: 2.0),
                      icon: Icon((_reshared) ? Icons.repeat : Icons.repeat),
                      color: (_reshared) ? Colors.green : null,
                      onPressed: () {
                        toggleReshare();
                      }),
                  Text(
                    "${reshareCounter.toString()}",
                    style: TextStyle(color: Colors.white60),
                  )
                ],
              ),
            ],
            if (widget.post['type'] != "poll" &&
                widget.post['type'] != "shareable" &&
                widget.post['type'] != "comment") ...[
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon: Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      addComment();
                    },
                  ),
                  Text(
                    "${commentCounter.toString()}",
                    style: TextStyle(color: Colors.white60),
                  )
                ],
              ),
            ],
            if (widget.post['type'] != "poll" &&
                widget.post['type'] != "comment") ...[
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(bottom: 2.0),
                    icon: Icon(
                        (_bookmarked) ? Icons.bookmark : Icons.bookmark_border),
                    color: (_bookmarked) ? Colors.green : null,
                    onPressed: () {
                      toggleBookmark();
                    },
                  )
                ],
              ),
            ],
            if (widget.post['type'] == 'comment') ...[
              Text(
                "   Replying to ",
                style: TextStyle(color: Colors.white24),
              ),
              InkWell(
                  onTap: () {
                    print(widget.post);
                    if (widget.post['type'] == 'microblog' ||
                        widget.post['type'] == 'ResharedWithComment') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BaseViewer(
                          postObject: widget.post,
                        );
                      }));
                    }
                  },
                  child:
                      Text("Parent Post", style: TextStyle(color: Colors.blue)))
            ]
          ],
        ));
  }
}

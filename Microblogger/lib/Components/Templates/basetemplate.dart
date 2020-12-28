import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/Components/Templates/ViewerTemplate.dart';
import 'package:MicroBlogger/Components/Templates/postTemplates.dart';
import 'package:MicroBlogger/Composers/blogComposer.dart';
import 'package:MicroBlogger/Composers/commentComposer.dart';
import 'package:MicroBlogger/Composers/carouselComposer.dart';
import 'package:MicroBlogger/Composers/microblogComposer.dart';
import 'package:MicroBlogger/Composers/reshareComposer.dart';
import 'package:MicroBlogger/Composers/shareableComposer.dart';
import 'package:MicroBlogger/Composers/timelineComposer.dart';
import 'package:MicroBlogger/Screens/editprofile.dart';
import 'package:MicroBlogger/Screens/homepage.dart';
import 'package:MicroBlogger/Screens/profile.dart';
import 'package:MicroBlogger/Views/blog_viewer.dart';
import 'package:MicroBlogger/Views/timeline_viewer.dart';
import 'package:MicroBlogger/origin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Backend/datastore.dart';
import '../../Backend/server.dart';
import 'package:MicroBlogger/palette.dart';

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
            if (!widget.isInViewMode && widget.postObject['age'] != "0x00") {
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
                case 'carousel':
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
                      ? CurrentPalette['childpostcolour']
                      : CurrentPalette['postcolour'],

                  border:
                      Border.all(width: 1.0, color: CurrentPalette['border']),
                  // border: Border(
                  //   top:
                  //       BorderSide(width: 1.0, color: CurrentPalette['border']),
                  //   left:
                  //       BorderSide(width: 1.0, color: CurrentPalette['border']),
                  //   right:
                  //       BorderSide(width: 1.0, color: CurrentPalette['border']),
                  //   bottom:
                  //       BorderSide(width: 1.0, color: CurrentPalette['border']),
                  // ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //----------------------------------------HEADER-------------------------------------------------
                    TopBar(
                      postObject: widget.postObject,
                      isHosted: widget.isHosted,
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
                                    HashTagEnabledUserTaggableTextDisplay(
                                        widget.postObject['content']),
                                    //Text("${widget.postObject['content']}"),
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
  final isHosted;
  const TopBar({Key key, this.postObject, this.isHosted = false})
      : super(key: key);
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
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${postObject['age']}",
                    style: TextStyle(color: CurrentPalette['transparent_text']),
                  ),
                  if (isHosted)
                    SizedBox(
                      width: 10,
                    ),
                  if (postObject['author']['username'] ==
                      currentUser['user']['username']) ...[
                    ConstrainedBox(
                        constraints: new BoxConstraints(
                          maxHeight: 20.0,
                          maxWidth: 30.0,
                        ),
                        child: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.arrow_drop_down),
                            onSelected: (x) async {
                              switch (x) {
                                case "del":
                                  showDialog(
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Color.fromARGB(230, 220, 20, 60),
                                          content: Text(
                                            "Are you sure you want to delete this post? This action is irreversible and would result in the post being permanantly erased",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          title: Text("Delete Post",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          actions: [
                                            FlatButton(
                                              child: Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                print("Deleting Post...");
                                                await deletePost(
                                                    postObject['id'],
                                                    postObject['type']);
                                                print("Deleted Post");
                                                Fluttertoast.showToast(
                                                  msg: "Deleted Post",
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          200, 220, 20, 60),
                                                );
                                                Navigator.pushReplacementNamed(
                                                    context, '/HomePage');
                                              },
                                            ),
                                            FlatButton(
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            )
                                          ],
                                        );
                                      },
                                      context: context);
                                  break;
                                //CurrentPalette['border']
                                case "unreshare":
                                  print("unresharing post");
                                  await unresharePost(postObject['child']['id'],
                                      postObject['child']['type']);
                                  print("Unreshared post");
                                  Fluttertoast.showToast(
                                    msg: "Unreshared Post",
                                    backgroundColor:
                                        Color.fromARGB(200, 220, 20, 60),
                                  );
                                  Navigator.pushReplacementNamed(
                                      context, '/HomePage');
                                  break;
                                case "delcom":
                                  showDialog(
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              Color.fromARGB(230, 220, 20, 60),
                                          content: Text(
                                              "Are you sure you want to delete this comment? This action is irreversible and would result in the comment being permanantly erased",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          title: Text("Delete Comment",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          actions: [
                                            FlatButton(
                                              child: Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                print("Deleting Comment");
                                                await deleteCommentFromPost(
                                                    postObject['cid']);
                                                print("Deleted Comment");
                                                Fluttertoast.showToast(
                                                  msg: "Deleted Comment",
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          200, 220, 20, 60),
                                                );
                                                Navigator.pushReplacementNamed(
                                                    context, '/HomePage');
                                              },
                                            ),
                                            FlatButton(
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            )
                                          ],
                                        );
                                      },
                                      context: context);

                                  break;
                                case "edit":
                                  print(postObject['type']);
                                  editRouter(context);
                                  break;
                                default:
                                  print("Invalid option");
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                if (postObject['type'] == "ResharedWithComment")
                                  PopupMenuItem(
                                      value: "unreshare",
                                      child: Text("Unreshare Post")),
                                (postObject['type'] == "comment")
                                    ? PopupMenuItem(
                                        value: "delcom",
                                        child: Text("Delete Comment"))
                                    : (postObject['type'] !=
                                            "ResharedWithComment")
                                        ? PopupMenuItem(
                                            value: "del",
                                            child: Text("Delete Post"))
                                        : null,
                                if (postObject['type'] != "poll")
                                  PopupMenuItem(
                                      value: "edit", child: Text("Edit Post")),
                                // PopupMenuItem(
                                //     value: "hoist",
                                //     child: Text("Hoist to Story"))
                              ];
                            })),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (!isHosted) ...[
          Opacity(
            opacity: 0.3,
            child: IconButton(
              onPressed: () {
                print("Hoisting to Story");
                // print("POST DATA ${widget.post}");
              },
              icon: Icon(Icons.ios_share),
            ),
          ),
        ],
        if (postObject['type'] == 'microblog' ||
            postObject['type'] == 'ResharedWithComment' ||
            postObject['type'] == 'comment') ...[
          // CircleAvatar(
          //   radius: 10,
          //   backgroundColor:
          //       (postObject['category'] == 'Fact') ? Colors.green : Colors.pink,
          // ),
          CircleAvatar(
            radius: 10,
            backgroundColor:
                (postObject['category'] == 'Fact') ? Colors.green : Colors.pink,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: CurrentPalette['postcolour'],
            ),
          )
          // SizedBox(
          //   width: 10,
          // ),
        ],
      ],
    );
  }

  void editRouter(BuildContext context) async {
    switch (postObject['type']) {
      case "microblog":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MicroBlogComposer(
                      isEditing: true,
                      preExistingState: {
                        'pid': postObject['id'],
                        'content': postObject['content'],
                        'isFact':
                            (postObject['category'] == 'Fact') ? true : false
                      },
                    )));
        break;
      case "blog":
        Map blogData = await getBlogData(postObject);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogComposer(
                      isEditing: true,
                      preExistingState: {
                        'pid': postObject['id'],
                        'content': blogData['content'],
                        'blogName': blogData['blog_name'],
                        'cover': postObject['background']
                      },
                    )));
        break;
      case "shareable":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShareableComposer(
                      isEditing: true,
                      preExistingState: {
                        'pid': postObject['id'],
                        'content': postObject['content'],
                        'link': postObject['link'],
                        'name': postObject['name']
                      },
                    )));
        break;
      case "timeline":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TimelineComposer(
                      isEditing: true,
                      preExistingState: {
                        'pid': postObject['id'],
                        'timelineTitle': postObject['timeline_name'],
                        'events': postObject['events'],
                        'cover': postObject['background']
                      },
                    )));
        break;
      case "carousel":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarouselComposer(
                      isEditing: true,
                      preExistingState: {
                        'pid': postObject['id'],
                        'images': postObject['images'],
                        'content': postObject['content'],
                      },
                    )));
        break;
      case "comment":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CommentComposer(
                      isEditing: true,
                      preExistingState: {
                        'cid': postObject['cid'],
                        'comment': postObject['content'],
                        'isFact':
                            (postObject['category'] == 'Fact') ? true : false,
                      },
                    )));
        break;
      case "ResharedWithComment":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReshareComposer(
                      postObject: postObject,
                      isEditing: true,
                      preExistingState: {
                        'pid': postObject['id'],
                        'content': postObject['content'],
                        'isFact':
                            (postObject['category'] == 'Fact') ? true : false,
                      },
                    )));
        break;
    }
  }
}

class ActionBar extends StatefulWidget {
  final post;
  final Color backgroundColor;
  final bool noborder;
  ActionBar({Key key, this.post, this.noborder = false, this.backgroundColor})
      : super(key: key);

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
      widget.post['reshares'] = reshareCounter;
      widget.post['isReshared'] = _reshared;
    });
    if (_reshared) {
      //TODO: Implement RWC Unshare
      await unresharePost(widget.post['id'], widget.post['type']);
      setState(() {
        _reshared = !_reshared;
        reshareCounter = (!_reshared) ? --reshareCounter : ++reshareCounter;
        widget.post['reshares'] = reshareCounter;
        widget.post['isReshared'] = _reshared;
      });
      Fluttertoast.showToast(
        msg: "Unreshared Post",
        backgroundColor: Color.fromARGB(200, 220, 20, 60),
      );
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
                setState(() {
                  _reshared = !_reshared;
                  reshareCounter =
                      (!_reshared) ? --reshareCounter : ++reshareCounter;
                  widget.post['reshares'] = reshareCounter;
                  widget.post['isReshared'] = _reshared;
                });
                await resharePost(
                    widget.post['id'], widget.post['type'], "SimpleReshare");

                Fluttertoast.showToast(
                  msg: "Reshared Post",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60),
                );
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
                widget.post['reshares'] = reshareCounter;
                widget.post['isReshared'] = _reshared;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReshareComposer(
                              isEditing: false,
                              preExistingState: {
                                'content': "",
                                'isFact': false
                              },
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
                  isEditing: false,
                  preExistingState: {'comment': '', 'isFact': false},
                  post: widget.post,
                )));
    print("Commented on Post ID: ${widget.post['id']}");
  }

  toggleBookmark() async {
    setState(() {
      _bookmarked = !_bookmarked;
      widget.post['isBookmarked'] = _bookmarked;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
          color: widget.backgroundColor ?? CurrentPalette['postcolour'],
          border: (!widget.noborder)
              ? Border(
                  left: BorderSide(width: 1.0, color: CurrentPalette['border']),
                  right:
                      BorderSide(width: 1.0, color: CurrentPalette['border']),
                  bottom:
                      BorderSide(width: 1.0, color: CurrentPalette['border']),
                )
              : Border.all(width: 0.0, color: Colors.transparent),
        ),
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
                  style: TextStyle(color: CurrentPalette['transparent_text']),
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
                    style: TextStyle(color: CurrentPalette['transparent_text']),
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
                    style: TextStyle(color: CurrentPalette['transparent_text']),
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
                style: TextStyle(color: CurrentPalette['transparent_text']),
              ),
              InkWell(
                  onTap: () async {
                    print("Redirecting to Parent Post");
                    print(widget.post);
                    Map post = await getSpecificPost(
                        widget.post['parent_post_id'],
                        widget.post['parent_post_type']);
                    print("POSTTT: $post");
                    if (widget.post['parent_post_type'] == 'microblog' ||
                        widget.post['parent_post_type'] ==
                            'ResharedWithComment' ||
                        widget.post['parent_post_type'] == 'carousel') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BaseViewer(
                          postObject: post,
                        );
                      }));
                    } else if (widget.post['parent_post_type'] == 'timeline') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TimelineViewer(
                          postObject: post,
                        );
                      }));
                    } else if (widget.post['parent_post_type'] == 'blog') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BlogViewer(
                          postObject: post,
                        );
                      }));
                    }
                  },
                  child: InkWell(
                      child: Text("Parent Post",
                          style: TextStyle(color: Colors.blue))))
            ],
          ],
        ));
  }
}

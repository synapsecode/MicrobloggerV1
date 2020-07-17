import 'package:MicroBlogger/Components/Others/UIElements.dart';
import 'package:MicroBlogger/Components/PostTemplates/blogs.dart';
import 'package:MicroBlogger/Components/PostTemplates/timelines.dart';
import 'package:MicroBlogger/PostViewers/ReshareViewer.dart';
import 'package:flutter/material.dart';

class ReshareWithComment extends StatefulWidget {
  final resharedType;
  final postObject;
  ReshareWithComment({Key key, this.resharedType, this.postObject})
      : super(key: key);

  @override
  _ReshareWithCommentState createState() => _ReshareWithCommentState();
}

class _ReshareWithCommentState extends State<ReshareWithComment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: InkWell(
          onTap: () {
            print(widget.resharedType);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ResharedWithCommentViewer(
                resharedType: (widget.resharedType == "MicroBlog")
                    ? "MicroBlog"
                    : (widget.resharedType == "Shareable")
                        ? "Shareable"
                        : (widget.resharedType == "Blog")
                            ? "Blog"
                            : (widget.resharedType == "Timeline")
                                ? "Timeline"
                                : "None",
                postObject: {
                  'id': 'ffaX3ddc',
                },
              );
            }));
          },
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(color: Colors.white30, width: 1.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //----------------------------------------HEADER-------------------------------------------------
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24.0,
                          backgroundImage: NetworkImage(
                              'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Manas Hejmadi",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => print("clicked user"),
                                    child: Text(
                                      "@synapse.ai",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "12h",
                                    style: TextStyle(color: Colors.white30),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Fact",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
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
                    ),
                    //----------------------------------------HEADER-------------------------------------------------
                    SizedBox(
                      height: 10.0,
                    ),
                    //----------------------------------------CONTENT-------------------------------------------------
                    Text(
                        "Thats a good move! Everybody needs a break from social media once in a while :)"),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (widget.resharedType == "MicroBlog") ...[
                      InkWell(
                        child: HostMicroBlog(),
                        onTap: () {
                          Navigator.of(context).pushNamed('/MicroBlogViewer');
                        },
                      ),
                    ] else if (widget.resharedType == "Shareable") ...[
                      HostShareable(),
                    ] else if (widget.resharedType == "Blog") ...[
                      HostBlog(),
                    ] else if (widget.resharedType == "Timeline") ...[
                      HostTimeline(),
                    ],
                    //---------------------------------------CONTENT-------------------------------------------------
                    //---------------------------------------SubFooter-------------------------------------------------

                    //---------------------------------------SubFooter-------------------------------------------------
                  ],
                ),
              ),
              ActionBar(
                postType: "Microblog_ResharedWithComment",
              )
            ],
          ),
        ));
  }
}

// class HostMicroBlog extends StatelessWidget {
//   const HostMicroBlog({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         print("Redirecting to MicroBlog");
//       },
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Padding(
//             padding: EdgeInsets.symmetric(vertical: 10.0),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(10.0),
//                   decoration: BoxDecoration(
//                       color: Colors.black26,
//                       border: Border.all(color: Colors.white30, width: 1.0)),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //----------------------------------------HEADER-------------------------------------------------
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 24.0,
//                             backgroundImage: NetworkImage(
//                                 'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(left: 10.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Carryminati",
//                                   style: TextStyle(fontSize: 20.0),
//                                 ),
//                                 Row(
//                                   children: [
//                                     InkWell(
//                                       onTap: () => print("clicked user"),
//                                       child: Text(
//                                         "@ajeynagar",
//                                         style: TextStyle(color: Colors.blue),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text(
//                                       "22h",
//                                       style: TextStyle(color: Colors.white30),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text(
//                                       "Opinion",
//                                       style: TextStyle(color: Colors.pink),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       //----------------------------------------HEADER-------------------------------------------------
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       //----------------------------------------CONTENT-------------------------------------------------
//                       Container(
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                   color: Colors.white10, width: 0.5)),
//                           padding: EdgeInsets.all(10.0),
//                           child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                     "Hey Guys! How are you all? I have decided to take a short break from Youtube to focus more on my creative development. See you guys soon!"),
//                               ])),
//                       //---------------------------------------CONTENT-------------------------------------------------
//                       //---------------------------------------SubFooter-------------------------------------------------

//                       //---------------------------------------SubFooter-------------------------------------------------
//                     ],
//                   ),
//                 ),
//               ],
//             ))
//       ]),
//     );
//   }
// }

class HostMicroBlog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.black54,
              border: Border.all(color: Colors.white30, width: 1.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------------------HEADER-------------------------------------------------
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manas Hejmadi",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => print("clicked user"),
                              child: Text(
                                "@synapse.ai",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "12h",
                              style: TextStyle(color: Colors.white30),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Fact",
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
              ),
              //----------------------------------------HEADER-------------------------------------------------
              SizedBox(
                height: 10.0,
              ),
              //----------------------------------------CONTENT-------------------------------------------------
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 0.5)),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                      ])),
              //---------------------------------------CONTENT-------------------------------------------------
              //---------------------------------------SubFooter-------------------------------------------------

              //---------------------------------------SubFooter-------------------------------------------------
            ],
          ),
        ),
      ],
    );
  }
}

class HostShareable extends StatelessWidget {
  const HostShareable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(color: Colors.white30, width: 1.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------------------HEADER-------------------------------------------------
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manas Hejmadi",
                          style: TextStyle(fontSize: 20.0),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => print("clicked user"),
                              child: Text(
                                "@synapse.ai",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "12h",
                              style: TextStyle(color: Colors.white30),
                            ),
                            SizedBox(
                              width: 5,
                            ),
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
              ),
              //----------------------------------------HEADER-------------------------------------------------
              SizedBox(
                height: 10.0,
              ),
              //----------------------------------------CONTENT-------------------------------------------------
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 0.5)),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Hey Guys! Check out my new application called Krustel Classroom! Its releasing exclusively on Android. Check it out using the link provided below!"),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton.icon(
                                color: Colors.black,
                                onPressed: () {},
                                icon: Icon(Icons.link),
                                label: Text("Visit Krustel Classroom"))
                          ],
                        )
                      ])),
              //---------------------------------------CONTENT-------------------------------------------------
              //---------------------------------------SubFooter-------------------------------------------------

              //---------------------------------------SubFooter-------------------------------------------------
            ],
          ),
        ),
      ],
    ));
  }
}

class HostBlog extends StatelessWidget {
  const HostBlog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlogPost();
  }
}

class HostTimeline extends StatelessWidget {
  const HostTimeline({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Timeline();
  }
}

class Reshare extends StatefulWidget {
  Reshare({Key key}) : super(key: key);

  @override
  _ReshareState createState() => _ReshareState();
}

class _ReshareState extends State<Reshare> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/MicroBlogViewer');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Reshared by ",
                style: TextStyle(color: Colors.white30),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed('/Profile'),
                child: Text(
                  "@synapse.ai",
                  style: TextStyle(color: Colors.pink),
                ),
              )
            ],
          ),
          //MicroBlogPost()
          Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        border: Border.all(color: Colors.white30, width: 1.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //----------------------------------------HEADER-------------------------------------------------
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24.0,
                              backgroundImage: NetworkImage(
                                  'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanmay Bhat",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed('/Profile'),
                                        child: Text(
                                          "@tanmaybot",
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "12h",
                                        style: TextStyle(color: Colors.white30),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Fact",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
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
                        ),
                        //----------------------------------------HEADER-------------------------------------------------
                        SizedBox(
                          height: 10.0,
                        ),
                        //----------------------------------------CONTENT-------------------------------------------------
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white10, width: 0.5)),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "is simply dummy text of the printing and typesetting industry.  remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                                ])),
                        //---------------------------------------CONTENT-------------------------------------------------
                        //---------------------------------------SubFooter-------------------------------------------------

                        //---------------------------------------SubFooter-------------------------------------------------
                      ],
                    ),
                  ),
                  ActionBar(
                    postType: "ResharedMicroblog",
                  )
                ],
              )),
        ],
      ),
    );
  }
}

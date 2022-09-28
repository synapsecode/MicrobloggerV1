import 'package:microblogger/Components/Global/globalcomponents.dart';
import 'package:microblogger/Screens/profile.dart';
import 'package:microblogger/globals.dart';
import 'package:microblogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Backend/server.dart';
import '../../origin.dart';

class UserFollowSuggestions extends StatefulWidget {
  UserFollowSuggestions();

  @override
  _UserFollowSuggestionsState createState() => _UserFollowSuggestionsState();
}

class _UserFollowSuggestionsState extends State<UserFollowSuggestions> {
  Future suggestionFuture;
  @override
  void initState() {
    suggestionFuture = getFollowSuggestions();
    super.initState();
  }

  void removeSuggestion(int index) {
    followSuggestionsCache.removeAt(index);
    setState(() {});
  }

  Widget generateSuggestions(data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Follow Suggestions",
            style: TextStyle(
                fontSize: 22.0,
                color: Origin.of(context).isCurrentPaletteDarkTheme
                    ? Colors.white70
                    : Colors.black87),
          ),
          Text(
            "Follow to get more posts on your feed",
            style: TextStyle(
                fontSize: 16.0,
                color: Origin.of(context).isCurrentPaletteDarkTheme
                    ? Colors.white70
                    : Colors.black45),
          ),
          SizedBox(height: 5.0),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(width: 1.0, color: CurrentPalette['border']),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < data.length; i++)
                    UserDisplayCard(
                      user: data[i],
                      userIndex: i,
                      del: removeSuggestion,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CachedFutureBuilder(
      cacheStore: followSuggestionsCache,
      future: suggestionFuture,
      onCacheUsed: (cache) {
        print("CACHE");
        return generateSuggestions(followSuggestionsCache);
      },
      onUpdate: (AsyncSnapshot snapshot) {
        print("UPDT");
        followSuggestionsCache = snapshot.data;
        return generateSuggestions(snapshot.data);
      },
    );
  }
}

class UserDisplayCard extends StatelessWidget {
  final Map user;
  final int userIndex;
  final Function(int) del;

  const UserDisplayCard({
    this.user,
    this.userIndex,
    this.del,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border.all(width: 1.0, color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    user['username'],
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 64,
              backgroundImage: NetworkImage(user['icon']),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 25,
            width: 180,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  user['name'],
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
            ),
          ),
          Text(
            "@${user['username']}",
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            width: 140,
            child: ElevatedButton(
              onPressed: () async {
                await followProfile(user['username']);
                Fluttertoast.showToast(
                  msg: "You are now following ${user['username']}",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  toastLength: Toast.LENGTH_SHORT,
                );
                del(userIndex); //Delete Suggestion
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.people),
                  SizedBox(width: 10.0),
                  Text("Follow")
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black54,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FollowSuggestions extends StatefulWidget {
  final suggestions;
  const FollowSuggestions(this.suggestions);

  @override
  _FollowSuggestionsState createState() => _FollowSuggestionsState();
}

class _FollowSuggestionsState extends State<FollowSuggestions> {
  List data;
  @override
  void initState() {
    super.initState();
    data = [
      {
        'username': 'synapsecode',
        'name': 'Manas H',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'pythonista',
        'name': 'Python 3',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'fluttermaster',
        'name': 'Flutter',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'dartvader',
        'name': 'Dart',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'tester123',
        'name': 'TestUser',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'segfault',
        'name': 'SegFault',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
    ];
  }

  void deleteSuggestion(index) {
    setState(() {
      data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(width: 1.0, color: Colors.white30),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < data.length; i++)
              UserCard(data[i], deleteSuggestion, i)
          ],
        ),
        // child: Row(
        //   children: [
        //     for (int i = 0; i < data.length; i++)
        //       UserCard(data[i], deleteSuggestion, i)
        //   ],
        // ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final Map suggestedUser;
  final Function del;
  final int index;
  const UserCard(this.suggestedUser, this.del, this.index);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color:
            (isFollowing) ? Color.fromARGB(100, 20, 220, 60) : Colors.black12,
        border: Border.all(width: 1.0, color: Colors.white12),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 5.0,
            ),
            CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage("${widget.suggestedUser['icon']}")),
            SizedBox(
              height: 5.0,
            ),
            Center(
              child: Text(
                "${widget.suggestedUser['name']}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 22.0, color: Colors.white),
              ),
            ),
            Text(
              "@${widget.suggestedUser['username']}",
              style: TextStyle(fontSize: 12.0, color: Colors.blue),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
                width: 140,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isFollowing = !isFollowing;
                    });
                    print("Following..");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.people),
                      SizedBox(width: 10.0),
                      Text("Follow")
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black54,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  //   return Stack(
  //     children: [
  //       Positioned(
  //         top: 8.0,
  //         right: 10.0,
  //         child: InkWell(
  //             onTap: () {
  //               print("Clicked Delete at index ${widget.index}");
  //               widget.del(widget.index);
  //             },
  //             child: Icon(
  //               Icons.clear,
  //               color: Colors.white30,
  //             )),
  //       ),
  //       Container(
  //         width: 150.0,
  //         padding: EdgeInsets.all(10.0),
  //         margin: EdgeInsets.symmetric(horizontal: 3.0),
  //         decoration: BoxDecoration(
  //           color: Colors.black12,
  //           border: Border.all(width: 1.0, color: Colors.white12),
  //         ),
  //         child: Center(
  //           child: Column(
  //             children: [
  //               SizedBox(
  //                 height: 5.0,
  //               ),
  //               CircleAvatar(
  //                   radius: 30,
  //                   backgroundImage:
  //                       NetworkImage("${widget.suggestedUser['icon']}")),
  //               SizedBox(
  //                 height: 5.0,
  //               ),
  //               Center(
  //                 child: Text(
  //                   "${widget.suggestedUser['name']}",
  //                   overflow: TextOverflow.ellipsis,
  //                   style: TextStyle(fontSize: 22.0, color: Colors.white),
  //                 ),
  //               ),
  //               Text(
  //                 "@${widget.suggestedUser['username']}",
  //                 style: TextStyle(fontSize: 12.0, color: Colors.blue),
  //               ),
  //               SizedBox(
  //                 height: 15.0,
  //               ),
  //               Container(
  //                   width: 140,
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       print("Following..");
  //                     },
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         Icon(Icons.people),
  //                         SizedBox(width: 10.0),
  //                         Text("Follow")
  //                       ],
  //                     ),
  //                     color: Colors.black54,
  //                     shape: new RoundedRectangleBorder(
  //                       borderRadius: new BorderRadius.circular(30.0),
  //                     ),
  //                   ))
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

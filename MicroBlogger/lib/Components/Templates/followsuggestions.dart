import 'package:flutter/material.dart';
import '../../Backend/datastore.dart';

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
        'username': 'manashejmadi',
        'name': 'Manas Hejmadi',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'sirihebbale',
        'name': 'Siri Hebbale',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'veeksham',
        'name': 'Veeksha M',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'sanjana13_14',
        'name': 'Sanjana S',
        'icon':
            'https://res.cloudinary.com/krustel-inc/image/upload/v1598958728/nabvmp35j9kc6ldbjr7c.png'
      },
      {
        'username': 'spandanaaa',
        'name': 'Spandana M',
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
                child: RaisedButton(
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
                  color: Colors.black54,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
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
  //                   child: RaisedButton(
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

import '../Components/Global/globalcomponents.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: NotificationList(),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 24,
        itemBuilder: (context, index) {
          if (index % 2 == 0)
            return NotificationItem(notificationType: 'Like');
          else if (index % 3 == 0)
            return NotificationItem(notificationType: 'Comment');
          else
            return NotificationItem(notificationType: 'Reshare');
        });
  }
}

class NotificationItem extends StatelessWidget {
  final String notificationType;
  const NotificationItem({this.notificationType});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.of(context).pushNamed('/MicroBlogPost'),
        child: new Container(
            margin: EdgeInsets.all(5.0),
            padding: EdgeInsets.all(10.0),
            color: Colors.black45,
            child: Container(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            (notificationType == 'Like')
                                ? Icons.favorite
                                : (notificationType == 'Reshare')
                                    ? Icons.repeat
                                    : (notificationType == 'Comment')
                                        ? Icons.mode_comment
                                        : "",
                            color: (notificationType == 'Like')
                                ? Colors.pink
                                : (notificationType == 'Reshare')
                                    ? Colors.green
                                    : (notificationType == 'Comment')
                                        ? Colors.purple
                                        : "",
                          ),
                          Text(
                            (notificationType == 'Like')
                                ? " Like"
                                : (notificationType == 'Reshare')
                                    ? " Reshare"
                                    : (notificationType == 'Comment')
                                        ? " Comment"
                                        : "",
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '@synapse.code',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context)
                                    .pushNamed('/ProfilePage'),
                              style: TextStyle(color: Colors.blue),
                            ),
                            TextSpan(
                              text: (notificationType == 'Like')
                                  ? " Liked "
                                  : (notificationType == 'Reshare')
                                      ? " Reshared "
                                      : (notificationType == 'Comment')
                                          ? " Commented on "
                                          : "",
                            ),
                            TextSpan(
                                text:
                                    "your Microblog. Click this message to redirect to the MicroBlog")
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white10, width: 0.5)),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (notificationType != "Comment")
                                    ? Text(
                                        "is simply dummy ts standard dummy text ever since the 1500 typesetting, remaining essentially unchanged. It was popularised sheets containing Lorem Ipsum passages,sum.")
                                    : Text(
                                        "I like the new Commenting Feature. Currently only Level One comments are allowed but we will expand functionality soon!")
                              ])),
                    ],
                  )),
            )));
  }
}

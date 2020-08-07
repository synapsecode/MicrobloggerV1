import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final user;
  ChatScreen({Key key, this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              //Navigator.of(context).pushNamed('/Profile');
            },
            child: Row(
              children: [
                CircleAvatar(
                  foregroundColor: Color(0xFF28a366),
                  backgroundColor: Colors.black12,
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Manas Hejmadi"),
                    Text("@synapse.code",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white24,
                        )),
                  ],
                ),
              ],
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Chat());
  }
}

class Chat extends StatefulWidget {
  @override
  State createState() => new ChatWindow();
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext ctx) {
    return Column(children: <Widget>[
      new Flexible(
          child: new ListView.builder(
        itemBuilder: (_, int index) => _messages[index],
        itemCount: _messages.length,
        reverse: true,
        padding: new EdgeInsets.all(6.0),
      )),
      new Divider(height: 1.0),
      new Container(
        child: _buildComposer(),
        decoration: new BoxDecoration(color: Theme.of(ctx).cardColor),
      ),
    ]);
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 9.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String txt) {
                  setState(() {
                    _isWriting = txt.length > 0;
                  });
                },
                onSubmitted: _submitMsg,
                decoration: new InputDecoration.collapsed(
                    hintText: "Enter some text to send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 3.0),
                child: IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isWriting
                      ? () => _submitMsg(_textController.text)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: new CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Manas Hejmadi", style: TextStyle(fontSize: 22.0)),
                  new Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    child: new Text(txt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

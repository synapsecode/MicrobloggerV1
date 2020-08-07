import 'package:flutter/material.dart';
import '../Backend/server.dart';

class PollComposer extends StatefulWidget {
  const PollComposer({Key key}) : super(key: key);

  @override
  _PollComposerState createState() => _PollComposerState();
}

class _PollComposerState extends State<PollComposer> {
  String content = "";
  List pollItems = [];

  void updateComment(x) {
    setState(() {
      content = x;
    });
  }

  void updatePollItems(x) {
    setState(() {
      pollItems.add(x);
    });
  }

  void deletePollItem(x) {
    var y = [];
    pollItems.forEach((e) {
      if (e != x) y.add(e);
    });
    setState(() {
      pollItems = y;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () async {
                print(pollItems);
                print(content);
                await createpoll(content, pollItems);
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ComposerComponent(
        contentUpdater: updateComment,
        pollItemUpdater: updatePollItems,
        pollItemDeleter: deletePollItem,
        pollItems: pollItems,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final contentUpdater;
  final pollItemUpdater;
  final pollItemDeleter;
  final List pollItems;
  const ComposerComponent(
      {this.contentUpdater,
      this.pollItemUpdater,
      this.pollItemDeleter,
      this.pollItems});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  String currentPollItem;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        flex: 1,
        child: Card(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (x) {
                  widget.contentUpdater("$x");
                },
                maxLines: 45,
                decoration:
                    InputDecoration.collapsed(hintText: "Poll Description"),
              ),
            )),
      ),
      Flexible(
        flex: 3,
        child: Card(
            color: Colors.black12,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15.0),
                  color: Colors.black26,
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          onChanged: (x) {
                            setState(() {
                              currentPollItem = x;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter Poll Option',
                          ),
                        ),
                        flex: 4,
                      ),
                      Flexible(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 15.0),
                            child: ClipOval(
                              child: Material(
                                color: Colors.black, // button color
                                child: InkWell(
                                  // inkwell color
                                  child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(Icons.add)),
                                  onTap: () {
                                    print("Poll Item Added");
                                    widget.pollItemUpdater(currentPollItem);
                                  },
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black12,
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: widget.pollItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 2.0),
                            color: Colors.white10,
                            child: ListTile(
                              leading: Container(
                                height: 20.0,
                                width: 20.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.green),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              title: Text(widget.pollItems[index]),
                              trailing: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    print("CLEAR");
                                    widget.pollItemDeleter(
                                        widget.pollItems[index]);
                                  }),
                            ),
                          );
                        }),
                  ),
                )
              ],
            )),
      ),
    ]);
  }
}

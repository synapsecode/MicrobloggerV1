import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
import 'package:MicroBlogger/origin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/server.dart';
import '../palette.dart';

class PollComposer extends StatefulWidget {
  const PollComposer({Key key}) : super(key: key);

  @override
  _PollComposerState createState() => _PollComposerState();
}

class _PollComposerState extends State<PollComposer> {
  String content = "";
  List pollItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnection(context);
  }

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
                Fluttertoast.showToast(
                  msg: "Creating Poll",
                  backgroundColor: Color.fromARGB(200, 220, 20, 60),
                );
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
  TextEditingController contentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contentController = new TextEditingController();
    contentController.text = "";
    contentController.value = TextEditingValue(
      text: "",
      selection: TextSelection.fromPosition(
        TextPosition(offset: "".length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
              color: CurrentPalette['border'],
            )),
            child: Card(
                // color: Colors.black12,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: HashTagEnabledUserTaggableTextField(
                    controller: contentController,
                    onChange: widget.contentUpdater,
                    maxlines: 20,
                    hint: "Poll Description",
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
              color: CurrentPalette['border'],
            )),
            child: Card(
              // color: Colors.black12,
              elevation: 0,
              child:
                  // color: Colors.black12,
                  Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15.0),
                    color: Origin.of(context).isCurrentPaletteDarkTheme
                        ? Colors.black12
                        : Colors.transparent,
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
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
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
                  Container(
                    color: Origin.of(context).isCurrentPaletteDarkTheme
                        ? Colors.black12
                        : Colors.transparent,
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.pollItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 2.0),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            border: Border.all(
                              color: CurrentPalette['border'],
                            ),
                          ),
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
                                widget.pollItemDeleter(widget.pollItems[index]);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TimelineComposer extends StatefulWidget {
  const TimelineComposer({Key key}) : super(key: key);

  @override
  _TimelineComposerState createState() => _TimelineComposerState();
}

class _TimelineComposerState extends State<TimelineComposer> {
  String content = "";
  List events = [];

  void updateEvent(x) {
    setState(() {
      events.add(x);
    });
  }

  void deleteEvent(x) {
    var y = [];
    events.forEach((e) {
      if (e != x) y.add(e);
    });
    setState(() {
      events = y;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentEventText;
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
              onPressed: () {
                print("TEXT: $content");
                print(events);
                //upload
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {}),
      body: ComposerComponent(
        eventUpdater: updateEvent,
        eventDeleter: deleteEvent,
        events: events,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final eventUpdater;
  final eventDeleter;
  final events;
  const ComposerComponent({this.eventUpdater, this.eventDeleter, this.events});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Card(
            color: Colors.black12,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.black12,
                    padding: EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: widget.events.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 2.0),
                            color: Colors.white10,
                            child: ListTile(
                              title: Card(
                                  color: Colors.black12,
                                  child: Container(
                                    padding: EdgeInsets.all(12.0),
                                    child: TextField(
                                      onChanged: (x) {
                                        widget.events[index] = x;
                                      },
                                      maxLines: 5,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Event Description"),
                                    ),
                                  )),
                              trailing: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    print("CLEAR");
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

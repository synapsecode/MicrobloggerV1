import 'dart:io';

import 'package:MicroBlogger/Screens/imageupload.dart';
import 'package:flutter/material.dart';
import '../Backend/server.dart';

class TimelineComposer extends StatefulWidget {
  final Map preExistingState;
  TimelineComposer({Key key, this.preExistingState}) : super(key: key);

  @override
  _TimelineComposerState createState() => _TimelineComposerState();
}

class _TimelineComposerState extends State<TimelineComposer> {
  Map state;
  String eventText = "";
  String eventName = "";
  String eventTiming = "";

  @override
  void initState() {
    state = widget.preExistingState;
    super.initState();
  }

  void updateEvent(tn, tx, et) {
    Map x = {'event_name': tn, 'description': tx, 'timestamp': et};
    setState(() {
      state['events'].add(x);
    });
  }

  void updateDesc(x) {
    setState(() {
      eventText = "$x";
    });
  }

  void updateEventName(x) {
    setState(() {
      eventName = "$x";
    });
  }

  void updateEventTiming(x) {
    setState(() {
      eventTiming = "$x";
    });
  }

  void updateTimelineName(x) {
    setState(() {
      state['timelineTitle'] = x;
    });
  }

  void deleteEvent(x) {
    var y = [];
    state['events'].forEach((e) {
      if (e['description'] != x) y.add(e);
    });
    setState(() {
      state['events'] = y;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: RaisedButton(
              onPressed: () async {
                print("TSTATE: $state");
                //upload
                await createTimeline(state['timelineTitle'], state['events'],
                    cover: state['cover']);
                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text("Publish"),
              color: Colors.black,
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () async {
                print(state);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageCapture(
                              imageFor: 'TIMELINECOVER',
                              preExistingState: widget.preExistingState,
                            )));
              },
              child: Text("Add Cover Image"),
              color: Color.fromARGB(200, 220, 20, 60),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            print("ff");
            updateEvent(eventName, eventText, eventTiming);
          }),
      body: TComposer(
        state,
        eventTextUpdater: updateDesc,
        eventNameUpdater: updateEventName,
        eventTimingUpdater: updateEventTiming,
        deleteEvent: deleteEvent,
        timelineNameUpdater: updateTimelineName,
      ),
    );
  }
}

class TComposer extends StatefulWidget {
  final eventTextUpdater;
  final eventNameUpdater;
  final eventTimingUpdater;
  final deleteEvent;
  final timelineNameUpdater;
  final Map state;
  const TComposer(this.state,
      {this.eventTextUpdater,
      this.eventNameUpdater,
      this.eventTimingUpdater,
      this.deleteEvent,
      this.timelineNameUpdater});

  @override
  _TComposerState createState() => _TComposerState();
}

class _TComposerState extends State<TComposer> {
  @override
  Widget build(BuildContext context) {
    var tNController = new TextEditingController();
    tNController.value = TextEditingValue(
      text: widget.state['timelineTitle'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['timelineTitle'].length),
      ),
    );
    return SingleChildScrollView(
      child: Container(
        color: Colors.black12,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          //The Event Displayer
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (x) {
                widget.timelineNameUpdater(x);
              },
              controller: tNController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Timeline Name',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (x) {
                widget.eventNameUpdater(x);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event Name',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (x) {
                widget.eventTimingUpdater(x);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Event Timing',
              ),
            ),
          ),
          Card(
              color: Colors.black12,
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: TextField(
                  style: TextStyle(fontSize: 19.0),
                  onChanged: (x) {
                    widget.eventTextUpdater(x);
                  },
                  maxLines: 10,
                  decoration: InputDecoration.collapsed(
                      hintText: "Start Describing the Event!"),
                ),
              )),
          if (widget.state['events'].length > 0) ...[
            Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                color: Colors.black12,
                child: Column(
                  children: [
                    Container(
                      color: Colors.black12,
                      padding: EdgeInsets.all(10.0),
                      child: ListView.builder(
                          itemCount: widget.state['events'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              color: Colors.white10,
                              child: ListTile(
                                title: Card(
                                    color: Colors.black12,
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${widget.state['events'][index]['event_name']}",
                                            style: TextStyle(fontSize: 22.0),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          TextField(
                                            enabled: false,
                                            maxLines: 5,
                                            decoration: InputDecoration.collapsed(
                                                hintText:
                                                    "${widget.state['events'][index]['description']}"),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4.0),
                                            color: Colors.black12,
                                            child: Text(
                                                "${widget.state['events'][index]['timestamp']}"),
                                          ),
                                        ],
                                      ),
                                    )),
                                trailing: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      print("CLEAR");
                                      widget.deleteEvent(widget.state['events']
                                          [index]['event_name']);
                                    }),
                              ),
                            );
                          }),
                    ),
                  ],
                )),
          ],
        ]),
      ),
    );
  }
}

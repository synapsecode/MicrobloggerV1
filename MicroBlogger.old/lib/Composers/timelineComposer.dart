import 'package:flutter/material.dart';

class TimelineComposer extends StatefulWidget {
  const TimelineComposer({Key key}) : super(key: key);

  @override
  _TimelineComposerState createState() => _TimelineComposerState();
}

class _TimelineComposerState extends State<TimelineComposer> {
  String eventText = "";
  String eventName = "";
  String eventTiming = "";
  String timelineTitle = "";
  List events = [];

  void updateEvent(tn, tx, et) {
    Map x = {'eventName': tn, 'eventText': tx, 'eventTiming': et};
    setState(() {
      events.add(x);
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

  void updateTimelineTitle(x) {
    setState(() {
      timelineTitle = "$x";
    });
  }

  void deleteEvent(x) {
    var y = [];
    events.forEach((e) {
      if (e['eventText'] != x) y.add(e);
    });
    setState(() {
      events = y;
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
              width: 220.0,
              height: 100.0,
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(hintText: "Timeline Name"),
                onChanged: (x) {
                  setState(() {
                    timelineTitle = x;
                  });
                },
              )),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: RaisedButton(
              onPressed: () {
                print(timelineTitle);
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
          onPressed: () {
            print("ff");
            updateEvent(eventName, eventText, eventTiming);
          }),
      body: ComposerComponent(
        eventTextUpdater: updateDesc,
        eventNameUpdater: updateEventName,
        eventTimingUpdater: updateEventTiming,
        deleteEvent: deleteEvent,
        events: events,
      ),
    );
  }
}

class ComposerComponent extends StatefulWidget {
  final eventTextUpdater;
  final eventNameUpdater;
  final eventTimingUpdater;
  final deleteEvent;
  final events;
  const ComposerComponent(
      {this.eventTextUpdater,
      this.eventNameUpdater,
      this.eventTimingUpdater,
      this.deleteEvent,
      this.events});

  @override
  _ComposerComponentState createState() => _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
            labelText: 'Event Timing (DD/MM/YYYY)',
          ),
        ),
      ),
      Flexible(
        flex: 1,
        child: Card(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (x) {
                  widget.eventTextUpdater(x);
                },
                maxLines: 45,
                decoration: InputDecoration.collapsed(
                    hintText: "Start Describing the Event!"),
              ),
            )),
      ),
      Flexible(
        flex: 1,
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.events[index]['eventName']}",
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
                                                  "${widget.events[index]['eventText']}"),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(4.0),
                                          color: Colors.black12,
                                          child: Text(
                                              "${widget.events[index]['eventTiming']}"),
                                        ),
                                      ],
                                    ),
                                  )),
                              trailing: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    print("CLEAR");
                                    widget.deleteEvent(
                                        widget.events[index]['eventText']);
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

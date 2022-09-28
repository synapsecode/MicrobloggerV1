import 'package:microblogger/Components/Global/globalcomponents.dart';
import 'package:microblogger/Screens/imageupload.dart';
import 'package:microblogger/origin.dart';
import 'package:microblogger/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Backend/server.dart';

class TimelineComposer extends StatefulWidget {
  final Map preExistingState;
  final bool isEditing;
  TimelineComposer({
    this.preExistingState,
    this.isEditing,
  });

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
    print(state);
    checkConnection(context);
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
            child: ElevatedButton(
              onPressed: () async {
                print("TSTATE: $state");
                //upload
                if (!widget.isEditing) {
                  Fluttertoast.showToast(
                    msg: "Creating Timeline",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  await createTimeline(state['timelineTitle'], state['events'],
                      cover: state['cover']);
                } else {
                  print("Updating Timeline");
                  Fluttertoast.showToast(
                    msg: "Updating Timeline",
                    backgroundColor: Color.fromARGB(200, 220, 20, 60),
                  );
                  if (state.containsKey('pid')) {
                    print("POST_ID: ${state['pid']}");
                    print("TIMELINE_NAME: ${state['timelineTitle']}");
                    print("EVENTS: ${state['events']}");
                    print("COVER: ${state['cover']}");
                    await editTimeline(state['pid'], state['timelineTitle'],
                        state['events'], state['cover']);
                  }
                }

                Navigator.pushNamed(context, '/HomePage');
              },
              child: Text((widget.isEditing) ? "Update" : "Publish"),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                print(state);
                (widget.isEditing)
                    ? state.putIfAbsent('isEditing', () => true)
                    : state.putIfAbsent('isEditing', () => false);
                print(state);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageCapture(
                            imageFor: 'TIMELINECOVER',
                            preExistingState: state)));
              },
              child: Text(
                  (widget.isEditing) ? "Edit Cover Image" : "Add Cover Image"),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(200, 220, 20, 60),
              ),
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
  TextEditingController eventController;
  TextEditingController tNController;
  @override
  void initState() {
    super.initState();
    tNController = new TextEditingController();
    tNController.value = TextEditingValue(
      text: widget.state['timelineTitle'],
      selection: TextSelection.fromPosition(
        TextPosition(offset: widget.state['timelineTitle'].length),
      ),
    );
    eventController = new TextEditingController();
    eventController.value = TextEditingValue(
      text: "",
      selection: TextSelection.fromPosition(
        TextPosition(offset: "".length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // color: Colors.black12,
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                border: Border.all(
              color: CurrentPalette['border'],
            )),
            child: Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: HashTagEnabledUserTaggableTextField(
                    controller: eventController,
                    onChange: widget.eventTextUpdater,
                    maxlines: 10,
                    hint: "Start Describing the Event!",
                  ),
                )),
          ),
          // Card(
          //     color: Colors.black12,
          //     margin: EdgeInsets.symmetric(horizontal: 10.0),
          //     child: Padding(
          //       padding: EdgeInsets.all(12.0),
          //       child: TextField(
          //         style: TextStyle(fontSize: 19.0),
          //         onChanged: (x) {
          //           widget.eventTextUpdater(x);
          //         },
          //         maxLines: 10,
          //         decoration: InputDecoration.collapsed(
          //             hintText: "Start Describing the Event!"),
          //       ),
          //     )),
          if (widget.state['events'].length > 0) ...[
            Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                // color: Colors.black12,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Origin.of(context).isCurrentPaletteDarkTheme
                            ? Colors.black12
                            : Colors.transparent,
                        border: Border.all(
                          color: CurrentPalette['border'],
                        ),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: ListView.builder(
                          itemCount: widget.state['events'].length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              decoration: BoxDecoration(
                                color:
                                    Origin.of(context).isCurrentPaletteDarkTheme
                                        ? Colors.black12
                                        : Colors.transparent,
                                border: Border.all(
                                  color: CurrentPalette['border'],
                                ),
                              ),
                              child: ListTile(
                                title: Card(
                                    elevation: 0,
                                    // color: Colors.black12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Origin.of(context)
                                                .isCurrentPaletteDarkTheme
                                            ? Colors.black12
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: CurrentPalette['border'],
                                        ),
                                      ),
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
                                      print(index);
                                      widget.deleteEvent(widget.state['events']
                                          [index]['description']);
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

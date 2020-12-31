import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../palette.dart';

class YoutubeElement extends StatefulWidget {
  final Map data;
  YoutubeElement(this.data, {key});

  @override
  _YoutubeElementState createState() => _YoutubeElementState();
}

class _YoutubeElementState extends State<YoutubeElement> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      flags: YoutubePlayerFlags(autoPlay: false),
      initialVideoId: widget.data['videoID'],
    )..addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Colors.white30, width: 1.0)),
        padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 5.0),
        child: Column(
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.data['author']['icon']),
              ),
              title: Text(widget.data['author']['name']),
              subtitle: Row(
                children: [
                  Text("@${widget.data['author']['username']}   •"),
                  SizedBox(width: 10.0),
                  Text(
                    "YoutubeElement",
                    style: TextStyle(
                      color: Color.fromARGB(200, 220, 20, 60),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.data['content'],
              style: TextStyle(color: CurrentPalette['transparent_text']),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: Color.fromARGB(200, 220, 20, 60),
                  border: Border.all(color: Colors.white30, width: 1.0)),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
              ),
            ),
          ],
        ));

    //     YoutubePlayerBuilder(
    //   onExitFullScreen: () {
    //     // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
    //     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    //   },
    //   player: YoutubePlayer(
    //     controller: _controller,
    //     showVideoProgressIndicator: true,
    //     progressIndicatorColor: Colors.blueAccent,
    //     topActions: <Widget>[
    //       const SizedBox(width: 8.0),
    //       Expanded(
    //         child: Text(
    //           _controller.metadata.title,
    //           style: const TextStyle(
    //             color: Colors.white,
    //             fontSize: 18.0,
    //           ),
    //           overflow: TextOverflow.ellipsis,
    //           maxLines: 1,
    //         ),
    //       ),
    //       IconButton(
    //         icon: const Icon(
    //           Icons.settings,
    //           color: Colors.white,
    //           size: 25.0,
    //         ),
    //         onPressed: () {
    //           print('Settings Tapped!');
    //         },
    //       ),
    //     ],
    //     onReady: () {
    //       _isPlayerReady = true;
    //     },
    //   ),
    //   builder: (context, player) => Scaffold(
    //     key: _scaffoldKey,
    //     appBar: AppBar(
    //       leading: Padding(
    //         padding: const EdgeInsets.only(left: 12.0),
    //         child: Image.asset(
    //           'assets/env.png',
    //           fit: BoxFit.fitWidth,
    //         ),
    //       ),
    //       title: const Text(
    //         'Youtube Player Flutter',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //       actions: [],
    //     ),
    //   ),
    // ));
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/*
YoutubePlayerController _controller =
                          YoutubePlayerController(
                        initialVideoId: 'QmX2NPkJTKg',
                        flags: YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                        ),
                      );
                      output = YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        // videoProgressIndicatorColor: Colors.amber,
                        // progressColors: ProgressColors(
                        //     playedColor: Colors.amber,
                        //     handleColor: Colors.amberAccent,
                        // ),
                        // onReady () {
                        //     _controller.addListener(listener);
                        // },
                      );
*/

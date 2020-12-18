import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioElement extends StatefulWidget {
  const AudioElement({Key key}) : super(key: key);

  @override
  _AudioElementState createState() => _AudioElementState();
}

class _AudioElementState extends State<AudioElement> {
  int cseconds = 0;
  int fseconds = 1;
  String ctime = "00:00";
  String ftime = "00:00";
  double frac = 0.0;
  AudioPlayerState playerState = AudioPlayerState.PAUSED;
  AudioPlayer player;
  bool durationFound = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    start('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
    player.onDurationChanged.listen((Duration d) {
      if (!durationFound)
        setState(() {
          fseconds = d.inSeconds;
          ftime = displayFormattedTime(fseconds);
          durationFound = true;
          print("Duration: ($fseconds)s | $ftime");
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
    player.dispose();
  }

  String displayFormattedTime(int seconds) {
    String m = (seconds / 60).toString().split(".")[0];
    String s = (seconds % 60).toString();
    m = (int.parse(m) < 10) ? '0$m' : m;
    s = (int.parse(s) < 10) ? '0$s' : s;
    return "$m:$s";
  }

  int convertToSeconds(String s) {
    List<String> x = s.split(":");
    return (int.parse(x[0]) * 60 + int.parse(x[1]));
  }

  start(String url) async {
    await player.setUrl(url);
    await player.setReleaseMode(ReleaseMode.STOP);
  }

  resume() async {
    await player.resume();
  }

  seek(int seconds) async {
    await player.seek(Duration(milliseconds: seconds * 1000));
  }

  pause() async {
    await player.pause();
  }

  @override
  Widget build(BuildContext context) {
    //AudioPosition Updater
    player.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        cseconds = p.inSeconds;
        frac = cseconds / fseconds;
      });
    });

    player.onPlayerStateChanged
        .listen((AudioPlayerState s) => setState(() => playerState = s));

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(70)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white30,
            ),
            height: 50.0,
            width: 310.0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon((playerState != AudioPlayerState.PLAYING)
                      ? Icons.play_arrow
                      : Icons.pause),
                  onPressed: () {
                    setState(() {
                      (playerState == AudioPlayerState.PLAYING)
                          ? pause()
                          : resume();
                    });
                  },
                ),
                Text(
                  "${displayFormattedTime(cseconds)} / $ftime",
                  style: TextStyle(fontSize: 12.0),
                ),
                Expanded(
                  child: Slider(
                    activeColor: Colors.green,
                    inactiveColor: Colors.white10,
                    value: frac,
                    onChanged: (x) {
                      setState(() => frac = x);
                    },
                    onChangeEnd: (x) {
                      int nt =
                          int.parse((x * fseconds).toString().split(".")[0]);
                      print("changed: $x | newtime: ($nt)s");
                      seek(nt);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

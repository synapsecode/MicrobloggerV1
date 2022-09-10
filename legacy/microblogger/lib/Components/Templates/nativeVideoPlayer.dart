import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/src/chewie_player.dart';

// class VideoCarousel extends StatefulWidget {
//   VideoCarousel();

//   @override
//   _VideoCarouselState createState() => _VideoCarouselState();
// }

// class _VideoCarouselState extends State<VideoCarousel> {
//   PageController _controller = new PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10.0),
//       margin: EdgeInsets.symmetric(vertical: 5.0),
//       decoration: BoxDecoration(
//           color: Colors.black12,
//           border: Border.all(color: Colors.white24, width: 1.0)),
//       child: Column(),
//     );
//   }

class NativeVideoPlayer extends StatefulWidget {
  final String link;
  NativeVideoPlayer(this.link);

  @override
  _NativeVideoPlayerState createState() => _NativeVideoPlayerState();
}

class _NativeVideoPlayerState extends State<NativeVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all(color: Colors.white24, width: 1.0)),
      child: Player(
        videoPlayerController: VideoPlayerController.network(widget.link),
      ),
    );
  }
}

class Player extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  Player({@required this.videoPlayerController, this.looping});

  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  ChewieController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (BuildContext context, String errorMessage) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
                child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _controller,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _controller.dispose();
  }
}

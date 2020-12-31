// import 'dart:io';

// import 'package:MicroBlogger/Components/Global/globalcomponents.dart';
// import 'package:MicroBlogger/palette.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';

// class NetworkVideo extends StatefulWidget {
//   final String url;
//   const NetworkVideo({this.url});

//   @override
//   _NetworkVideoState createState() => _NetworkVideoState();
// }

// class _NetworkVideoState extends State<NetworkVideo> {
//   VideoPlayerController _controller;
//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(widget.url)
//       ..initialize().then((_) {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..play();
//     super.initState();
//   }

//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _controller.value.initialized
//           ? AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             )
//           : Column(
//               children: [
//                 CirclularLoader(
//                   color: Colors.white30,
//                   strokeWidth: 2,
//                 ),
//                 Container(
//                   child: Text(
//                     "Loading Video",
//                     style: TextStyle(
//                       color: Colors.white30,
//                       fontSize: 12,
//                     ),
//                   ),
//                   transform: Matrix4.translationValues(0.0, -13.0, 0.0),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class FileVideo extends StatefulWidget {
//   final File file;
//   const FileVideo({this.file});

//   @override
//   _FileVideoState createState() => _FileVideoState();
// }

// class _FileVideoState extends State<FileVideo> {
//   File _video;
//   final picker = ImagePicker();

// // // This funcion will helps you to pick a Video File
// // _pickVideo() async {
// //     PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
// //      _video = File(pickedFile.path);
// //     _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
// //       setState(() { });
// //       _videoPlayerController.play();
// //     });
// // }

//   VideoPlayerController _controller;
//   @override
//   void initState() {
//     _controller = VideoPlayerController.file(widget.file)
//       ..initialize().then((_) {
//         setState(() {});
//       })
//       ..setLooping(true)
//       ..play();
//     super.initState();
//   }

//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _controller.value.initialized
//           ? FittedBox(
//               fit: BoxFit.cover,
//               child: SizedBox(
//                 height: _controller.value.size.height,
//                 width: _controller.value.size.width,
//                 child: VideoPlayer(_controller),
//               ),
//             )
//           : Column(
//               children: [
//                 CirclularLoader(
//                   color: Colors.white30,
//                   strokeWidth: 2,
//                 ),
//                 Container(
//                   child: Text(
//                     "Loading Video",
//                     style: TextStyle(
//                       color: Colors.white30,
//                       fontSize: 12,
//                     ),
//                   ),
//                   transform: Matrix4.translationValues(0.0, -13.0, 0.0),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class TesterPage extends StatefulWidget {
//   const TesterPage({Key key}) : super(key: key);

//   @override
//   _TesterPageState createState() => _TesterPageState();
// }

// class _TesterPageState extends State<TesterPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Test"),
//       ),
//       body: NetworkVideo(
//           url:
//               "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4"),
//     );
//   }
// }

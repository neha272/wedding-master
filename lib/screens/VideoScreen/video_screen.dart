import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:video_viewer/video_viewer.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  const VideoScreen({required this.url, Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  // VideoPlayerController? _controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
    // _controller = VideoPlayerController.network(widget.url)
    //   ..initialize().then((_) {
    //     setState(() {});
    //   })
    //   ..play();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
    // if (_controller != null) {
    //   _controller!.dispose();
    // }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: _controller != null
    //         ? _controller!.value.isInitialized
    //             ? AspectRatio(
    //                 aspectRatio: _controller!.value.aspectRatio,
    //                 child: VideoPlayer(_controller!),
    //               )
    //             : const CircularProgressIndicator()
    //         : const CircularProgressIndicator(),
    //   ),
    // );
    return VideoViewer(
      controller: VideoViewerController(),
      enableFullscreenScale: false,
      onFullscreenFixLandscape: false,
      autoPlay: true,
      source: {
        "SubRip Text": VideoSource(
          video: VideoPlayerController.network(widget.url),
        )
      },
    );
  }
}

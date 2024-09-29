// highlight.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../model/video.dart';

class HighlightModal extends StatefulWidget {
  final Video highlight;
  final Duration startTime; // Start time of the highlight
  final Duration duration; // Duration of the highlight

  HighlightModal({required this.highlight, required this.startTime, this.duration = const Duration(seconds: 600)});

  @override
  _HighlightModalState createState() => _HighlightModalState();
}

class _HighlightModalState extends State<HighlightModal> {
  late VideoPlayerController _controller;
  late Duration endTime;

  @override
  void initState() {
    super.initState();
    endTime = widget.startTime + widget.duration;
    _controller = VideoPlayerController.asset(widget.highlight.videoPath)
      ..initialize().then((_) {
        setState(() {
          _controller.seekTo(widget.startTime);
          _controller.play();
          _controller.addListener(_checkEndTime);
        });
      }).catchError((error) {
        print("Error initializing video: $error");
      });
  }

  void _checkEndTime() {
    if (_controller.value.position >= endTime) {
      _controller.pause();
      _controller.seekTo(widget.startTime);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkEndTime);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(child: CircularProgressIndicator()),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

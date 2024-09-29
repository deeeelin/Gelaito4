import 'package:flutter/material.dart';

class VideoSummaryWidget extends StatefulWidget {
  final String summary;

  VideoSummaryWidget({required this.summary});

  @override
  _VideoSummaryWidgetState createState() => _VideoSummaryWidgetState();
}

class _VideoSummaryWidgetState extends State<VideoSummaryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.summary,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.summary,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Show less' : 'Show more',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genai_v2/view/home.dart';
import '../viewmodel/video_vm.dart';
import '../model/video.dart';
import 'highlight.dart';
import '../view/video_player.dart';
import '../view/video_summary.dart';

class FullVideoPage extends StatelessWidget {
  FullVideoPage({super.key});
  final viewModel = VideoViewModel('Full Video Title'); // Adjust as necessary to handle the video data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(context),
      body: FutureBuilder<void>(
        future: viewModel.loadVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading videos'));
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVideoPlayerSection(),
                  _buildVideoSummarySection(),
                  Divider(color: Colors.grey[800], thickness: 1),
                  _buildVideoHighlightsSection(context),
                  Divider(color: Colors.grey[800], thickness: 1),
                  _buildSimilarVideosSection(context),
                  Divider(color: Colors.grey[800], thickness: 1),
                  _buildCommentsSection(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '                Gelaito4',
            style: TextStyle(
              fontFamily: 'Pacifico', // Replace with your font family
              fontSize: 24, // Adjust the size as needed
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.cast, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            // Handle notifications
          },
        ),
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Handle search
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            // Handle account
          },
        ),
      ],
    );
  }

  Widget _buildVideoPlayerSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: VideoPlayerWidget(videoPath: 'assets/fullvideo.mp4'),
      ),
    );
  }

  Widget _buildVideoSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '2016-17 歐洲冠軍聯賽 - 6⧸4 皇家馬德里 VS 尤文圖斯 (冠軍賽)',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.white70),
                  SizedBox(width: 5),
                  Text(
                    '123K',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.thumb_down, color: Colors.white70),
                  SizedBox(width: 5),
                  Text(
                    '4K',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.share, color: Colors.white70),
                  SizedBox(width: 5),
                  Text(
                    'Share',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.download, color: Colors.white70),
                  SizedBox(width: 5),
                  Text(
                    'Download',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.playlist_add, color: Colors.white70),
                  SizedBox(width: 5),
                  Text(
                    'Save',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          VideoSummaryWidget(summary: """In this incredible UEFA Champions League match, Barcelona defeated Paris Saint-Germain 6-1, achieving a historic comeback to advance to the next stage. This match has become one of the greatest comebacks in football history, stunning football fans around the world.

The match began with Barcelona showing a strong attacking intent, and in the 3rd minute, Luis Suárez scored the opening goal, breaking the deadlock early. This early goal gave Barça immense confidence and momentum while putting enormous pressure on PSG.

As the match progressed, Barcelona continued to apply pressure and create chances. In the 40th minute, a clever interception and pass by Andrés Iniesta led to an own goal by Layvin Kurzawa, making it 2-0. By halftime, Barcelona had already significantly reduced the deficit.

After the second half began, Barcelona did not slow down. In the 50th minute, Lionel Messi converted a penalty, making the score 3-0. At this point, the atmosphere of the entire match became even more tense, and PSG’s defense started to show cracks.

However, in the 62nd minute, Edinson Cavani's goal seemed to give PSG a glimmer of hope. This goal meant Barcelona needed to score at least three more goals to advance. PSG appeared to stabilize and began attempting to run down the clock to maintain their aggregate lead.

As the match entered its final stages, Barcelona demonstrated incredible resilience and determination. In the 88th minute, Neymar scored a beautiful free kick, making it 4-1. Shortly after, in the 91st minute, he scored another penalty, bringing the score to 5-1. At this point, Barcelona needed just one more goal to advance.

Finally, in the dying moments of the match, in the 95th minute, Sergi Roberto received a pass from Neymar and scored the decisive goal, sealing a 6-1 victory for Barcelona. This incredible goal meant Barcelona advanced with a total score of 6-5, creating one of the greatest comebacks in Champions League history.

This match not only showcased the technical and tactical prowess of Barcelona's players but also their incredible tenacity and belief. Faced with a seemingly insurmountable deficit, they never gave up and continued to relentlessly attack PSG’s defense, ultimately achieving a historic victory. This match will forever be remembered as one of the most classic encounters in football history."""),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildVideoHighlightsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Highlights',
            style: TextStyle(
              fontFamily: 'Pacifico', // Replace with your font family
              fontSize: 24, // Adjust the size as needed
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _buildAnimatedVideoList(viewModel.videoHighlights),
        ],
      ),
    );
  }

  Widget _buildSimilarVideosSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Videos',
            style: TextStyle(
              fontFamily: 'Pacifico', // Replace with your font family
              fontSize: 24, // Adjust the size as needed
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _buildAnimatedVideoList(viewModel.similarVideos),
        ],
      ),
    );
  }

  Widget _buildAnimatedVideoList(List<Video> videos) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 16 / 9,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder(
          tween: Tween(begin: Offset(0, 100), end: Offset.zero),
          duration: Duration(milliseconds: 606000),
          curve: Curves.easeOut,
          builder: (context, Offset offset, child) {
            return Transform.translate(
              offset: offset,
              child: child,
            );
          },
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => HighlightModal(
                  highlight: videos[index],
                  startTime: Duration.zero,
                ),
              );
            },
            child: _buildHighlightCard(videos[index]),
          ),
        );
      },
    );
  }

  Widget _buildHighlightCard(Video video) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.network(
                  video.imagePath,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  color: Colors.black54,
                  child: Text(
                    video.duration,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('channel_icon.png'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Channel Name',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                      Text(
                        '123K views • 1 day ago',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10, // Example: number of comments
            itemBuilder: (context, index) {
              return _buildCommentCard();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'This is a sample comment to demonstrate the comment section layout.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

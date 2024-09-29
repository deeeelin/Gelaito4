import 'package:flutter/material.dart';
import 'package:genai_v2/model/video.dart';
import 'package:genai_v2/view/category_videos_page.dart';
import 'package:genai_v2/viewmodel/video_vm.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});
  final viewModel = VideoViewModel('Categories'); // Ensure this is available

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('Categories',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 30, color: Colors.white)),
      ),
      body: FutureBuilder<Map<String, List<Video>>>(
        future: viewModel.categorizedVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading categories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.keys.length,
            itemBuilder: (context, index) {
              final category = categories.keys.elementAt(index);
              final videos = categories[category]!;
              final validVideo = videos.firstWhere(
                  (video) => video.imagePath.isNotEmpty && video.imagePath != 'default_image_path',
                  orElse: () => videos.first);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryVideosPage(category: category, videos: videos),
                    ),
                  );
                },
                child: _buildCategoryCard(category, validVideo),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(String category, Video video) {
    return Container(
      margin: EdgeInsets.all(8),
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
                child: _buildImage(video.imagePath),
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
            child: Text(
              category,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    print('Image URL: $imagePath');
    return imagePath.isEmpty || imagePath == 'default_image_path'
        ? Image.asset(
            'assets/crossover.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          )
        : Image.network(
            imagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('${error.toString()}, Failed to load image: $imagePath, using default image');
              return Image.asset(
                'assets/crossover.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              );
            },
          );
  }
}

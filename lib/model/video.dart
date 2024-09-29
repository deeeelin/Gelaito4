class Video {
  final String title;
  final String imagePath;
  final String duration;
  final String videoPath;
  final String summary;

  Video({
    required this.title,
    required this.imagePath,
    required this.duration,
    required this.videoPath,
    required this.summary,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'] ?? 'No Title',
      imagePath: (json['imagePath'] != null && json['imagePath'] != '') ? json['imagePath'] : 'default_image_path',
      duration: json['duration'] ?? '0:00',
      videoPath: json['videoPath'] ?? '',
      summary: json['summary'] ?? 'No Description',
    );
  }
}

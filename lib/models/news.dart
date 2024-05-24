class News {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String media;
  final String body;

  News({
    required this.id,
    required this.title, 
    required this.description,
    required this.imageUrl,
    required this.media,
    required this.body,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String, 
      media: json['media'] as String,
      body: json['body'] as String,
    );
  }
}

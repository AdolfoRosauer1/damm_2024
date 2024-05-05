class News{
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String media;
  final String? body;

  News({
    required this.id,
    required this.title, 
    required this.description,
    required this.imageUrl,
    required this.media,
    this.body
  });


}
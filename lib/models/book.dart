class Book {
  const Book({required this.title, required this.id, required this.imageUrl});

  factory Book.fromJson(Map<String, dynamic> json) => Book(
      title: json["title"], id: json["isbn"], imageUrl: json["largeImageUrl"]);

  final String title;

  final String id;
  final String imageUrl;
}

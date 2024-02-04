class Book{
  const Book({
    required this.title,
});

  factory Book.fromJson(Map<String, dynamic> json)=> Book(title: json["title"]);

  final String title;
}
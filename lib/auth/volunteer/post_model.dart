class Post {
  final int? id;
  final String title;
  final String content;
  final String author;
  final int? state;
  final String created_at;
  final String? updated_at;
  final String cityName;

  Post({
    required this.title,
    required this.content,
    required this.author,
    this.id,
    this.state,
    required this.created_at,
    this.updated_at,
    required this.cityName,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      state: json['state'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      title: json['title'],
      content: json['content'],
      author: json['author'].toString(),
      cityName: json['city_data']?['name'] ?? '',
    );
  }
}

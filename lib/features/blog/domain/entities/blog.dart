// ignore_for_file: public_member_api_docs, sort_constructors_first

class Blog {
  final String id;
  final String content;
  final String title;
  final String posterId;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String? posterName;

  Blog({
    required this.id,
    required this.content,
    required this.title,
    required this.posterId,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    required this.posterName,
  });

}
